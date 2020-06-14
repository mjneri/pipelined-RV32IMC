//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// branchpredictor.v -- Dynamic Branch Prediction module
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Author: Microlab 198 Pipelined RISC-V Group (2SAY1920)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Module Name: branchpredictor.v
// Description:
// 			Branch History Table module
// 			Format of each entry:
// 			========================================================================================================
// 			| Valid bit | Tag[`BHT_TAG_BITS-1:0] | Branch target[`BHT_PC_ADDR_BITS-1:0] | Saturating Counter [1:0] |
// 			========================================================================================================
// 			BHT is implemented as a 4-way Set Associative Cache with 64 entries
// 			Replacement policy is FIFO
// 			id_PC[10:0] = {Tag[6:0], Set[3:0]}
// 			For selecting next PC:
// 			format of selection bits: {exe_correction[1:0], if_prediction}
// 				default selection: PC+4
// 				3'b001: if_PBT
// 				3'b10x: exe_CNI
// 				3'b11x: exe_PBT
// NOTE: 
//		1. BHT entries can be changed in "constants.vh" under `BHT_ENTRY
//		2. MSB of tag bits is the 'ISR_running' signal
//
// Revisions:
// Revision 0.01 - File Created
// Additional Comments:
// 
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

`timescale 1ns / 1ps
`include "constants.vh"

