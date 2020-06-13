//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// pipereg_mem_wb.v -- MEM/WB Pipeline register module
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Author: Microlab 198 Pipelined RISC-V Group (2SAY1920)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Module Name: pipereg_mem_wb.v
// Description:
//
// Revisions:
// Revision 0.01 - File Created
// Additional Comments:
// 
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=


`timescale 1ns / 1ps
`include "constants.vh"

module pipereg_mem_wb(
	input clk,
	input nrst,

	input flush,
	input stall,

	input [`PC_ADDR_BITS-1:0] mem_pc4,
	output reg [`PC_ADDR_BITS-1:0] wb_pc4,

	input [`WORD_WIDTH-1:0] mem_inst,
	output reg [`WORD_WIDTH-1:0] wb_inst,

	input [`WORD_WIDTH-1:0] mem_ALUout,
	output reg [`WORD_WIDTH-1:0] wb_ALUout,

	input [`WORD_WIDTH-1:0] mem_DIVout,
	output reg [`WORD_WIDTH-1:0] wb_DIVout,

	input [`WORD_WIDTH-1:0] mem_loaddata,
	output reg [`WORD_WIDTH-1:0] wb_loaddata,

	input [`WORD_WIDTH-1:0] mem_imm,
	output reg [`WORD_WIDTH-1:0] wb_imm,

	input [4:0] mem_rd,
	output reg [4:0] wb_rd,

	input [`PC_ADDR_BITS-1:0] mem_PC,
	output reg [`PC_ADDR_BITS-1:0] wb_PC,

	// Control signals go here
	input mem_wr_en,
	output reg wb_wr_en,

	input [2:0] mem_sel_data,
	output reg [2:0] wb_sel_data
);

	initial begin
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
	end

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

		end else if(!stall) begin
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