`timescale 1ns / 1ps

module tb_alu();
	reg [31:0] opA, opB;
	reg [3:0] aluop;
	wire [31:0] res;
	wire z, less;
	
	alu uut(
		.op_a(opA),
		.op_b(opB),
		.ALU_op(aluop),
		.res(res),
		.z(z),
		.less(less)
	);

	// Define parameters for aluop
	parameter ADD 	= 	4'd1;
	parameter SUB 	= 	4'd2;
	parameter AND 	= 	4'd3;
	parameter OR 	= 	4'd4;
	parameter XOR 	= 	4'd5;
	parameter SLT 	= 	4'd6;
	parameter SLTU 	= 	4'd7;
	parameter SLL	= 	4'd8;
	parameter SRL 	= 	4'd9;
	parameter SRA 	= 	4'd10;

	initial begin
		opA = 32'h0;
		opB = 32'h0;
		aluop = ADD;

		// Testcases ADD
		#20;
		opA = 32'hade1b055;
		opB = 32'h6745ffec;
		#20;
		opA = -32'd1;
		opB = 32'd1;
		#20;
		opA = 32'h00029000;
		opB = 32'h0fff4000;
		#20;
		aluop = SUB;
		#20;
		aluop = AND;
		#20;
		aluop = OR;
		#20;
		aluop = XOR;
		#20;
		aluop = SLT;
		#20;
		aluop = SLTU;
		#20;
		aluop = SLL;
		#20;
		aluop = SRL;
		#20;
		aluop = SRA;
		#40;
		$finish;
	end
endmodule