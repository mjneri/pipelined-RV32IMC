`timescale 1ns / 1ps

`include "constants.vh"

module tb_core();
	
	reg CLK;
	reg nrst;

	reg [`INT_SIG_WIDTH-1:0] int_sig;

	reg [3:0] con_write;
	reg [`DATAMEM_BITS:0] con_addr;
	reg [`WORD_WIDTH-1:0] con_in;
	wire [`WORD_WIDTH-1:0] con_out;

	reg [`WORD_WIDTH-1:0] last_inst;

	core CORE(
		.CLKIP_OUT(CLK),
		.CLK_BUF(CLK),
		.nrst(nrst),

		.int_sig(int_sig),

		.con_write(con_write),
		.con_addr(con_addr),
		.con_in(con_in),

		.con_out(con_out)
	);

	answerkey AK();

	always
		#10 CLK = ~CLK;		// 50MHz clock

	// Integers for checking results through the answer key
	integer i, j, check, done, pass, consecutive_nops;
	integer total_test_cases = 0;
	integer print_metrics = 0;

	// Various counters for checking performance of the core
	integer clock_counter, stall_counter, cumulative_stall_counter;
	integer cumulative_flush_counter;
	integer if_clk_counter, id_clk_counter, exe_clk_counter, mem_clk_counter, wb_clk_counter, rf_clk_counter;

	// Counters for checking BHT accuracy for each entry
	reg [31:0] bht_correct [0:`BHT_ENTRY-1];
	reg [31:0] bht_accesses [0:`BHT_ENTRY-1];
	reg [31:0] bht_overwrites [0:(`BHT_ENTRY/4)-1];
	integer total_bht_correct, total_bht_accesses, total_bht_overwrites;

	// Counter for NOPs (base & compressed versions)
	integer nop_counter;

	// Tracking "highest" data address written to for
	// displaying only what's needed in the answer key
	// (since there is no need to display the addresses
	// not written to)
	integer max_data_addr;

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

		int_sig = 0;
		// BTN = 0;
		// SW = 0;
		last_inst = 0;

		con_write = 0;
		con_addr = 10'h0;
		con_in = 0;

		done = 0;
		check = 0;
		pass = 0;
		i = 0;
		j = 0;

		// Initializing counters
		clock_counter = 0;
		if_clk_counter = 0;
		id_clk_counter = 0;
		exe_clk_counter = 0;
		mem_clk_counter = 0;
		wb_clk_counter = 0;
		rf_clk_counter = 0;

		#100 nrst = 1;
	end
	
	reg [`WORD_WIDTH-1:0] exe_inst, mem_inst, wb_inst;
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

	reg [`PC_ADDR_BITS-1:0] mem_PC, wb_PC;
	always@(posedge CLK) begin
		if(!nrst) begin
			mem_PC <= 0;
			wb_PC <= 0;
		end else begin
			mem_PC <= CORE.exe_PC;
			wb_PC <= mem_PC;
		end
	end
	

	// Checking for 10 NOPs/looping jumps in a row
	// NOTE: checking for last_inst should be done for at least 50 cycles
	// if there are DIV operations running in the processor.
	always@(posedge CLK) begin
	    if (!nrst) begin
	        check = 0;
	        consecutive_nops = 0;
	        last_inst = 0;
	    end
	    else
            if (!done)
                if (INST == last_inst && (INST[15:0] == 16'h0001 || INST == 32'h00000013)) begin
                    consecutive_nops = consecutive_nops + 1;
                    check = check + 1;
                end
                else if (INST == last_inst) begin
                    check = check + 1;
                end
                else begin
                    last_inst <= INST;
                    consecutive_nops = 0;
                    check = 0;
                end
	end
	// This controls the NOP counter
	always@(posedge CLK) begin
	   if (!done)
            if(!nrst)
                nop_counter <= 0;
            else if(!done)
                if(INST[15:0] == 16'h0001 || INST == 32'h00000013)
                    nop_counter <= nop_counter + 1;
	end
	// This controlls the done flag
	always@(posedge CLK) begin
		if(check == 49 || consecutive_nops == 8) done = 1;
	end

	// Tracking how many clock cycles it takes to execute the program
	always@(posedge CLK) begin
		if(!nrst) clock_counter <= 0;
		else if(!done) clock_counter <= clock_counter + 1;
	end

	always@(posedge CORE.if_clk) begin
		if(!nrst) if_clk_counter <= 0;
		else if(!done) if_clk_counter <= if_clk_counter + 1;
	end

	always@(posedge CORE.id_clk) begin
		if(!nrst) id_clk_counter <= 0;
		else if(!done) id_clk_counter <= id_clk_counter + 1;
	end

	always@(posedge CORE.exe_clk) begin
		if(!nrst) exe_clk_counter <= 0;
		else if(!done) exe_clk_counter <= exe_clk_counter + 1;
	end

	always@(posedge CORE.mem_clk) begin
		if(!nrst) mem_clk_counter <= 0;
		else if(!done) mem_clk_counter <= mem_clk_counter + 1;
	end

	always@(posedge CORE.wb_clk) begin
		if(!nrst) wb_clk_counter <= 0;
		else if(!done) wb_clk_counter <= wb_clk_counter + 1;
	end

	always@(posedge CORE.rf_clk) begin
		if(!nrst) rf_clk_counter <= 0;
		else if(!done) rf_clk_counter <= rf_clk_counter + 1;
	end

	// Tracking how many cycles each stall takes
	always@(posedge CLK) begin
		if(!nrst)
			stall_counter <= 0;
		else if(!done)
			if(CORE.if_stall)
				stall_counter <= stall_counter + 1;
			else
				stall_counter <= 0;
	end

	// Tracking total clock cycles the pipeline was stalled
	always@(posedge CLK) begin
		if(!nrst)
			cumulative_stall_counter <= 0;
		else if(!done)
			if(CORE.if_stall)
				cumulative_stall_counter <= cumulative_stall_counter + 1;
	end

	// Tracking total clock cycles "wasted" due to flushing (not counting flushing due to stall conditions)
	always@(posedge CLK) begin
		if(!nrst)
			cumulative_flush_counter <= 0;
		else if(!done)
			if(CORE.ISR_PC_flush || CORE.ISR_pipe_flush || CORE.jump_flush)
				cumulative_flush_counter <= cumulative_flush_counter + 1;
			else if(CORE.branch_flush)
				cumulative_flush_counter <= cumulative_flush_counter + 2;
	end

	// Tracking BHT Accuracy
	// Accesses: id_is_jump = 1 or id_is_btype = 1
	// Correct access: CORE.BRANCHPREDICTOR.feedback = 1
	// Overwrites: if a fifo_counter value overflows
	wire [`BHT_SET_BITS-1:0] id_set = CORE.BRANCHPREDICTOR.id_set;
	wire [`BHT_SET_BITS-1:0] exe_set = CORE.BRANCHPREDICTOR.exe_set;
	wire [1:0] exe_setoffset = CORE.BRANCHPREDICTOR.exe_setoffset;

	always@(posedge CLK)
		if(!nrst) begin
			total_bht_overwrites <= 0;
			total_bht_accesses <= 0;
			total_bht_correct <= 0;
		end

	// This controls bht_accesses & bht_correct for branches & jumps.
	always@(posedge CLK) begin
		if(!nrst) begin
			for(i = 0; i < `BHT_ENTRY; i=i+1) begin
				bht_correct[i] <= 0;
				bht_accesses[i] <= 0;
			end
		end 
		else if(!done) begin
			if(CORE.id_is_btype) begin
				case(CORE.BRANCHPREDICTOR.id_iseqto)
					4'b1000: bht_accesses[{id_set, 2'b11}] <= bht_accesses[{id_set, 2'b11}] + 1;
					4'b0100: bht_accesses[{id_set, 2'b10}] <= bht_accesses[{id_set, 2'b10}] + 1;
					4'b0010: bht_accesses[{id_set, 2'b01}] <= bht_accesses[{id_set, 2'b01}] + 1;
					4'b0001: bht_accesses[{id_set, 2'b00}] <= bht_accesses[{id_set, 2'b00}] + 1;
					4'b0000: bht_accesses[{id_set, CORE.BRANCHPREDICTOR.fifo_counter[id_set]}] <= bht_accesses[{id_set, CORE.BRANCHPREDICTOR.fifo_counter[id_set]}] + 1;
				endcase
			end
			else if(CORE.id_is_jump) begin
				case(CORE.BRANCHPREDICTOR.id_iseqto)
					4'b1000: bht_accesses[{id_set, 2'b11}] <= bht_accesses[{id_set, 2'b11}] + 1;
					4'b0100: bht_accesses[{id_set, 2'b10}] <= bht_accesses[{id_set, 2'b10}] + 1;
					4'b0010: bht_accesses[{id_set, 2'b01}] <= bht_accesses[{id_set, 2'b01}] + 1;
					4'b0001: bht_accesses[{id_set, 2'b00}] <= bht_accesses[{id_set, 2'b00}] + 1;
					4'b0000: bht_accesses[{id_set, CORE.BRANCHPREDICTOR.fifo_counter[id_set]}] <= bht_accesses[{id_set, CORE.BRANCHPREDICTOR.fifo_counter[id_set]}] + 1;
				endcase
				if(CORE.id_jump_in_bht && !CORE.id_sel_opBR)
					case(CORE.BRANCHPREDICTOR.id_iseqto)
						4'b1000: bht_correct[{id_set, 2'b11}] <= bht_correct[{id_set, 2'b11}] + 1;
						4'b0100: bht_correct[{id_set, 2'b10}] <= bht_correct[{id_set, 2'b10}] + 1;
						4'b0010: bht_correct[{id_set, 2'b01}] <= bht_correct[{id_set, 2'b01}] + 1;
						4'b0001: bht_correct[{id_set, 2'b00}] <= bht_correct[{id_set, 2'b00}] + 1;
						4'b0000: bht_correct[{id_set, CORE.BRANCHPREDICTOR.fifo_counter[id_set]}] <= bht_correct[{id_set, CORE.BRANCHPREDICTOR.fifo_counter[id_set]}] + 1;
					endcase
			end
		end
	end

	// This controls bht_correct for branch instructions
	always@(posedge CLK) begin
		if(!done)
			if((|CORE.exe_btype || |CORE.exe_c_btype) && CORE.BRANCHPREDICTOR.is_pred_correct)
				bht_correct[{exe_set, exe_setoffset}] <= bht_correct[{exe_set, exe_setoffset}] + 1;
			else if(CORE.exe_sel_opBR && (CORE.exe_branchtarget == CORE.BRANCHPREDICTOR.exe_loadentry[`BHT_PC_ADDR_BITS+1:2]))
				bht_correct[{exe_set, exe_setoffset}] <= bht_correct[{exe_set, exe_setoffset}] + 1;
	end

	// This controls bht_overwrites, which tracks if a fifo_counter overflows
	// Please check branchpredictor.v code to understand when a counter overflows
	always@(posedge CLK) begin
		if(!nrst)
			for(i=0; i<(`BHT_ENTRY/4); i=i+1)
				bht_overwrites[i] <= 0;
		else if(!done) begin
			if((CORE.id_is_btype || CORE.id_is_jump) && (CORE.BRANCHPREDICTOR.id_iseqto == 4'h0)) begin
				bht_overwrites[id_set] <= bht_overwrites[id_set] + 1;
			end
		end
	end

	// This controls max_data_addr
	always@(posedge CLK) begin
		if(!nrst)
			max_data_addr <= 0;
		else if(!done) 
			if((CORE.exe_is_stype && |CORE.exe_dm_write && CORE.exe_ALUout[12:2] > max_data_addr) && (CORE.exe_ALUout[12:2] < 11'h400))
				max_data_addr <= CORE.exe_ALUout[12:2];
	end

	// For simulating int_sig
	// Test interrupts for the following conditions:
	//		+ during "normal operation" -> no stalls
	//		+ during stalls (division)
	//		+ a stall occurs before the ISR executes (load hazard, etc.)
	//		+ while a branch instruction is still in the pipeline before ISR executes
	always@(posedge CLK) begin
		if(clock_counter == 20) int_sig[0] = 1;
		if(clock_counter == 55) int_sig[1] = 1;
		if(clock_counter == 100) int_sig[0] = 0;
		if(clock_counter == 105) int_sig[1] = 0;

		// if(clock_counter == 213) int_sig[0] = 1;
		// // if(clock_counter == 250) int_sig[0] = 0;

		// if(clock_counter == 239) int_sig[1] = 1;
		// if(clock_counter == 241) int_sig[2] = 1;
		// if(clock_counter == 243) int_sig[2] = 0;

		// if(clock_counter == 460) int_sig[2] = 1;
		// if(clock_counter == 462) int_sig[0] = 0;
		// // if(clock_counter == 500) int_sig[0] = 0;

		// if(clock_counter == 7376) int_sig[3] = 1;
		// if(clock_counter == 7400) int_sig[3] = 0;

		// if(clock_counter == 8000) int_sig = 4'hF;
	end

	// The following code is for checking the contents
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

	// Since Vivado/Verilog can't handle nested FOR loops well, this part
	// was split off into its own task. Ideally, it would be within the for loop
	// below, but Vivado doesn't display each entry correctly.
	task bht_entry_display();
		begin
			$display("Entry %0d: %0d passed/%0d accesses\tAccuracy: %f%%.", 0, bht_correct[{i[3:0], 2'b00}], bht_accesses[{i[3:0], 2'b00}], 100*($itor(bht_correct[{i[3:0], 2'b00}])/$itor(bht_accesses[{i[3:0], 2'b00}])) );
			$display("Entry %0d: %0d passed/%0d accesses\tAccuracy: %f%%.", 1, bht_correct[{i[3:0], 2'b01}], bht_accesses[{i[3:0], 2'b01}], 100*($itor(bht_correct[{i[3:0], 2'b01}])/$itor(bht_accesses[{i[3:0], 2'b01}])) );
			$display("Entry %0d: %0d passed/%0d accesses\tAccuracy: %f%%.", 2, bht_correct[{i[3:0], 2'b10}], bht_accesses[{i[3:0], 2'b10}], 100*($itor(bht_correct[{i[3:0], 2'b10}])/$itor(bht_accesses[{i[3:0], 2'b10}])) );
			$display("Entry %0d: %0d passed/%0d accesses\tAccuracy: %f%%.", 3, bht_correct[{i[3:0], 2'b11}], bht_accesses[{i[3:0], 2'b11}], 100*($itor(bht_correct[{i[3:0], 2'b11}])/$itor(bht_accesses[{i[3:0], 2'b11}])) );
		end
	endtask
	always@(posedge print_metrics) begin
		i = 0;
		j = 0;
		done = 0;
		$display("\n");
		$display("Passed %0d/%0d test cases.\nClock cycles: %0d", pass, total_test_cases, clock_counter-50);
		$display("Total cycles stalled: %0d", cumulative_stall_counter);
		$display("Total cycles flushed: %0d", cumulative_flush_counter);
		$display("Total NOPs: %0d", nop_counter);
		$display("=================\n");

		// Clock gating counters
		$display("---| Clock Gating Metrics |---");
		$display("PC clock: %0d/%0d cycles", if_clk_counter-50, clock_counter-50);
		$display("IF/ID clock: %0d/%0d cycles", id_clk_counter, clock_counter-50);
		$display("ID/EXE clock: %0d/%0d cycles", exe_clk_counter, clock_counter-50);
		$display("EXE/MEM & DATAMEM clock: %0d/%0d cycles", mem_clk_counter, clock_counter-50);
		$display("MEM/WB clock: %0d/%0d cycles", wb_clk_counter, clock_counter-50);
		$display("Regfile clock: %0d/%0d cycles", rf_clk_counter, clock_counter-50);
		$display("Ungated clock: %0d/%0d cycles", clock_counter-50, clock_counter-50);
		$display("=================\n");
		
		// Computing BHT metrics
		for(j = 0; j < `BHT_ENTRY; j = j + 1) begin
			total_bht_correct = total_bht_correct + bht_correct[j];
			total_bht_accesses = total_bht_accesses + bht_accesses[j];
		end

		for(j = 0; j < (`BHT_ENTRY/4); j = j+1) begin
			if(bht_overwrites[j] > 3) total_bht_overwrites = total_bht_overwrites + (bht_overwrites[j] - 3);
		end

		$display("---| BHT Performance Metrics |---");
		$display("BHT Entries: %0d.", `BHT_ENTRY);
		$display("Precision: %0d passed/%0d accesses.", total_bht_correct, total_bht_accesses);
		$display("Accuracy: %f%%.", 100*($itor(total_bht_correct)/$itor(total_bht_accesses)));
		$display("Overwrites done: %0d.", total_bht_overwrites);
		/* $display("---| Per-set Metrics |---");
		for(i = 0; i < (`BHT_ENTRY/4); i = i + 1) begin
			if(bht_overwrites[i] > 3) $display("Set: %0d\tOverwrites: %0d", i, bht_overwrites[i] - 3);
			else $display("Set: %0d\tOverwrites: 0", i);
			bht_entry_display();
			$display("------");
		end */
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