`timescale 1ns / 1ps

module alu(
	input  		[31:0] 	op_a,
	input 		[31:0] 	op_b,
	input 		[3:0] 	alu_ctr,
	output 	 	[31:0] 	res,
	output 	 			z,
	output 	 			less
);

    wire signed [31:0]  signed_a;
    wire signed [31:0]  signed_b;
    wire signed [31:0]  signed_res;
    
    assign signed_a = op_a;
    assign signed_b = op_b;
         
	// ALU_ctrl
    parameter 		[3:0] 	alu_add 	= 	4'd1;
	parameter 		[3:0] 	alu_sub 	= 	4'd2;
	parameter 		[3:0] 	alu_and 	= 	4'd3;
	parameter 		[3:0] 	alu_or 		= 	4'd4;
	parameter 		[3:0] 	alu_xor 	= 	4'd5;
	parameter 		[3:0] 	alu_slt 	= 	4'd6;
	parameter 		[3:0] 	alu_sltu 	= 	4'd7;
	parameter 		[3:0] 	alu_sll		= 	4'd8;
	parameter 		[3:0] 	alu_srl 	= 	4'd9;
	parameter 		[3:0]	alu_sra 	= 	4'd10;

	assign z	=	res == 32'h0;
	assign less	=	op_a < op_b;
	assign signed_res = signed_a >>> signed_b;
	assign res	=	alu_ctr == alu_add	?	op_a + op_b :
					alu_ctr == alu_sub	?	op_a - op_b :
					alu_ctr == alu_and	?	op_a & op_b :
					alu_ctr == alu_or	?	op_a | op_b :
					alu_ctr == alu_xor	?	op_a ^ op_b :
					alu_ctr == alu_slt	?	signed_a < signed_b :
					alu_ctr == alu_sltu	?	op_a < op_b :
					alu_ctr == alu_sll	?	op_a << op_b :
					alu_ctr == alu_srl	?	op_a >> op_b :
					alu_ctr == alu_sra	?	signed_res :
											32'h0;
    											
endmodule