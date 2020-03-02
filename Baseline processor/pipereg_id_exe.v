`timescale 1ns / 1ps

module pipereg_id_exe(
	input clk,
	input nrst,
	input en,

	input flush,
	input stall,

	// PC +4
	input [11:0] id_pc4,
	output reg [11:0] exe_pc4,

	// Forwarded opA
	input [31:0] id_fwdopA,
	output reg [31:0] exe_fwdopA,

	// Forwarded opB
	input [31:0] id_fwdopB,
	output reg [31:0] exe_fwdopB,

	// 32bit instruction
	input [31:0] id_inst,
	output reg [31:0] exe_inst,

	// Forwarded STOREBLOCK input
	input [31:0] id_fwdstore,
	output reg [31:0] exe_fwdstore,

	// 32-bit Immediate
	input [31:0] id_imm,
	output reg [31:0] exe_imm,

	// Destination register
	input [4:0] id_rd,
	output reg [4:0] exe_rd,

	// PC of current instruction for debugging
	input [11:0] id_PC,
	output reg [11:0] exe_PC,

	// Control signals
	input [3:0] id_ALU_op,
	output reg [3:0] exe_ALU_op,

	input [1:0] id_c_btype,
	output reg [1:0] exe_c_btype,
	input id_div_valid,
	output reg exe_div_valid,

	input [1:0] id_div_op,
	output reg [1:0] exe_div_op,

	// input id_sel_opA,
	// output reg exe_sel_opA,

	// input id_sel_opB,
	// output reg exe_sel_opB,

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

	input [4:0] id_rs1,
	output reg [4:0] exe_rs1,

	input [4:0] id_rs2,
	output reg [4:0] exe_rs2
);
	
	initial begin
		exe_pc4 <= 0;
		exe_fwdopA <= 0;
		exe_fwdopB <= 0;
		exe_inst <= 0;
		exe_fwdstore <= 0;
		exe_imm <= 0;
		exe_rd <= 0;
		exe_PC <= 0;

		// Control signals
		exe_ALU_op <= 0;
		exe_div_valid <= 0;
		exe_div_op <= 0;
		// exe_sel_opA <= 0;
		// exe_sel_opB <= 0;
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
			exe_inst <= 0;
			exe_fwdstore <= 0;
			exe_imm <= 0;
			exe_rd <= 0;
			exe_PC <= 0;

			// Control signals
			exe_ALU_op <= 0;

			exe_c_btype <= 0;

			exe_div_valid <= 0;
			exe_div_op <= 0;
			// exe_sel_opA <= 0;
			// exe_sel_opB <= 0;
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
			if(en && !stall) begin
				exe_pc4 <= id_pc4;
				exe_fwdopA <= id_fwdopA;
				exe_fwdopB <= id_fwdopB;
				exe_inst <= id_inst;
				exe_fwdstore <= id_fwdstore;
				exe_imm <= id_imm;
				exe_rd <= id_rd;
				exe_PC <= id_PC;

				// Control signals
				exe_ALU_op <= id_ALU_op;

				exe_c_btype <= id_c_btype;

				exe_div_valid <= id_div_valid;
				exe_div_op <= id_div_op;
				// exe_sel_opA <= id_sel_opA;
				// exe_sel_opB <= id_sel_opB;
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
	end

endmodule