module branchpredictor(
	input CLK,
	input nrst,

	input ISR_running,

	input stall,

	// Inputs
	input [`BHT_PC_ADDR_BITS-1:0] if_PC,

	input [`BHT_PC_ADDR_BITS-1:0] id_PC,
	input [`BHT_PC_ADDR_BITS-1:0] id_branchtarget,
	input id_is_jump,
	input id_is_btype,

	input [`BHT_PC_ADDR_BITS-1:0] exe_PC,
	input [`BHT_PC_ADDR_BITS-1:0] exe_branchtarget,
	input exe_sel_opBR,			// used to determine if the instruction is JALR, C.JR, or C.JALR
								// which are treated differently than JAL, C.JAL, & C.J
	input exe_z,				// Feedback from ALU
	input exe_less,				// Feedback from ALU
	input exe_signed_less,				// Feedback from ALU
	input [5:0] exe_btype,		// determines what branch instruction was used
								// exe_btype[5]: is_beq
								// exe_btype[4]: is_bne
								// exe_btype[3]: is_blt
								// exe_btype[2]: is_bge
								// exe_btype[1]: is_bltu
								// exe_btype[0]: is_bgeu

	input [1:0] exe_c_btype,	// exe_c_btype[1]: is_beqz
								// exe_c_btype[0]: is_bnez

	// Outputs
	output if_prediction,
	output [1:0] exe_correction,

	output reg jump_flush,
	output reg branch_flush,
	output reg id_jump_in_bht,	// added as an input w/ sel_pc s.t. branch target is selected
								// only when this signal is not asserted, which happens only
								// when the jump instruction is not yet saved into the table

	// Predicted branch target
	output [`BHT_PC_ADDR_BITS-1:0] if_PBT,
	output [`BHT_PC_ADDR_BITS-1:0] exe_PBT,

	// Correct Next Instruction = CNI
	output [`BHT_PC_ADDR_BITS-1:0] exe_CNI
);
	// NOTE: PC ADDRESSES HERE ARE HALFWORD ADDRESSES.
	// Declaring the BHT itself.
	// Format of each line in reg history_table is shown in the module description above.
	reg [`BHT_ENTRY_BITS-1:0] history_table [0:`BHT_ENTRY-1];
	
	// 2 bit counter for each set to represent each entry in the set
	reg [1:0] fifo_counter [0:(`BHT_ENTRY/4)-1];

	// Wire declarations
	// if_entryX: the entries within the set
	// if_validX: the valid bit in each entry
	// if_iseqtoX: determines if the entry contains the same tag bits from the input
	// if_loadentry: the entry that corresponds to the input
	wire [`BHT_ENTRY_BITS-1:0] if_entry [0:3];
	reg  [`BHT_ENTRY_BITS-1:0] if_loadentry;
	wire [`BHT_SET_BITS-1:0] if_set = if_PC[`BHT_SET_BITS-1:0];
	wire [`BHT_TAG_BITS-1:0] if_tag = if_PC[`BHT_PC_TAG_FIELD];
	wire [3:0] if_valid;
	wire [3:0] if_iseqto;

	// Checking each entry within the set to see if the input is already in the table
	assign if_entry[0] = history_table[{if_set, 2'b00}];
	assign if_entry[1] = history_table[{if_set, 2'b01}];
	assign if_entry[2] = history_table[{if_set, 2'b10}];
	assign if_entry[3] = history_table[{if_set, 2'b11}];

	assign if_valid[0] = if_entry[0][`BHT_ENTRY_BITS-1];
	assign if_valid[1] = if_entry[1][`BHT_ENTRY_BITS-1];
	assign if_valid[2] = if_entry[2][`BHT_ENTRY_BITS-1];
	assign if_valid[3] = if_entry[3][`BHT_ENTRY_BITS-1];

	assign if_iseqto[0] = (if_entry[0][`BHT_TAG_FIELD] == {ISR_running, if_tag}) && if_valid[0];
	assign if_iseqto[1] = (if_entry[1][`BHT_TAG_FIELD] == {ISR_running, if_tag}) && if_valid[1];
	assign if_iseqto[2] = (if_entry[2][`BHT_TAG_FIELD] == {ISR_running, if_tag}) && if_valid[2];
	assign if_iseqto[3] = (if_entry[3][`BHT_TAG_FIELD] == {ISR_running, if_tag}) && if_valid[3];

	always@(*) begin
		case(if_iseqto)
			4'b1000: if_loadentry = if_entry[3];
			4'b0100: if_loadentry = if_entry[2];
			4'b0010: if_loadentry = if_entry[1];
			4'b0001: if_loadentry = if_entry[0];
			default: if_loadentry = {`BHT_ENTRY_BITS{1'b0}};
		endcase
	end

	// Assign outputs
	assign if_PBT = if_loadentry[`BHT_PC_ADDR_BITS+1:2];
	// prediction bit coming from most recent BHT access; if_prediction = saturating counter[1]
	assign if_prediction = if_loadentry[1];


	// Wire declarations for ID stage accesses
	wire [`BHT_ENTRY_BITS-1:0] id_entry [0:3];
	wire [`BHT_SET_BITS-1:0] id_set = id_PC[`BHT_SET_BITS-1:0];
	wire [`BHT_TAG_BITS-1:0] id_tag = id_PC[`BHT_PC_TAG_FIELD];
	wire [3:0] id_valid;
	wire [3:0] id_iseqto;

	// Checking each entry within the set to see if the input is already in the table
	assign id_entry[0] = history_table[{id_set, 2'b00}];
	assign id_entry[1] = history_table[{id_set, 2'b01}];
	assign id_entry[2] = history_table[{id_set, 2'b10}];
	assign id_entry[3] = history_table[{id_set, 2'b11}];

	assign id_valid[0] = id_entry[0][`BHT_ENTRY_BITS-1];
	assign id_valid[1] = id_entry[1][`BHT_ENTRY_BITS-1];
	assign id_valid[2] = id_entry[2][`BHT_ENTRY_BITS-1];
	assign id_valid[3] = id_entry[3][`BHT_ENTRY_BITS-1];

	assign id_iseqto[0] = (id_entry[0][`BHT_TAG_FIELD] == {ISR_running, id_tag}) && id_valid[0];
	assign id_iseqto[1] = (id_entry[1][`BHT_TAG_FIELD] == {ISR_running, id_tag}) && id_valid[1];
	assign id_iseqto[2] = (id_entry[2][`BHT_TAG_FIELD] == {ISR_running, id_tag}) && id_valid[2];
	assign id_iseqto[3] = (id_entry[3][`BHT_TAG_FIELD] == {ISR_running, id_tag}) && id_valid[3];// if id_iseq = 0, then input is not in table yet

	// Saturating counter default states. Branches: WNT | Jumps: ST
	wire [1:0] sat_counter;
	assign sat_counter = (id_is_jump)? 2'b11 : 2'b01;


	// EXE STAGE Accesses:
	// Checks if the prediction made is correct, and makes changes to the saturating counter.
	// Also outputs the corresponding PBT (Predicted Branch Target) and CNI (Correct Next Instruction) 
	// and corresponding correction output.
	// Inputs: exe_PC, z, less, signed_less, branchtype
	// Outputs: exe_correction, exe_PBT, exe_CNI
	// Check if prediction is correct -> inc/dec counter, output correction
	wire is_beq = exe_btype[5];
	wire is_bne = exe_btype[4];
	wire is_blt = exe_btype[3];
	wire is_bge = exe_btype[2];
	wire is_bltu = exe_btype[1];
	wire is_bgeu = exe_btype[0];
	wire is_beqz = exe_c_btype[1];
	wire is_bnez = exe_c_btype[0];

	// if feedback = 1, branch compare is correct
	wire feedback = (is_beq && exe_z)? 1'b1 :
					(is_bne && !exe_z)? 1'b1 : 
					(is_blt && exe_signed_less)? 1'b1 :
					(is_bge && !exe_signed_less)? 1'b1 :
					(is_bltu && exe_less)? 1'b1 :
					(is_bgeu && !exe_less)? 1'b1 :
					(is_beqz && exe_z)? 1'b1 :
					(is_bnez && !exe_z)? 1'b1 :
					1'b0;

	// Searching the table
	// exe_entryX: the entries within the set
	// exe_validX: the valid bit in each entry
	// exe_iseqtoX: determines if the entry contains the same tag bits from the input
	// exe_loadentry: the entry that corresponds to the input
	// exe_setoffset: determines the offset addr within the set of the entry being accessed
	wire [`BHT_ENTRY_BITS-1:0] exe_entry [0:3];
	reg  [`BHT_ENTRY_BITS-1:0] exe_loadentry;
	wire [`BHT_SET_BITS-1:0] exe_set = exe_PC[`BHT_SET_BITS-1:0];
	wire [`BHT_TAG_BITS-1:0] exe_tag = exe_PC[`BHT_PC_TAG_FIELD];
	reg [1:0] exe_setoffset;
	wire [3:0] exe_valid;
	wire [3:0] exe_iseqto;

	assign exe_entry[0] = history_table[{exe_set, 2'b00}];
	assign exe_entry[1] = history_table[{exe_set, 2'b01}];
	assign exe_entry[2] = history_table[{exe_set, 2'b10}];
	assign exe_entry[3] = history_table[{exe_set, 2'b11}];

	assign exe_valid[0] = exe_entry[0][`BHT_ENTRY_BITS-1];
	assign exe_valid[1] = exe_entry[1][`BHT_ENTRY_BITS-1];
	assign exe_valid[2] = exe_entry[2][`BHT_ENTRY_BITS-1];
	assign exe_valid[3] = exe_entry[3][`BHT_ENTRY_BITS-1];

	assign exe_iseqto[0] = (exe_entry[0][`BHT_TAG_FIELD] == {ISR_running, exe_tag}) && exe_valid[0];
	assign exe_iseqto[1] = (exe_entry[1][`BHT_TAG_FIELD] == {ISR_running, exe_tag}) && exe_valid[1];
	assign exe_iseqto[2] = (exe_entry[2][`BHT_TAG_FIELD] == {ISR_running, exe_tag}) && exe_valid[2];
	assign exe_iseqto[3] = (exe_entry[3][`BHT_TAG_FIELD] == {ISR_running, exe_tag}) && exe_valid[3];

	always@(*) begin
		case(exe_iseqto)
			4'b1000: exe_loadentry = exe_entry[3];
			4'b0100: exe_loadentry = exe_entry[2];
			4'b0010: exe_loadentry = exe_entry[1];
			4'b0001: exe_loadentry = exe_entry[0];
			default: exe_loadentry = {`BHT_ENTRY_BITS{1'b0}};
		endcase
	end

	always@(*) begin
		case(exe_iseqto)
			4'b1000: exe_setoffset = 2'h3;
			4'b0100: exe_setoffset = 2'h2;
			4'b0010: exe_setoffset = 2'h1;
			4'b0001: exe_setoffset = 2'h0;
			default: exe_setoffset = 2'h0;
		endcase
	end

	// Assign outputs
	// SPECIAL CASES: jalr, c.jr, c.jalr
	// Since branch targets of these cases can change depending on the registers used,
	// we check if the branch target stored in the table is the same as the 
	// computed branch target. If not, we update the table & flush the next 2 cycles.
	// For exe_CNI: check if branch instruction is compressed to determine if next instruction is at next halfword
	assign exe_PBT = (exe_sel_opBR)? exe_branchtarget : exe_loadentry[`BHT_PC_ADDR_BITS+1:2];
	assign exe_CNI = {exe_loadentry[`BHT_CNI_TAG_FIELD], exe_set} + ((|exe_c_btype)? 2'd1 : 2'd2);
	
	// is_pred_correct: determines if the prediction is correct
	// Check if prediction is correct & output appropriate correction
	// If sat_counter[1] and feedback are equal, then prediction is correct.
	// Else, prediction is wrong and correction output needs to be set.
	wire is_pred_correct = (exe_loadentry[1] == feedback)? 1'b1 : 1'b0;

	// Generating exe_correction:
	// If predictions are wrong, correction bits will depend on 'feedback' signal
	// If feedback = 1, branch comparison is correct, thus branch SHOULD BE TAKEN
	// If feedback = 0, branch SHOULD NOT BE TAKEN
	// ----
	// SPECIAL CASE (JALR, C.JALR, C.JR) if computed branch target (exe_branchtarget)
	// is different from stored PBT (basically if predicted branch target is wrong),
	// branchtarget should be taken
	// ----
	// exe_correction:
	// 2'b00: No correction needed
	// 2'b10: Need to select CNI
	// 2'b11: Need to select PBT
	assign exe_correction = (|exe_btype || |exe_c_btype)?
								(is_pred_correct)? 2'b00 		:	// If prediction was correct, no need to change PC again
									(feedback == 1'b0)? 2'b10 	:	// branch should not have been taken, so CNI should be next PC addr
									(feedback == 1'b1)? 2'b11	:	// branch should have been taken, so PBT should be next PC addr
									2'b00 						:
							(exe_sel_opBR && (exe_branchtarget != exe_loadentry[`BHT_PC_ADDR_BITS+1:2]))?
									2'b11						:
								2'b00;

	////////////////////////////////////////////////////////////////////////////
	// WRITES TO FIFO_COUNTER & HISTORY_TABLE
	// Initialize registers
	integer i;
	initial begin
		for(i = 0; i < (`BHT_ENTRY/4); i=i+1) begin
			fifo_counter[i] <= 2'b0;
		end
		for(i = 0; i < `BHT_ENTRY; i=i+1) begin
			history_table[i] <= {`BHT_ENTRY_BITS{1'b0}};
		end
	end
	
	always@(posedge CLK) begin
		if(!nrst) begin
			for(i = 0; i < (`BHT_ENTRY/4); i=i+1) begin
				fifo_counter[i] <= 2'b0;
			end
			for(i = 0; i < `BHT_ENTRY; i=i+1) begin
				history_table[i] <= {`BHT_ENTRY_BITS{1'b0}};
			end
		end else if(!stall) begin
			// ID Stage writes
			if( (id_is_btype || id_is_jump) && (id_iseqto == 4'h0) ) begin
				// Write to table if Branch or Jump AND the input is not in the table yet
				history_table[{id_set, fifo_counter[id_set]}] <= {1'b1, ISR_running, id_tag, id_branchtarget, sat_counter};

				// increment counter
				fifo_counter[id_set] <= fifo_counter[id_set] + 2'b01;
			end

			// EXE Stage writes
			// Update branch target for register-based jumps (jalr, c.jr, c.jalr)
			else if(exe_sel_opBR && (exe_branchtarget != exe_loadentry[`BHT_PC_ADDR_BITS+1:2]))
				history_table[{exe_set, exe_setoffset}] <= {exe_loadentry[`BHT_TAG_FIELD], exe_branchtarget, exe_loadentry[1:0]};
			
			// Update saturating counter for branch instructions
			else if(|exe_btype || |exe_c_btype) begin
				if(feedback == 1'h1)
					if(exe_loadentry[1:0] != 2'h3)
						history_table[{exe_set, exe_setoffset}] <= exe_loadentry + 2'b1;
				else
					if(exe_loadentry[1:0] != 2'h0)
						history_table[{exe_set, exe_setoffset}] <= exe_loadentry - 2'b1;
			end
		end
	end


	////////////////////////////////////////////////////////////////////////////////////////
	//Flushing
	always@(*) begin
		if(!stall) begin
			if( ((|exe_btype || |exe_c_btype) && !is_pred_correct) || (exe_sel_opBR && (exe_branchtarget != exe_loadentry[`BHT_PC_ADDR_BITS+1:2])) )
				branch_flush = 1;
			else
				branch_flush = 0;
		end else
			branch_flush = 0;
	end

	always@(*) begin
		if(!stall)
			if(id_is_jump && id_iseqto == 4'h0)
				jump_flush = 1;
			else
				jump_flush = 0;
		else
			jump_flush = 0;
	end
	
	always@(*) begin
		if(id_is_jump && id_iseqto != 4'h0)
			id_jump_in_bht = 1'b1;
		else 
			id_jump_in_bht = 1'b0;
	end
	////////////////////////////////////////////////////////////////////////////////////////
endmodule