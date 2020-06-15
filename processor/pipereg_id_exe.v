//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// pipereg_id_exe.v -- ID/EXE Pipeline register module
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Author: Microlab 198 Pipelined RISC-V Group (2SAY1920)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Module Name: pipereg_id_exe.v
// Description:
//
// Revisions:
// Revision 0.01 - File Created
// Additional Comments:
// 
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=


`timescale 1ns / 1ps
`include "constants.vh"

module pipereg_id_exe(
	input clk,
	input nrst,

	input flush,

	// Incremented PC
	input [`PC_ADDR_BITS-1:0] id_pc4,
	output reg [`PC_ADDR_BITS-1:0] exe_pc4,

	// Forwarded opA
	input [`WORD_WIDTH-1:0] id_fwdopA,
	output reg [`WORD_WIDTH-1:0] exe_fwdopA,

	// Forwarded opB
	input [`WORD_WIDTH-1:0] id_fwdopB,
	output reg [`WORD_WIDTH-1:0] exe_fwdopB,

	// Opcode
	input [6:0] id_opcode,
	output reg [6:0] exe_opcode,

	// Funct3
	input [2:0] id_funct3,
	output reg [2:0] exe_funct3,

	// Computed branch target
	input [`WORD_WIDTH-1:0] id_branchtarget,
	output reg [`WORD_WIDTH-1:0] exe_branchtarget,

	// Forwarded STOREBLOCK input
	input [`WORD_WIDTH-1:0] id_fwdstore,
	output reg [`WORD_WIDTH-1:0] exe_fwdstore,

	// 32-bit Immediate
	input [`WORD_WIDTH-1:0] id_imm,
	output reg [`WORD_WIDTH-1:0] exe_imm,

	// Destination register
	input [`REGFILE_BITS-1:0] id_rd,
	output reg [`REGFILE_BITS-1:0] exe_rd,

	// PC of current instruction for debugging
	input [`PC_ADDR_BITS-1:0] id_PC,
	output reg [`PC_ADDR_BITS-1:0] exe_PC,

	// Control signals
	input [3:0] id_ALU_op,
	output reg [3:0] exe_ALU_op,

	input [1:0] id_c_btype,
	output reg [1:0] exe_c_btype,

	input id_sel_opBR,
	output reg exe_sel_opBR,

	input id_div_valid,
	output reg exe_div_valid,

	input [1:0] id_div_op,
	output reg [1:0] exe_div_op,

	input id_is_stype,
	output reg exe_is_stype,

	input id_wr_en,
	output reg exe_wr_en,

	input [2:0] id_dm_select,
	output reg [2:0] exe_dm_select,

	input [2:0] id_sel_data,
	output reg [2:0] exe_sel_data,

	input [1:0] id_store_select,
	output reg [1:0] exe_store_select,

	input id_comp_use_A,
	output reg exe_comp_use_A,

	input id_comp_use_B,
	output reg exe_comp_use_B,

	input id_is_comp,
	output reg exe_is_comp,

	// Additional signals
	input [`REGFILE_BITS-1:0] id_rs1,
	output reg [`REGFILE_BITS-1:0] exe_rs1,

	input [`REGFILE_BITS-1:0] id_rs2,
	output reg [`REGFILE_BITS-1:0] exe_rs2
);
	
	initial begin
		exe_pc4 <= 0;
		exe_fwdopA <= 0;
		exe_fwdopB <= 0;
		exe_opcode <= 0;
		exe_funct3 <= 0;
		exe_branchtarget <= 0;
		exe_fwdstore <= 0;
		exe_imm <= 0;
		exe_rd <= 0;
		exe_PC <= 0;

		// Control signals
		exe_ALU_op <= 0;
		exe_c_btype <= 0;
		exe_sel_opBR <= 0;
		exe_div_valid <= 0;
		exe_div_op <= 0;
		exe_is_stype <= 0;
		exe_wr_en <= 0;
		exe_dm_select <= 0;
		exe_sel_data <= 0;
		exe_store_select <= 0;
		exe_comp_use_A <= 0;
		exe_comp_use_B <= 0;
		exe_is_comp <= 0;
		exe_rs1 <= 0;
		exe_rs2 <= 0;
	end

	always@(posedge clk) begin
		if(!nrst || flush) begin
			exe_pc4 <= 0;
			exe_fwdopA <= 0;
			exe_fwdopB <= 0;
			exe_opcode <= 0;
			exe_funct3 <= 0;
			exe_branchtarget <= 0;
			exe_fwdstore <= 0;
			exe_imm <= 0;
			exe_rd <= 0;
			exe_PC <= 0;

			// Control signals
			exe_ALU_op <= 0;

			exe_c_btype <= 0;
			exe_sel_opBR <= 0;

			exe_div_valid <= 0;
			exe_div_op <= 0;
			exe_is_stype <= 0;
			exe_wr_en <= 0;
			exe_dm_select <= 0;
			exe_sel_data <= 0;
			exe_store_select <= 0;
			exe_comp_use_A <= 0;
			exe_comp_use_B <= 0;
			exe_is_comp <= 0;
			exe_rs1 <= 5'd0;
			exe_rs2 <= 5'd0;
		end else begin
			exe_pc4 <= id_pc4;
			exe_fwdopA <= id_fwdopA;
			exe_fwdopB <= id_fwdopB;
			exe_opcode <= id_opcode;
			exe_funct3 <= id_funct3;
			exe_branchtarget <= id_branchtarget;
			exe_fwdstore <= id_fwdstore;
			exe_imm <= id_imm;
			exe_rd <= id_rd;
			exe_PC <= id_PC;

			// Control signals
			exe_ALU_op <= id_ALU_op;

			exe_c_btype <= id_c_btype;
			exe_sel_opBR <= id_sel_opBR;

			exe_div_valid <= id_div_valid;
			exe_div_op <= id_div_op;
			exe_is_stype <= id_is_stype;
			exe_wr_en <= id_wr_en;
			exe_dm_select <= id_dm_select;
			exe_sel_data <= id_sel_data;
			exe_store_select <= id_store_select;
			exe_comp_use_A <= id_comp_use_A;
			exe_comp_use_B <= id_comp_use_B;
			exe_is_comp <= id_is_comp;
			exe_rs1 <= id_rs1;
			exe_rs2 <= id_rs2;
		end
	end

endmodule