`timescale 1ns / 1ps

module tb_core();
	
	reg CLK;
	reg nrst;

	reg [3:0] con_write;
	reg [9:0] con_addr;
	reg [31:0] con_in;
	reg [31:0] last_inst;
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

		con_write = 0;
		con_addr = 10'h3ff;
		con_in = 0;
		last_inst = 32'h0;

		done = 0;
		check = 0;
		pass = 0;
		i = 0;
		#100;
		nrst = 1;
	end

	// Checking for 10 NOPs in a row
	always@(posedge CLK) begin
		if(INST == last_inst) begin
			check = check + 1;
		end
		else begin
			last_inst <= INST;
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
		$display("===| SUMMARY |===");
		$display("Actual  \tExpected");
		$display("========\t========");			
	end

	always@(negedge CLK) begin
		if(done) begin	
			if(con_out == AK.memory[con_addr]) begin
				$display("%X\t%X\tPass", con_out, AK.memory[con_addr]);
				pass = pass + 1;
			end else begin
				$display("%X\t%X\tFail", con_out, AK.memory[con_addr]);
			end

			con_addr = con_addr + 1;
			i = i + 1;
		end
	end

	always@(posedge CLK) begin
		if(con_addr == 100) begin			
			$display("\n");
			$display("Passed %d/%d test cases.\nClock cycles: %d\n=================", pass, i, clock_counter);
			$finish;
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