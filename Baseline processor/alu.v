`timescale 1ns / 1ps

module alu(
	input  		[31:0] 	op_a,
	input 		[31:0] 	op_b,
	input 		[3:0] 	ALU_op,
	output 	 	[31:0] 	res,
	output 	 			z,
	output 	 			less
);

    wire signed [31:0]  signed_a;
    wire signed [31:0]  signed_b;
    wire signed [31:0]  signed_res;
	wire [63:0]			mult_res;
    
    assign signed_a = op_a;
    assign signed_b = op_b;
         
	// ALU_op
    parameter alu_add 	= 	4'd1;
	parameter alu_sub 	= 	4'd2;
	parameter alu_and 	= 	4'd3;
	parameter alu_or 	= 	4'd4;
	parameter alu_xor 	= 	4'd5;
	parameter alu_slt 	= 	4'd6;
	parameter alu_sltu 	= 	4'd7;
	parameter alu_sll	= 	4'd8;
	parameter alu_srl 	= 	4'd9;
	parameter alu_sra 	= 	4'd10;
	parameter alu_mhi 	= 	4'd11;
	parameter alu_mlo 	= 	4'd12;

	assign z	=	res == 32'h0;
	assign less	=	op_a < op_b;
	assign signed_res = signed_a >>> signed_b[4:0];
	
	assign res	=	ALU_op == alu_mhi	?	mult_res[63:32] :
					ALU_op == alu_mlo	?	mult_res[31:0] :
					ALU_op == alu_add	?	op_a + op_b :
					ALU_op == alu_sub	?	op_a - op_b :
					ALU_op == alu_and	?	op_a & op_b :
					ALU_op == alu_or	?	op_a | op_b :
					ALU_op == alu_xor	?	op_a ^ op_b :
					ALU_op == alu_slt	?	signed_a < signed_b :
					ALU_op == alu_sltu	?	op_a < op_b :
					ALU_op == alu_sll	?	op_a << op_b[4:0] :
					ALU_op == alu_srl	?	op_a >> op_b[4:0] :
					ALU_op == alu_sra	?	signed_res :
											32'h0;
    											
endmodule