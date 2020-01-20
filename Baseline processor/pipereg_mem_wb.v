`timescale 1ns / 1ps

module mem_wb(
	input clk,
	input nrst,

	input [11:0] mem_pc4,
	output reg [11:0] wb_pc4,

	input [31:0] mem_ALUout,
	output reg [31:0], wb_ALUout,

	input [31:0] mem_loaddata,
	output reg [31:0] wb_loaddata,

	input [31:0] mem_imm,
	output reg [31:0] wb_imm,

	input [4:0] mem_rd,
	output reg [4:0] wb_rd,

	input [11:0] mem_PC,
	output reg [11:0] wb_PC

	// Control signals go here
);

	always@(posedge clk) begin
		if(!nrst) begin
			wb_pc4 <= 0;
			wb_ALUout <= 0;
			wb_loaddata <= 0;
			wb_imm <= 0;
			wb_rd <= 0;

			wb_PC <= 0;
		end else begin
			wb_pc4 <= mem_pc4;
			wb_ALUout <= mem_ALUout;
			wb_loaddata <= mem_loaddata;
			wb_imm <= mem_imm;
			wb_rd <= mem_rd;

			wb_PC <= mem_PC;
		end
	end

endmodule