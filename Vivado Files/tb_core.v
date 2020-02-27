`timescale 1ns / 1ps

module tb_core();
	
	reg CLK;
	reg nrst;

	reg int_sig;
	reg [3:0] BTN;
	reg [2:0] SW;
	reg [3:0] LED;

	reg [3:0] con_write;
	reg [9:0] con_addr;
	reg [31:0] con_in;
	wire [31:0] con_out;

	core CORE(
		.CLK(CLK),
		.nrst(nrst),

		.con_write(con_write),
		.con_addr(con_addr),
		.con_in(con_in),

		.con_out(con_out)
	);

	answerkey AK();

	always
		#10 CLK = ~CLK;		// 50MHz clock

	integer i, check, done, pass;
	integer clock_counter;

	// For checking instructions loaded
	wire [31:0] INST;
	assign INST = CORE.if_inst;

	/********************************
	wire [9:0] data_addr;
	assign data_addr = CORE.mem_ALUout[11:2];
	/********************************/

	initial begin
		CLK = 0;
		nrst = 0;

		int_sig = 1;
		BTN = 0;
		SW = 0;
		LED = 0;

		con_write = 0;
		con_addr = 10'h0;
		con_in = 0;

		done = 0;
		check = 0;
		pass = 0;
		i = 0;
		#100;
		nrst = 1;
	end

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

	// Checking for 10 NOPs/looping jals in a row
	always@(posedge CLK) begin
		if(INST == 32'h0000006f) begin
			check = check + 1;
		end else begin
			check = 0;
		end
	end
	always@(posedge CLK) begin
		if(check == 10)
			done = 1;
	end

	// Tracking how many clock cycles it takes to execute the program
	always@(posedge CLK) begin
		if(!nrst)
			clock_counter <= 0;
		else
			if(!done)
				clock_counter <= clock_counter + 1;
	end

	// The following code snippet is for checking the contents of
	// the memory when RTL_RAM is used (if it was coded in Verilog)
	// Displaying Memory contents
	/*always@(posedge done) begin
		$display("===| SUMMARY |===");
		$display("Actual  \tExpected");
		$display("========\t========");
		for(i = 0; i < 100; i = i + 1) begin
			//$display("%X\t%X", CORE.DATAMEM.memory[i], AK.memory[i]);
			if(CORE.DATAMEM.memory[i] == AK.memory[i]) begin
				$display("%X\t%X\tPass", CORE.DATAMEM.memory[i], AK.memory[i]);
				pass = pass + 1;
			end else begin
				$display("%X\t%X\tFail", CORE.DATAMEM.memory[i], AK.memory[i]);
			end
		end
		$display("\n");
		$display("Passed %d/%d test cases.\n=================", pass, i);
		$finish;
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
				$display("0x%3X\t0x%X\t0x%X\tPass", con_addr, con_out, AK.memory[con_addr]);
				pass = pass + 1;
			end else begin
				$display("0x%3X\t0x%X\t0x%X\tFail", con_addr, con_out, AK.memory[con_addr]);
			end

			i = i + 1;

			if(con_addr == 63) begin			
				$display("\n");
				$display("Passed %d/%d test cases.\nClock cycles: %d\n=================", pass, i, clock_counter);
				$finish;
			end
			
			con_addr = con_addr + 1;
		end
	end
endmodule

// ANSWER KEY
module answerkey();
	reg [31:0] memory [0:1023];
	initial begin
		$readmemh("answerkey.mem", memory);
	end
endmodule