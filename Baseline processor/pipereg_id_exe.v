`timescale 1ns / 1ps

module pipereg_id_exe(
	input clk,
	input nrst,
	input en,

	// PC +4
	input [11:0] id_pc4,
	output reg [11:0] exe_pc4,

	// Register A
	input [31:0] id_rsA,
	output reg [31:0] exe_rsA,

	// Register B
	input [31:0] id_rsB,
	output reg [31:0] exe_rsB,

	// Regfile output A
	input [31:0] id_opA,
	output reg [31:0] exe_opA,

	// Regfile output B
	input [31:0] id_opB,
	output reg [31:0] exe_opB,

	// Regfile output B
	input [31:0] id_rfoutB,
	output reg [31:0] exe_rfoutB,

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

	input id_sel_opA,
	output reg exe_sel_opA,

	input id_sel_opB,
	output reg exe_sel_opB,

	//input id_dm_write,
	//output reg exe_dm_write,
	input id_is_stype,
	output reg exe_is_stype,

	input id_wr_en,
	output reg exe_wr_en,

	input [2:0] id_dm_select,
	output reg [2:0] exe_dm_select,

	//input [1:0] id_sel_pc,
	//output reg [1:0] exe_sel_pc,

	input [1:0] id_sel_data,
	output reg [1:0] exe_sel_data,

	input [1:0] id_store_select,
	output reg [1:0] exe_store_select
);

	always@(posedge clk) begin
		if(!nrst) begin
			exe_pc4 <= 0;
			exe_rsA <= 0;
			exe_rsB <= 0;
			exe_opA <= 0;
			exe_opB <= 0;
			exe_rfoutB <= 0;
			exe_imm <= 0;
			exe_rd <= 0;

			exe_PC <= 0;

			// Control signals
			exe_ALU_op <= 0;
			exe_sel_opA <= 0;
			exe_sel_opB <= 0;
			//exe_dm_write <= 0;
			exe_is_stype <= 0;
			exe_wr_en <= 0;
			exe_dm_select <= 0;
			//exe_sel_pc <= 0;
			exe_sel_data <= 0;
			exe_store_select <= 0;
		end 
		else begin
			if (en) begin
				exe_pc4 <= id_pc4;
				exe_rsA <= id_rsA;
				exe_rsB <= id_rsB;
				exe_opA <= id_opA;
				exe_opB <= id_opB;
				exe_rfoutB <= id_rfoutB;
				exe_imm <= id_imm;
				exe_rd <= id_rd;
				
				exe_PC <= id_PC;

				// Control signals
				exe_ALU_op <= id_ALU_op;
				exe_sel_opA <= id_sel_opA;
				exe_sel_opB <= id_sel_opB;
				//exe_dm_write <= id_dm_write;
				exe_is_stype <= id_is_stype;
				exe_wr_en <= id_wr_en;
				exe_dm_select <= id_dm_select;
				//exe_sel_pc <= id_sel_pc;
				exe_sel_data <= id_sel_data;
				exe_store_select <= id_store_select;
			end
			else begin
				exe_pc4 <= exe_pc4;
				exe_rsA <= exe_rsA;
				exe_rsB <= exe_rsB;
				exe_opA <= exe_opA;
				exe_opB <= exe_opB;
				exe_rfoutB <= exe_rfoutB;
				exe_imm <= exe_imm;
				exe_rd <= exe_rd;
				
				exe_PC <= exe_PC;

				// Control signals
				exe_ALU_op <= exe_ALU_op;
				exe_sel_opA <= exe_sel_opA;
				exe_sel_opB <= exe_sel_opB;
				//exe_dm_write <= exe_dm_write;
				exe_is_stype <= exe_is_stype;
				exe_wr_en <= exe_wr_en;
				exe_dm_select <= exe_dm_select;
				//exe_sel_pc <= exe_sel_pc;
				exe_sel_data <= exe_sel_data;
				exe_store_select <= exe_store_select;
			end
		end
	end

endmodule