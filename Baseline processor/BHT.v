`timescale 1ns / 1ps

module BHT(
	input CLK,
	input nrst,

	input [9:0] PC_if,
	input [9:0] PC_id,
	input [9:0] PC_exe,
	input is_jump,
	input is_stype,
	input ALU_feedback,

	output if_pred,
	output exe_corr,
	output flush,
	output [9:0] if_PBT,
	output [9:0] exe_PBT,
	output [9:0] exe_CNT

);


endmodule