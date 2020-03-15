`timescale 1ns / 1ps

module tb_core_synth();
	
	reg CLK;
	reg nrst;

	reg int_sig;
	reg [3:0] BTN;
	reg [2:0] SW;
	wire [3:0] LED;

	reg [3:0] con_write;
	reg [9:0] con_addr;
	reg [31:0] con_in;
	wire [31:0] con_out;

	// Debug signals for post-synthesis simulations
	wire [11:0] if_PC;
	wire [11:0] id_PC;
	wire [11:0] exe_PC;
	wire [11:0] mem_PC;
	wire [11:0] wb_PC;
	wire [31:0] if_inst;
	wire if_stall;
	wire ISR_PC_flush;
	wire ISR_pipe_flush;
	wire ISR_running;
	wire [11:0] save_PC;
	wire jump_flush;
	wire branch_flush;
	wire exe_is_stype;
	wire [3:0] exe_dm_write;
	wire [31:0] exe_ALUout;
	wire [2:0] wb_sel_data;
	wire [31:0] wb_wr_data;

	core CORE(
		.CLK(CLK),
		.nrst(nrst),

		.int_sig(int_sig),
		.BTN(BTN),
		.SW(SW),
		.LED(LED),

		.con_write(con_write),
		.con_addr(con_addr),
		.con_in(con_in),
		.con_out(con_out),

		// Debug signals for post-synthesis simulations
		.if_PC(if_PC),
		.id_PC(id_PC),
		.exe_PC(exe_PC),
		.mem_PC(mem_PC),
		.wb_PC(wb_PC),
		.if_inst(if_inst),
		.if_stall(if_stall),
		.ISR_PC_flush(ISR_PC_flush),
		.ISR_pipe_flush(ISR_pipe_flush),
		.ISR_running(ISR_running),
		.save_PC(save_PC),
		.jump_flush(jump_flush),
		.branch_flush(branch_flush),
		.exe_is_stype(exe_is_stype),
		.exe_dm_write(exe_dm_write),
		.exe_ALUout(exe_ALUout),
		.wb_sel_data(wb_sel_data),
		.wb_wr_data(wb_wr_data)
	);

	answerkey AK();

	always
		#10 CLK = ~CLK;		// 50MHz clock

	// Integers for checking results through the answer key
	integer i = 0, check = 0, done = 0, pass = 0;
	integer total_test_cases = 0;
	integer print_metrics = 0;

	// Various counters for checking performance of the core
	integer clock_counter, stall_counter, cumulative_stall_counter;
	integer cumulative_flush_counter;

	// Counter for NOPs (base & compressed versions)
	integer nop_counter;

	// Tracking "highest" data address written to for
	// displaying only what's needed in the answer key
	// (since there is no need to display the addresses
	// not written to)
	integer max_data_addr = 0;

	// For checking instructions loaded
	wire [31:0] INST = if_inst;
	reg [31:0] last_inst;

	/********************************
	wire [9:0] data_addr;
	assign data_addr = CORE.mem_ALUout[11:2];
	/********************************/

	initial begin
		CLK = 0;
		nrst = 0;

		int_sig = 0;
		BTN = 0;
		SW = 0;

		con_write = 0;
		con_addr = 10'h0;
		con_in = 0;

		check = 0;
		done = 0;
		pass = 0;
		i = 0;
		last_inst = 0;

		#100 nrst = 1;
		// #5000 int_sig = 0;
		// #2000 int_sig = 0;
	end

	// NOTE: THIS SECTION SHOULD BE USED ONCE EXE_INST, MEM_INST, & WB_INST ARE REMOVED
	// FROM THE CORE.
	/*
	reg [31:0] exe_inst, mem_inst, wb_inst;
	always@(posedge CLK) begin
		if(!nrst) begin
			exe_inst <= 0;
			mem_inst <= 0;
			wb_inst <= 0;
		end else begin
			exe_inst <= CORE.id_inst;
			mem_inst <= exe_inst;
			wb_inst <= mem_inst;
		end
	end
	*/

	// Checking for a repeated instruction
	always@(posedge CLK)
		if (INST == last_inst) check = check + 1;
		else check = 0;

	always@(posedge CLK)
		last_inst <= INST;

	always@(posedge CLK)
		if(check == 50) done = 1;

	// Tracking how many clock cycles it takes to execute the program
	always@(posedge CLK) begin
		if(!nrst)
			clock_counter <= 0;
		else
			if(!done)
				clock_counter <= clock_counter + 1;
	end

	// Tracking how many cycles each stall takes
	always@(posedge CLK) begin
		if(!nrst)
			stall_counter <= 0;
		else if(!done)
			if(if_stall)
				stall_counter <= stall_counter + 1;
			else
				stall_counter <= 0;
	end

	// Tracking total clock cycles the pipeline was stalled
	always@(posedge CLK) begin
		if(!nrst)
			cumulative_stall_counter <= 0;
		else if(!done)
			if(if_stall)
				cumulative_stall_counter <= cumulative_stall_counter + 1;
	end

	// Tracking total clock cycles "wasted" due to flushing (not counting flushing due to stall conditions)
	always@(posedge CLK) begin
		if(!nrst)
			cumulative_flush_counter <= 0;
		else if(!done)
			if(ISR_PC_flush || ISR_pipe_flush || jump_flush)
				cumulative_flush_counter <= cumulative_flush_counter + 1;
			else if(branch_flush)
				cumulative_flush_counter <= cumulative_flush_counter + 2;
	end

	// This controls max_data_addr
	always@(posedge CLK) begin
		if(!nrst)
			max_data_addr <= 0;
		else if(!done) 
			if(exe_is_stype && |exe_dm_write && exe_ALUout[12:2] > max_data_addr)
				max_data_addr <= exe_ALUout[12:2];
	end

	// This controls the NOP counter
	always@(posedge CLK) begin
		if(!nrst)
			nop_counter <= 0;
		else if(!done)
			if(INST[15:0] == 16'h0001 || INST == 32'h00000013)
				nop_counter <= nop_counter + 1;
	end
/*
	always@(posedge CLK) begin
		if(clock_counter == 6) begin
			#3 BTN[1] = 1;
			int_sig = 1;	
		end

		if(clock_counter == 100) begin
			#3 BTN[1] = 0;
			int_sig = 0;	
		end

		if(clock_counter == 4976) begin
			#3 BTN[2] = 1;
			int_sig = 1;	
		end

		if(clock_counter == 5100) begin
			#3 BTN[2] = 0;
			int_sig = 0;	
		end

		if(clock_counter == 7400) begin
			#3 BTN[3] = 1;
			int_sig = 1;	
		end

		if(clock_counter == 7500) begin
			#3 BTN[3] = 0;
			int_sig = 0;	
		end
	end*/

	// The following code snippet is for checking the contents
	// of BLOCKMEM
	always@(posedge done) begin
		$display("---------| SUMMARY |---------");
		$display("Address\t  Actual  \tExpected ");
		$display("=======\t==========\t==========");	
	end

	always@(negedge CLK) begin
		if(done) begin	
			if(con_out == AK.memory[con_addr]) begin
				//$display("0x%3X\t0x%X\t0x%X\tPass", con_addr, con_out, AK.memory[con_addr]);
				pass = pass + 1;
			end else begin
				$display("0x%3X\t0x%X\t0x%X\tFail--------------------", con_addr, con_out, AK.memory[con_addr]);
			end

			total_test_cases = total_test_cases + 1;
			if(con_addr == max_data_addr) print_metrics = 1;
			con_addr = con_addr + 1;
		end
	end

	always@(posedge print_metrics) begin
		i = 0;
		done = 0;
		$display("\n");
		$display("Passed %0d/%0d test cases.\nClock cycles: %0d", pass, total_test_cases, clock_counter-50);
		$display("Total cycles stalled: %0d", cumulative_stall_counter);
		$display("Total cycles flushed: %0d", cumulative_flush_counter);
		$display("Total NOPs: %0d", nop_counter);
		$display("=================\n");
		$finish;
	end
endmodule

// ANSWER KEY
module answerkey();
	reg [31:0] memory [0:1023];
	initial begin
		$readmemh("answerkey.mem", memory);
	end
endmodule