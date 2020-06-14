//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// shiftsignshuff.v -- Immediate generator module
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Author: Microlab 198 Pipelined RISC-V Group (2SAY1920)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Module Name: shiftsignshuff.v
// Description: For RISC-V, immediates are always sign-extended.
// 				Encoding types:
// 					R: no immediates; used for arithmetic instructions
// 					I: 12bit immediate, not shifted, used for addi, slli, srli, srai, etc.
// 					S: 12bit immediate, not shifted, used for sw, sh, sb
// 					U: 20bit immediate, shifted left 12 bits, padded with 0's, used for AUIPC and LUI
// 					B: 12bit immediate, shifted left 1 bit, jumbled, used for branch instructions
// 					J: 20bit immediate, shifted left 1 bit, jumbled, used for JAL only
//
// Revisions:
// Revision 0.01 - File Created
// Additional Comments:
// 
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

`timescale 1ns / 1ps

module shiftsignshuff(
	// Control signal
	input [2:0] imm_select,

	// Parts of RV32I instructions that contain the immediate
	input [24:0] inst,	// in the 32bit instruction, this comprises INST[31:7]
						// INST[6:0] contains the opcode

	// Output immediate
	output reg [31:0] imm
);

// imm_select:
// 0 if I-type inst (operations + load)
// 1 if S-type inst
// 2 if U-type inst
// 3 if B-type inst
// 4 if J-type inst
	parameter ITYPE = 3'h0;
	parameter STYPE = 3'h1;
	parameter UTYPE = 3'h2;
	parameter BTYPE = 3'h3;
	parameter JTYPE = 3'h4;

	wire [31:0] Itype_imm, Stype_imm, Utype_imm, Btype_imm, Jtype_imm;

	// Refer to RISC-V Vol. 1: Unprivileged Architecture Manual for Immediate Encoding Variants
	assign Itype_imm = { {20{inst[24]}}, inst[24:13] };
	assign Stype_imm = { {20{inst[24]}}, inst[24:18], inst[4:0] };
	assign Utype_imm = { inst[24:5], 12'h0 };
	assign Btype_imm = { {19{inst[24]}}, inst[24], inst[0], inst[23:18], inst[4:1], 1'h0 };
	assign Jtype_imm = { {11{inst[24]}}, inst[24], inst[12:5], inst[13], inst[23:14], 1'h0 };

	always@(*) begin
		case(imm_select)
			STYPE: imm = Stype_imm;
			UTYPE: imm = Utype_imm;
			BTYPE: imm = Btype_imm;
			JTYPE: imm = Jtype_imm;
			default: imm = Itype_imm;
		endcase
	end
endmodule