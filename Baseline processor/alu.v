`timescale 1ns / 1ps

module alu(
	input [31:0] op_a,
	input [31:0] op_b,
	input [3:0] ALU_op,

	output reg [31:0] res,
	output z,
	output less
);


    wire signed [31:0]  signed_a;
    wire signed [31:0]  signed_b;
    wire signed [31:0]  signed_res;

	wire [63:0] mulh_res, mulhsu_res, mulhu_res;
    
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

	parameter alu_mul 	= 	4'd11;
	parameter alu_mulh 	= 	4'd12;
	parameter alu_mulhsu =	4'd13;
	parameter alu_mulhu = 	4'd14;

	assign z	=	op_a == op_b;
	assign less	=	op_a < op_b;

	assign signed_res = signed_a >>> signed_b[4:0];

	// Instantiating Multiplier IPs
	mult_gen_hsu MULHSU(
		.A(signed_a),
		.B(op_b),
		.P(mulhsu_res)
	);

	mult_gen_signed MULH(
		.A(signed_a),
		.B(signed_b),
		.P(mulh_res)
	);

	mult_gen_u MULHU(
		.A(op_a),
		.B(op_b),
		.P(mulhu_res)
	);

	always@(*) begin
		case(ALU_op)
			alu_add: res = op_a + op_b;
			alu_sub: res = op_a - op_b;
			alu_and: res = op_a & op_b;
			alu_or: res = op_a | op_b;
			alu_xor: res = op_a ^ op_b;
			alu_slt: res = signed_a < signed_b;
			alu_sltu: res = op_a < op_b;
			alu_sll: res = op_a << op_b[4:0];
			alu_srl: res = op_a >> op_b[4:0];
			alu_sra: res = signed_a >>> signed_b[4:0];

			alu_mul: res = mulhu_res[31:0];
			alu_mulhu: res = mulhu_res[63:32];
			alu_mulh: res = mulh_res[63:32];
			alu_mulhsu: res = mulhsu_res[63:32];

			default: res = 32'h0;
		endcase
	end
endmodule