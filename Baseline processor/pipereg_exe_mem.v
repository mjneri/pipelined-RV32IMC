`timescale 1ns / 1ps

module pipereg_exe_mem(
	input clk,
	input nrst,

	input [11:0] exe_pc4,
	output reg [11:0] mem_pc4,

	input [31:0] exe_ALUout,
	output reg [31:0] mem_ALUout,

	input [31:0] exe_storedata,
	output reg [31:0] mem_storedata,

	input [31:0] exe_imm,
	output reg [31:0] mem_imm,

	input [4:0] exe_rd,
	output reg [4:0] mem_rd,

	input [11:0] exe_PC,
	output reg [11:0] mem_PC,

	// Control signals
	input [3:0] exe_dm_write,
	output reg [3:0] mem_dm_write,

	input exe_wr_en,
	output reg mem_wr_en,

	input [2:0] exe_dm_select,
	output reg [2:0] mem_dm_select,

	input [1:0] exe_sel_data,
	output reg [1:0] mem_sel_data
);

	always@(posedge clk) begin
		if(!nrst) begin
			mem_pc4 <= 0;
			mem_ALUout <= 0;
			mem_storedata <= 0;
			mem_imm <= 0;
			mem_rd <= 0;

			mem_PC <= 0;

			// Control signals
			mem_dm_write <= 0;
			mem_wr_en <= 0;
			mem_dm_select <= 0;
			mem_sel_data <= 0;
		end else begin
			mem_pc4 <= exe_pc4;
			mem_ALUout <= exe_ALUout;
			mem_storedata <= exe_storedata;
			mem_imm <= exe_imm;
			mem_rd <= exe_rd;
			
			mem_PC <= exe_PC;

			// Control signals
			mem_dm_write <= exe_dm_write;
			mem_wr_en <= exe_wr_en;
			mem_dm_select <= exe_dm_select;
			mem_sel_data <= exe_sel_data;
		end
	end

endmodule