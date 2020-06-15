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
`include "constants.vh"

module alu(
	input CLK,
	input nrst,
	input load_hazard,

	input [`WORD_WIDTH-1:0] op_a,
	input [`WORD_WIDTH-1:0] op_b,
	input [3:0] ALU_op,

	output reg [`WORD_WIDTH-1:0] res,
	output mul_stall,
	output z,
	output less,
	output signed_less
);


    wire signed [`WORD_WIDTH-1:0]  signed_a;
    wire signed [`WORD_WIDTH-1:0]  signed_b;

	wire [63:0] mulh_res, mulhsu_res, mulhu_res;
    
    assign signed_a = op_a;
    assign signed_b = op_b;
         
	assign z	=	op_a == op_b;
	assign less =	op_a < op_b;
	assign signed_less	=	signed_a < signed_b;

	// Instantiating Multiplier IPs
	wire mulhsu_clken = (ALU_op == `ALU_MULHSU)? 1'b1 : 1'b0;
	wire mulh_clken = (ALU_op == `ALU_MULH)? 1'b1 : 1'b0;
	wire mulhu_clken = (ALU_op == `ALU_MULHU || ALU_op == `ALU_MUL)? 1'b1 : 1'b0;
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
			`ALU_ADD: res = op_a + op_b;
			`ALU_SUB: res = op_a - op_b;
			`ALU_AND: res = op_a & op_b;
			`ALU_OR: res = op_a | op_b;
			`ALU_XOR: res = op_a ^ op_b;
			`ALU_SLT: res = signed_a < signed_b;
			`ALU_SLTU: res = op_a < op_b;
			`ALU_SLL: res = op_a << op_b[4:0];
			`ALU_SRL: res = op_a >> op_b[4:0];
			`ALU_SRA: res = signed_a >>> signed_b[4:0];

			`ALU_MUL: res = mulhu_res[31:0];
			`ALU_MULHU: res = mulhu_res[63:32];
			`ALU_MULH: res = mulh_res[63:32];
			`ALU_MULHSU: res = mulhsu_res[63:32];

			default: res = 32'h0;
		endcase
	end
endmodule
