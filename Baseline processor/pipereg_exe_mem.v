`timescale 1ns / 1ps

module exe_mem(
	input clk,
	input nrst,

	input [11:0] exe_pc4,
	output reg [11:0] mem_pc4,

	input [31:0] exe_ALUout,
	output reg [31:0] mem_ALUout,

	input [31:0] exe_storedata,
	output reg [31:0] mem_storedata,

	input [31:0] exe_imm,
	output reg [31:0], mem_imm,

	input [4:0] exe_rd,
	output reg [4:0] mem_rd,

	input [11:0] exe_PC,
	output reg [11:0] mem_PC

	// Control signals go here
);

	always@(posedge clk) begin
		if(!nrst) begin
			mem_pc4 <= 0;
			mem_ALUout <= 0;
			mem_storedata <= 0;
			mem_imm <= 0;
			mem_rd <= 0;

			mem_PC <= 0;
		end else begin
			mem_pc4 <= exe_pc4;
			mem_ALUout <= exe_ALUout;
			mem_storedata <= exe_storedata;
			mem_imm <= exe_imm;
			mem_rd <= exe_rd;
			
			mem_PC <= exe_PC;
		end
	end

endmodule