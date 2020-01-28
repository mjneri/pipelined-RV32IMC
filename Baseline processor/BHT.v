`timescale 1ns / 1ps

/*
	Branch History Table module
	Format of each entry:
	========================================================================
	| Valid bit | Tag[5:0] | Branch target[9:0] | Saturating Counter [1:0] |
	========================================================================
	BHT is implemented as a 4-way Set Associative "Cache"
	id_PC[9:0] = {Tag[5:0], Set[3:0]}

	For selecting next PC:
	format of selection bits: {exe_correction[1:0], if_prediction}
		default selection: PC+4
		3'b001: if_PBT
		3'b100 & 3'b101: exe_CNI
		3'b110 & 3'b111: exe_PBT
*/

module BHT(
	input CLK,
	input nrst,

	// Inputs
	input [9:0] if_PC,

	input [9:0] id_PC,
	input [9:0] id_branchtarget,
	input id_is_jump,
	input id_is_btype,

	input [9:0] exe_PC,
	input exe_z,
	input exe_less,
	input [5:0] exe_btype,		// determines what branch instruction was used
	// exe_btype[5]: is_beq
	// exe_btype[4]: is_bne
	// exe_btype[3]: is_blt
	// exe_btype[2]: is_bge
	// exe_btype[1]: is_bltu
	// exe_btype[0]: is_bgeu

	// Outputs
	output if_prediction,
	output [1:0] exe_correction,

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


	/*IF stage 
		What happens here:
		- get if_PC, get set (if_PC[3:0]) and tag (if_PC[9:4]) bits 
		- output if_prediction (1 if taken, 0 if not taken)
			- kukunin sa ht[1]
		- output if_PBT (nakukuha from ht[11:2]) is the predicted branch target

		- problem: simulan muna ung table access 
	*/
	//assign if_PBT = 

	/*ID stage
		What happens here:
		- write to table/table access
		- DITO ANG REPLACEMENT!!!
		- replacement scheme: FIFO
		- get the set bits from id_PC[3:0]
	*/

	//16 counters for the sets in the BHT
	reg [1:0] table_counter [0:3];

	// placement/replacement here




// EXE STAGE
	/* 
		Checks if the prediction made is correct, and
		makes changes to the saturating counter.
		Also outputs the corresponding PBT and CNI
		and corresponding correction output.

		Inputs: exe_PC, z, less, branchtype
		Outputs: exe_correction, exe_PBT, exe_CNI

		Check if prediction is correct -> inc/dec counter, output correction
	*/

	wire feedback;	// if feedback = 1, branch compare is correct
	wire is_beq;
	wire is_bne;
	wire is_blt;
	wire is_bge;
	wire is_bltu;
	wire is_bgeu;

	assign is_beq = exe_btype[5];
	assign is_bne = exe_btype[4];
	assign is_blt = exe_btype[3];
	assign is_bge = exe_btype[2];
	assign is_bltu = exe_btype[1];
	assign is_bgeu = exe_btype[0];

	assign feedback =   (is_beq && exe_z)? 1'b1 :
						(is_bne && !exe_z)? 1'b1 : 
						(is_blt && exe_less)? 1'b1 :
						(is_bge && !exe_less)? 1'b1 :
						(is_bltu && exe_less)? 1'b1 :
						(is_bgeu && !exe_less)? 1'b1 :
						1'b0;

	// Searching the table
	// exe_entryX: the entries within the set
	// exe_validX: the valid bit in each entry
	// exe_iseqtoX: determines if the entry contains the same tag bits from the input
	// exe_loadentry: the entry that corresponds to the input
	// is_pred_correct: determines if the prediction is correct
	wire [18:0] exe_entry0, exe_entry1, exe_entry2, exe_entry3;
	wire exe_valid0, exe_valid1, exe_valid2, exe_valid3;
	wire exe_iseqto0, exe_iseqto1, exe_iseqto2, exe_iseqto3;
	reg [18:0] exe_loadentry;
	wire is_pred_correct;

	assign exe_entry0 = history_table[{exe_PC[3:0], 2'b00}];
	assign exe_entry1 = history_table[{exe_PC[3:0], 2'b01}];
	assign exe_entry2 = history_table[{exe_PC[3:0], 2'b10}];
	assign exe_entry3 = history_table[{exe_PC[3:0], 2'b11}];

	assign exe_valid0 = exe_entry0[18];
	assign exe_valid1 = exe_entry1[18];
	assign exe_valid2 = exe_entry2[18];
	assign exe_valid3 = exe_entry3[18];

	assign exe_iseqto0 = (exe_entry0[17:12] == exe_PC[9:4]) && exe_valid0;
	assign exe_iseqto1 = (exe_entry1[17:12] == exe_PC[9:4]) && exe_valid1;
	assign exe_iseqto2 = (exe_entry2[17:12] == exe_PC[9:4]) && exe_valid2;
	assign exe_iseqto3 = (exe_entry3[17:12] == exe_PC[9:4]) && exe_valid3;

	always@(*) begin
		case({exe_iseqto3, exe_iseqto2, exe_iseqto1, exe_iseqto0})
			4'b0001: exe_loadentry = exe_entry0;
			4'b0010: exe_loadentry = exe_entry1;
			4'b0100: exe_loadentry = exe_entry2;
			4'b1000: exe_loadentry = exe_entry3;
			default: exe_loadentry = 19'b0;
		endcase
	end

	// Assign outputs
	assign exe_PBT = exe_loadentry[11:2];
	assign exe_CNI = {exe_loadentry[17:12], exe_PC[3:0]};

	// Check if prediction is correct & output appropriate correction
	assign is_pred_correct = (exe_loadentry[1] == feedback)? /**/

	// Update counter here
	// ...
endmodule