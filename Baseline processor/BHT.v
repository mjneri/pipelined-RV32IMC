`timescale 1ns / 1ps

module BHT(
	input CLK,
	input nrst,

	// Inputs
	input [9:0] if_PC,

	input [9:0] id_PC,
	input [9:0] id_branchtarget,
	input is_jump,
	input is_btype,

	input [9:0] exe_PC,
	input exe_feedback,

	// Outputs
	output if_prediction,
	output exe_correction,
	output flush,

	// Predicted branch target
	output [9:0] if_PBT,
	output [9:0] exe_PBT,

	// Correct Next Instruction = CNI
	output [9:0] exe_CNI
);





endmodule