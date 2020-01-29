`timescale 1ns / 1ps

module tb_core();
	
	reg CLK;
	reg nrst;

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
		#5 CLK = ~CLK;

	integer i, check, done, pass;

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
		con_addr = 0;
		con_in = 0;

		done = 0;
		check = 0;
		pass = 0;
		#100;
		nrst = 1;
	end

	// Checking for 10 NOPs in a row
	always@(posedge CLK) begin
		if(INST == 32'h00000013) begin
			check = check + 1;
		end else begin
			check = 0;
		end
	end
	always@(posedge CLK) begin
		if(check == 10)
			done = 1;
	end

	// Displaying Memory contents
	always@(posedge done) begin
		$display("===| SUMMARY |===");
		$display("Actual  \tExpected");
		$display("========\t========");
		for(i = 0; i < 32; i = i + 1) begin
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
	end

endmodule

// ANSWER KEY
module answerkey();
	reg [31:0] memory [0:1023];
	initial begin
		$readmemh("answerkey.mem", memory);
	end
endmodule