`timescale 1ns / 1ps

/*
	Branch History Table module
	Format of each entry:
	========================================================================
	| Valid bit | Tag[5:0] | Branch target[9:0] | Saturating Counter [1:0] |
	========================================================================
	BHT is implemented as a 4-way Set Associative Cache with 64 entries
	Replacement policy is FIFO
	id_PC[9:0] = {Tag[5:0], Set[3:0]}

	For selecting next PC:
	format of selection bits: {exe_correction[1:0], if_prediction}
		default selection: PC+4
		3'b001: if_PBT
		3'b10x: exe_CNI
		3'b11x: exe_PBT
*/

module branchpredictor(
	input CLK,
	input nrst,
	input en,

	input ISR_running,

	input stall,

	// Inputs
	input [9:0] if_PC,

	input [9:0] id_PC,
	input [9:0] id_branchtarget,
	input id_is_jump,
	input id_is_btype,

	input [9:0] exe_PC,
	input exe_z,				// Feedback from ALU
	input exe_less,				// Feedback from ALU
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

	output reg branch_flush,
	output reg id_jump_in_bht,	// added as an input w/ sel_pc s.t. branch target is selected
								// only when this signal is not asserted, which happens only
								// when the jump instruction is not yet saved into the table

	// Predicted branch target
	output [9:0] if_PBT,
	output [9:0] exe_PBT,

	// Correct Next Instruction = CNI
	output [9:0] exe_CNI
);
	// NOTE: PC ADDRESSES HERE ARE WORD ADDRESSES, NOT BYTE ADDRESSES.
	// Declaring memory for BHT
	/*  format of each line in reg history_table
		========================================================================
		| Valid bit | Tag[6:0] | Branch target[9:0] | Saturating Counter [1:0] |
		| ht[19]    | ht[18:12]| ht[11:2]           | ht[1:0]				   |
		========================================================================
		Where ht = history_table
		*MSB of tag bits = ISR_running
	*/

	reg [19:0] history_table [0:63];


	////////////////////////////////////////////////////////////////////////////

	/*IF stage 
		What happens here:
		- get if_PC, get set (if_PC[3:0]) and tag (if_PC[9:4]) bits 
		- output if_prediction (1 if taken, 0 if not taken)
			- kukunin sa ht[1]
		- output if_PBT (nakukuha from ht[11:2]) is the predicted branch target

		- problem: simulan muna ung table access 
	*/

	// Wire declarations
	// if_entryX: the entries within the set
	// if_validX: the valid bit in each entry
	// if_iseqtoX: determines if the entry contains the same tag bits from the input
	// if_loadentry: the entry that corresponds to the input
	wire [19:0] if_entry [0:3];
	wire [3:0] if_valid;
	wire [3:0] if_iseqto;
	reg [19:0] if_loadentry;

	assign if_entry[0] = history_table[{if_PC[3:0], 2'b00}];
	assign if_entry[1] = history_table[{if_PC[3:0], 2'b01}];
	assign if_entry[2] = history_table[{if_PC[3:0], 2'b10}];
	assign if_entry[3] = history_table[{if_PC[3:0], 2'b11}];

	assign if_valid[0] = if_entry[0][19];
	assign if_valid[1] = if_entry[1][19];
	assign if_valid[2] = if_entry[2][19];
	assign if_valid[3] = if_entry[3][19];

	assign if_iseqto[0] = (if_entry[0][18:12] == {ISR_running, if_PC[9:4]}) && if_valid[0];
	assign if_iseqto[1] = (if_entry[1][18:12] == {ISR_running, if_PC[9:4]}) && if_valid[1];
	assign if_iseqto[2] = (if_entry[2][18:12] == {ISR_running, if_PC[9:4]}) && if_valid[2];
	assign if_iseqto[3] = (if_entry[3][18:12] == {ISR_running, if_PC[9:4]}) && if_valid[3];

	always@(*) begin
		case(if_iseqto)
			4'b1000: if_loadentry = if_entry[3];
			4'b0100: if_loadentry = if_entry[2];
			4'b0010: if_loadentry = if_entry[1];
			4'b0001: if_loadentry = if_entry[0];
			default: if_loadentry = 20'b0;
		endcase
	end

	// Assign outputs
	assign if_PBT = if_loadentry[11:2];
	assign if_prediction = if_loadentry[1];		// prediction bit coming from most recent BHT access

	////////////////////////////////////////////////////////////////////////////////
	

	/*ID stage
		What happens here:
		- write to table/table access
		- DITO ANG REPLACEMENT!!!
		- replacement scheme: FIFO
		- get the set bits from id_PC[3:0]
	*/

	//16 counters for the sets in the BHT
	// placement/replacement here
	// always block for writes
	//1. Find set
	//2. check set counter fifo_counter
	//3. write to history table

	reg [1:0] fifo_counter [0:15];

	wire [19:0] id_entry [0:3];
	wire [3:0] id_valid;
	wire [3:0] id_iseqto;
	wire [1:0] sat_counter;
	wire [3:0] id_set;
	wire [5:0] id_tag;
	assign id_set = id_PC[3:0];
	assign id_tag = id_PC[9:4];

	// Checking each entry within the set to see if the input is already in the table
	assign id_entry[0] = history_table[{id_set, 2'b00}];
	assign id_entry[1] = history_table[{id_set, 2'b01}];
	assign id_entry[2] = history_table[{id_set, 2'b10}];
	assign id_entry[3] = history_table[{id_set, 2'b11}];

	assign id_valid[0] = id_entry[0][19];
	assign id_valid[1] = id_entry[1][19];
	assign id_valid[2] = id_entry[2][19];
	assign id_valid[3] = id_entry[3][19];

	assign id_iseqto[0] = (id_entry[0][18:12] == {ISR_running, id_tag}) && id_valid[0];
	assign id_iseqto[1] = (id_entry[1][18:12] == {ISR_running, id_tag}) && id_valid[1];
	assign id_iseqto[2] = (id_entry[2][18:12] == {ISR_running, id_tag}) && id_valid[2];
	assign id_iseqto[3] = (id_entry[3][18:12] == {ISR_running, id_tag}) && id_valid[3];

	// Saturating counter default states. Branches: WNT | Jumps: ST
	assign sat_counter = (id_is_jump)? 2'b11 : 2'b01;

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

	wire [5:0] exe_tag;
	wire [3:0] exe_set;
	assign exe_tag = exe_PC[9:4];
	assign exe_set = exe_PC[3:0];

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
	// exe_setoffset: determines the offset addr within the set of the entry being accessed
	wire [19:0] exe_entry [0:3];
	wire [3:0] exe_valid;
	wire [3:0] exe_iseqto;
	reg [19:0] exe_loadentry;
	wire is_pred_correct;
	reg [1:0] exe_setoffset;

	assign exe_entry[0] = history_table[{exe_set, 2'b00}];
	assign exe_entry[1] = history_table[{exe_set, 2'b01}];
	assign exe_entry[2] = history_table[{exe_set, 2'b10}];
	assign exe_entry[3] = history_table[{exe_set, 2'b11}];

	assign exe_valid[0] = exe_entry[0][19];
	assign exe_valid[1] = exe_entry[1][19];
	assign exe_valid[2] = exe_entry[2][19];
	assign exe_valid[3] = exe_entry[3][19];

	assign exe_iseqto[0] = (exe_entry[0][18:12] == {ISR_running, exe_tag}) && exe_valid[0];
	assign exe_iseqto[1] = (exe_entry[1][18:12] == {ISR_running, exe_tag}) && exe_valid[1];
	assign exe_iseqto[2] = (exe_entry[2][18:12] == {ISR_running, exe_tag}) && exe_valid[2];
	assign exe_iseqto[3] = (exe_entry[3][18:12] == {ISR_running, exe_tag}) && exe_valid[3];

	always@(*) begin
		case(exe_iseqto)
			4'b1000: exe_loadentry = exe_entry[3];
			4'b0100: exe_loadentry = exe_entry[2];
			4'b0010: exe_loadentry = exe_entry[1];
			4'b0001: exe_loadentry = exe_entry[0];
			default: exe_loadentry = 20'b0;
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
	assign exe_PBT = exe_loadentry[11:2];
	assign exe_CNI = {exe_loadentry[17:12], exe_set} + 10'b1;

	// Check if prediction is correct & output appropriate correction
	// If sat_counter[1] and feedback are equal, then prediction is correct.
	// Else, prediction is wrong and correction output needs to be set.
	assign is_pred_correct = (exe_loadentry[1] == feedback)? 1'b1 : 1'b0;

	// Generating exe_correction:
	// If predictions are wrong, correction bits will depend on 'feedback' signal
	// If feedback = 1, branch comparison is correct, thus branch SHOULD BE TAKEN
	// If feedback = 0, branch SHOULD NOT BE TAKEN
	// ----
	// exe_correction:
	// 2'b00 or 2'b01: No correction needed - next PC address would be PC+4
	// 2'b10: Need to select [C]orrect [N]ext [I]nstruction (CNI)
	// 2'b11: Need to select PBT
	assign exe_correction = (|exe_btype)?
								(is_pred_correct)? 2'b00 		:	// If prediction was correct, no need to change PC again
									(feedback == 1'b0)? 2'b10 	:	// branch should not have been taken, so CNI should be next PC addr
									(feedback == 1'b1)? 2'b11	:	// branch should have been taken, so PBT should be next PC addr
									2'b00 						:
								2'b00;

	////////////////////////////////////////////////////////////////////////////
	// Write back to the table
	integer i;	// Used for resetting fifo_counter & history_table
	initial begin
		for(i = 0; i < 16; i=i+1) begin
			fifo_counter[i] <= 2'b0;
		end
		for(i = 0; i < 64; i=i+1) begin
			history_table[i] <= 20'b0;
		end
	end
	
	always@(posedge CLK) begin
		if(!nrst) begin

			for(i = 0; i < 16; i=i+1) begin
				fifo_counter[i] <= 2'b0;
			end
			for(i = 0; i < 64; i=i+1) begin
				history_table[i] <= 20'b0;
			end

		end else if(en && !stall) begin

			if( (id_is_btype || id_is_jump) && (id_iseqto == 4'h0) ) begin
				// Write to table if (Branch or Jump) AND the input is not in the table yet
				history_table[{id_set, fifo_counter[id_set]}] <= {1'b1, ISR_running, id_tag, id_branchtarget, sat_counter};
				//increment counter
				fifo_counter[id_set] <= fifo_counter[id_set] + 2'b01;
			end

			else if(|exe_btype) begin
				if(feedback == 1'h1) begin
					if(exe_loadentry[1:0] != 2'h3)
						history_table[{exe_set, exe_setoffset}] <= exe_loadentry + 2'b1;
				end

				else begin
					if(exe_loadentry[1:0] != 2'h0)
						history_table[{exe_set, exe_setoffset}] <= exe_loadentry - 2'b1;
				end
				
			end

		end
	end

	////////////////////////////////////////////////////////////////////////////////////////
	//Flushing
	
	//Flush state registers
	reg flush_state;
	reg flush_state_reg;	//delayed flush_state by 1 cycle
	
	always@(posedge CLK) begin
		if(!nrst) begin
			flush_state_reg <= 1'd0;
		end
		else if(en) begin
			flush_state_reg <= flush_state;
		end
	end
	
	always@(*) begin
		if(flush_state_reg) begin
			branch_flush = 1;
			flush_state = 0;
		end else begin
			if(|exe_btype && !is_pred_correct) begin
				flush_state = 1;
				branch_flush = 1;
			end else begin
				flush = 0;
				if(id_is_jump && id_iseqto == 4'h0)
					flush_state = 1;
				else
					flush_state = 0;
			end
		end
	end
	
	always@(*) begin
		if(id_is_jump == 1'b1 && id_iseqto != 4'h0)
			id_jump_in_bht = 1'b1;
		else 
			id_jump_in_bht = 1'b0;
	end
	////////////////////////////////////////////////////////////////////////////////////////
endmodule
