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
		div_op = 2'd1;

		#100;
		nrst = 1;

		#40;
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
		div_valid = 0;
	end
endmodule