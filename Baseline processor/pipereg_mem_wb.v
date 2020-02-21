`timescale 1ns / 1ps

module pipereg_mem_wb(
	input clk,
	input nrst,
	input en,

	input flush,
	input stall,

	input [11:0] mem_pc4,
	output reg [11:0] wb_pc4,

	input [31:0] mem_inst,
	output reg [31:0] wb_inst,

	input [31:0] mem_ALUout,
	output reg [31:0] wb_ALUout,

	input [31:0] mem_DIVout,
	output reg [31:0] wb_DIVout,

	input [31:0] mem_loaddata,
	output reg [31:0] wb_loaddata,

	input [31:0] mem_imm,
	output reg [31:0] wb_imm,

	input [4:0] mem_rd,
	output reg [4:0] wb_rd,

	input [11:0] mem_PC,
	output reg [11:0] wb_PC,

	// Control signals go here
	input mem_wr_en,
	output reg wb_wr_en,

	input [2:0] mem_sel_data,
	output reg [2:0] wb_sel_data
);

	always@(posedge clk) begin
		if(!nrst || flush) begin
			wb_pc4 <= 0;
			wb_inst <= 0;
			wb_ALUout <= 0;
			wb_DIVout <= 0;
			wb_loaddata <= 0;
			wb_imm <= 0;
			wb_rd <= 0;

			wb_PC <= 0;

			// Control signals
			wb_wr_en <= 0;
			wb_sel_data <= 0;

		end else if(en && !stall) begin
			wb_pc4 <= mem_pc4;
			wb_inst <= mem_inst;
			wb_ALUout <= mem_ALUout;
			wb_DIVout <= mem_DIVout;
			wb_loaddata <= mem_loaddata;
			wb_imm <= mem_imm;
			wb_rd <= mem_rd;

			wb_PC <= mem_PC;

			// Control signals
			wb_wr_en <= mem_wr_en;
			wb_sel_data <= mem_sel_data;
		end
	end

endmodule