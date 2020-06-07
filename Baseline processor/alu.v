//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// alu.v -- ALU for the RV32IMC processor
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Author: Microlab 198 Single-cycle RISC-V Group (2SAY1819)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Module Name: alu.v
// Description:
//
// Revisions:
// Revision 0.01 - File Created
// Revision 1.00 - File modified by Pipelined RISC-V Group (2SAY1920)
// Additional Comments:
// 
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=


`timescale 1ns / 1ps

module alu(
	input CLK,
	input nrst,
	input load_hazard,

	input [31:0] op_a,
	input [31:0] op_b,
	input [3:0] ALU_op,

	output reg [31:0] res,
	output mul_stall,
	output z,
	output less,
	output signed_less
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
	assign less =	op_a < op_b;
	assign signed_less	=	signed_a < signed_b;

	assign signed_res = signed_a >>> signed_b[4:0];

	// Instantiating Multiplier IPs
	wire mulhsu_clken = (ALU_op == alu_mulhsu)? 1'b1 : 1'b0;
	wire mulh_clken = (ALU_op == alu_mulh)? 1'b1 : 1'b0;
	wire mulhu_clken = (ALU_op == alu_mulhu || ALU_op == alu_mul)? 1'b1 : 1'b0;
	mult_gen_hsu MULHSU(
		.CLK(CLK),
		.CE(mulhsu_clken),
		.A(signed_a),
		.B(op_b),
		.P(mulhsu_res)
	);

	mult_gen_signed MULH(
		.CLK(CLK),
		.CE(mulh_clken),
		.A(signed_a),
		.B(signed_b),
		.P(mulh_res)
	);

	mult_gen_u MULHU(
		.CLK(CLK),
		.CE(mulhu_clken),
		.A(op_a),
		.B(op_b),
		.P(mulhu_res)
	);

	// This controls mul_stall which asserts for one cycle only whenever a multiplication
	// operation is present.
	// NOTE: if a load_hazard is present, we delay the update of mul_stall by 1 cycle.
	reg mul_stall_reg;
	initial mul_stall_reg = 0;
	wire is_mul = (ALU_op > 4'd10) & (ALU_op != 4'd15);
	always@(posedge CLK) begin
		if(!nrst) 
			mul_stall_reg <= 0;
		else if(!load_hazard)
			mul_stall_reg <= is_mul & mul_stall;
	end
	assign mul_stall = ~mul_stall_reg & is_mul;

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
