`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/16/2020 06:26:18 PM
// Design Name: 
// Module Name: tb_divider
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_divider();
	reg CLK;
	reg nrst;

	reg [31:0] opA, opB;
	reg div_valid;
	reg [1:0] div_op;

	wire div_running;
	wire [31:0] DIVout;

	reg [15:0] cycles;

	divider_unit DIVIDER(
		.CLK(CLK),
		.nrst(nrst),

		.opA(opA),
		.opB(opB),

		.div_valid(div_valid),
		.div_op(div_op),

		.div_running(div_running),
		.DIVout(DIVout)
	);

	// Define parameters for div_op
	parameter DIV = 2'd0;
	parameter DIVU = 2'd1;
	parameter REM = 2'd2;
	parameter REMU = 2'd3;

	// Define parameters for div_state
	parameter RESET = 2'd0;
	parameter WAIT = 2'd1;
	parameter DIVIDING = 2'd2;
	parameter DONE = 2'd3;


	// Task for generating stimulus
	// Tried to imitate behavior of the RISC-V core when there are
	// 4 division ops in a row.
	task test_op();
		input [31:0] A, B;
		begin
			opA = A;
			opB = B;
			#10 $strobe("A: %X, B: %X", opA, opB);

			div_op = DIV;
			#10 div_valid = 1;
			while(DIVIDER.div_state != DONE) #20;
			$strobe("OP: DIV, RES: %X", DIVout);

			#20 div_op = DIVU;
			while(DIVIDER.div_state != DONE) #20;
			$strobe("OP: DIVU, RES: %X", DIVout);

			#20 div_op = REM;
			while(DIVIDER.div_state != DONE) #20;
			$strobe("OP: REM, RES: %X", DIVout);

			#20 div_op = REMU;
			while(DIVIDER.div_state != DONE) #20;
			$strobe("OP: REMU, RES: %X", DIVout);
			
			#20 div_valid = 0;
		end
	endtask

	always #10 CLK = ~CLK;

	always@(posedge CLK) begin
		if(!nrst)
			cycles <= 0;
		else
			cycles <= cycles + 1;
	end

	initial begin
		CLK = 0;
		nrst = 0;

		opA = 32'h0;
		opB = 32'h0;

		div_valid = 0;
		div_op = 0;

		#100;
		nrst = 1;

		#110 test_op(32'hc0e19800, 32'heee19000);

		// Random inputs
		test_op($random%1000, $random%1000);
		test_op($random%1000, $random%1000);
		test_op($urandom%1000, $urandom%1000);
		test_op($urandom%1000, $urandom%1000);
		test_op($urandom%1000, $urandom%1000);

		/*#40;
		opA = 32'd12;
		// dividend_valid = 1;

		opB = 32'd5;
		// divisor_valid = 1;

		#20;
		opA = 32'd100;
		opB = -32'd6;

		div_valid = 1;

		#20
		div_valid = 0;
		
		#20;
		// dividend_valid = 0;
		// divisor_valid = 0;
		opA = 32'd25;
		opB = 32'd4;

		#20;
		opA = 32'd204;
		opB = 32'd12;

		#20;
		opA = 1;
		opB = 0;

		#20;
		opA = 0;
		opB = 1;

		div_valid = 0;

		#80;
		opA = 100;
		opB = 0;
		div_valid = 1;
		#20;
		div_valid = 0;*/
	end
endmodule