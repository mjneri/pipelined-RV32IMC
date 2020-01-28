`timescale 1ns / 1ps

/*
	Branch History Table module
	Format of each entry:
	========================================================================
	| Valid bit | Tag[5:0] | Branch target[9:0] | Saturating Counter [1:0] |
	========================================================================
	BHT is implemented as a 4-way Set Associative "Cache"
	id_PC[9:0] = {Tag[5:0], Set[3:0]}
*/

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

	// Declaring memory for BHT
	/*  format of each line in reg history_table
		========================================================================
		| Valid bit | Tag[5:0] | Branch target[9:0] | Saturating Counter [1:0] |
		| ht[18]    | ht[17:12]| ht[11:2]           | ht[1:0]				   |
		========================================================================
		Where ht = history_table
	*/
	reg [18:0] history_table [0:63];


endmodule