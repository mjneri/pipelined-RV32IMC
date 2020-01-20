`timescale 1ns / 1ps

module id_exe(
	input clk,
	input nrst,

	// PC +4
	input [11:0] id_pc4,
	output reg [11:0] exe_pc4,

	// Regfile output A
	input [31:0] id_rfoutA,
	output reg [31:0] exe_rfoutA,

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
	output reg [11:0] exe_PC

	// Control signals go here
);

	always@(posedge clk) begin
		if(!nrst) begin
			exe_pc4 <= 0;
			exe_rfoutA <= 0;
			exe_rfoutB <= 0;
			exe_imm <= 0;
			exe_rd <= 0;

			exe_PC <= 0;
		end else begin
			exe_pc4 <= id_pc4;
			exe_rfoutA <= id_rfoutA;
			exe_rfoutB <= id_rfoutB;
			exe_imm <= id_imm;
			exe_rd <= id_rd;
			
			exe_PC <= id_PC;
		end
	end

endmodule