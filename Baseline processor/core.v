//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// core.v -- Pipelined RISCV Core
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Author: Microlab 198 Pipelined RISC-V Group (2SAY1920)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Module Name: core.v
// Description: This module contains the submodules needed to implement a
//				five-stage RISC-V processor.
//				Signal names:
//					+ if_XXXXX : IF stage, id_XXXXX : ID stage, etc.
//
// Revisions:
// Revision 0.01 - File Created
// Additional Comments:
// 
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

`timescale 1ns / 1ps

`include "constants.vh"

module core(
	input CLKIP_OUT,			// 50MHz unbuffered clock
	input CLK_BUF,				// 50MHz buffered clock
	input nrst,

	// Interrupt signals
	input [`INT_SIG_WIDTH-1:0] int_sig,

	// inputs from protocol controllers
	input [3:0] con_write,
	input [10:0] con_addr,		// Word-aligned data address
	input [31:0] con_in,
	output [31:0] con_out		// Ouput of DATAMEM connected to Protocol controllers

	// Debug signals for post-synthesis simulations
	// output [11:0] if_PC,
	// output [11:0] id_PC,
	// output [11:0] exe_PC,
	// output [11:0] mem_PC,
	// output [11:0] wb_PC,
	// output [31:0] if_inst,
	// output if_stall,
	// output ISR_PC_flush,
	// output ISR_pipe_flush,
	// output ISR_running,
	// output [11:0] save_PC,
	// output jump_flush,
	// output branch_flush,
	// output exe_is_stype,
	// output [3:0] exe_dm_write,
	// output [31:0] exe_ALUout,
	// output [2:0] wb_sel_data,
	// output [31:0] wb_wr_data

);
	
/******************************** DECLARING WIRES *******************************/

// IF stage ======================================================================
	reg [11:0] if_pcnew;		// Input to PC; new PC address
	wire [11:0] if_PC;			// Output of PC, input to INSTMEM
	wire [11:0] if_pc4;			// PC + 4
	wire [31:0] if_inst;		// INSTMEM Output
// &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&





// ID Stage ======================================================================
	// Outputs of IF/ID Pipeline Register
	wire [11:0] id_pc4;			// PC + 4
	wire [31:0] id_inst;		// 32bit Instruction
	wire [11:0] id_PC;			// PC

	// Other Datapath signals
	wire [31:0] id_brOP;				// For computing branch target address
	wire id_jump_in_bht;				// For jumps already in BHT
	
	// 32-bit instruction parts
	wire [6:0] id_opcode;				// opcode
	wire [2:0] id_funct3;				// funct3
	wire [6:0] id_funct7;				// funct7
	wire [4:0] id_rsA, id_rsB;			// source registers
	wire [4:0] id_rd;					// destination register
	assign id_opcode = id_inst[6:0];
	assign id_funct3 = id_inst[14:12];
	assign id_funct7 = id_inst[31:25];
	// assign id_rsA = id_inst[19:15];
	// assign id_rsB = id_inst[24:20];
	// assign id_rd = id_inst[11:7];

	// Control signals ///////////////////////////////////////////////////////////
	wire [3:0] id_ALU_op;								// For EXE stage 		//
	wire id_div_valid;									// For EXE stage 		//
	wire [1:0] id_div_op;								// For EXE stage 		//
	wire id_sel_opA, id_sel_opB;						// For EXE stage 		//
	wire id_is_stype;									// For EXE stage 		//
	wire id_is_jump;									// For ID stage 		//
	wire id_is_btype;									// For ID Stage 		//
	wire id_is_nop; 									// For ID stage 		//
	wire id_wr_en;										// For WB stage 		//
	wire [2:0] id_dm_select;							// For MEM stage 		//
	wire [2:0] id_imm_select;							// For ID stage 		//
	wire id_sel_pc;										// For EXE stage 		//
	wire [2:0] id_sel_data;								// For WB stage 		//
	wire [1:0] id_store_select;							// For EXE stage 		//
	wire id_sel_opBR;									// For ID stage 		//
	//////////////////////////////////////////////////////////////////////////////

	// Inputs to ID/EXE Pipereg 														
	wire [31:0] id_rfoutA, id_rfoutB;	// Regfile outputs 								
	wire [31:0] id_imm;					// Output of SHIFT, SIGN EXT, AND SHUFFLE block

	wire [31:0] id_branchtarget;		// Computed branch target

	wire [31:0] id_fwdopA, id_fwdopB;	// Selected operands based on forwarded data
	wire [31:0] id_fwdstore;			// Selected input to STOREBLOCK based on forwarded data
// &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&





// EXE Stage =====================================================================
	// Outputs of ID/EXE Pipeline Register
	wire [11:0] exe_pc4;			// PC + 4
	wire [31:0] exe_fwdopA;			// Selected opA in ID stage based on forwarded data
	wire [31:0] exe_fwdopB;			// Selected opB in ID stage based on forwarded data
	wire [31:0] exe_inst;			// 32 bit instruction
	wire [31:0] exe_fwdstore;		// Selected input to STOREBLOCK based on forwarded data
	// wire [31:0] exe_rfoutA;			// Regfile output A
	// wire [31:0] exe_rfoutB;			// Regfile output B
	wire [31:0] exe_imm;			// Immediate
	wire [4:0] exe_rd;				// Destination register
	wire [11:0] exe_PC;				// PC
	wire [31:0] exe_branchtarget;	// Computed branch target

	// Other wires used inside EXE stage
	wire [31:0] opA;				// Input opA to ALU & Divider
	wire [31:0] opB;				// Input opB to ALU & Divider
	wire [31:0] exe_rstore;			// Input data to STOREBLOCK
	wire exe_div_running;			// (From Divider) Input to SF controller
	wire mul_stall;					// (From ALU) Input to SF controller

	wire [4:0] exe_rsA;				// Source register A
	wire [4:0] exe_rsB;				// Source register B
	// assign exe_rsA = exe_inst[19:15];
	// assign exe_rsB = exe_inst[24:20];

	wire exe_z;						// Output of ALU; used for evaluating Branches
	wire exe_less;					// Output of ALU; used for evaluating Branches
	wire exe_signed_less;					// Output of ALU; used for evaluating Branches
	wire [2:0] exe_funct3;			// Used for generating exe_btype
	wire [6:0] exe_opcode;			// Used for generating exe_btype
	wire [5:0] exe_btype;			// Determines what branch instruction is in EXE stage
	assign exe_opcode = exe_inst[6:0];
	assign exe_funct3 = exe_inst[14:12];
	assign exe_btype[5] = (exe_opcode == 7'h63)? ( (exe_funct3 == 3'h0)? 1'b1 : 1'b0) : 1'b0;	// BEQ
	assign exe_btype[4] = (exe_opcode == 7'h63)? ( (exe_funct3 == 3'h1)? 1'b1 : 1'b0) : 1'b0;	// BNE
	assign exe_btype[3] = (exe_opcode == 7'h63)? ( (exe_funct3 == 3'h4)? 1'b1 : 1'b0) : 1'b0;	// BLT
	assign exe_btype[2] = (exe_opcode == 7'h63)? ( (exe_funct3 == 3'h5)? 1'b1 : 1'b0) : 1'b0;	// BGE
	assign exe_btype[1] = (exe_opcode == 7'h63)? ( (exe_funct3 == 3'h6)? 1'b1 : 1'b0) : 1'b0;	// BLTU
	assign exe_btype[0] = (exe_opcode == 7'h63)? ( (exe_funct3 == 3'h7)? 1'b1 : 1'b0) : 1'b0;	// BGEU

	// Control signals
	wire [3:0] exe_ALU_op;			// For EXE stage
	wire exe_div_valid;				// For EXE stage
	wire [1:0] exe_div_op;			// For EXE stage
	//wire exe_sel_opA, exe_sel_opB;	// For EXE stage 
	wire exe_is_stype;				// For EXE stage
	wire [3:0] exe_dm_write;		// For MEM stage
	wire exe_wr_en;					// For WB stage
	wire [2:0] exe_dm_select;		// For MEM stage
	wire [2:0] exe_sel_data;		// For WB stage
	wire [1:0] exe_store_select;	// For EXE stage
	wire exe_sel_opBR;				// For EXE stage

	// Inputs to EXE/MEM Pipereg
	wire [31:0] exe_ALUout;			// ALU output
	wire [31:0] exe_DIVout;			// Divider output
	wire [31:0] exe_storedata;		// Output of STORE BLOCK
// &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&





// MEM Stage =====================================================================
	// Outputs of EXE/MEM Pipeline Register
	wire [11:0] mem_pc4;			// PC + 4
	wire [31:0] mem_inst;			// 32bit instruction
	wire [31:0] mem_ALUout;			// ALU output
	wire [31:0] mem_DIVout;			// Divider output
	wire [31:0] mem_storedata;		// Input data to DATAMEM
	wire [31:0] mem_imm;			// 32bit Immediate
	wire [4:0]  mem_rd;				// Destination register
	wire [11:0] mem_PC;				// PC

	// Control signals
	wire [3:0] mem_dm_write;		// For MEM stage
	wire mem_wr_en;					// For WB stage
	wire [2:0] mem_dm_select;		// For MEM stage
	wire [2:0] mem_sel_data;		// For WB stage

	// MEM Stage Datapath Signals
	wire[31:0] mem_DATAMEMout;		// Output of DATAMEM

	// Inputs to MEM/WB Pipereg
	wire [31:0] mem_loaddata;		// Output of LOAD BLOCK
// &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&





// WB Stage ======================================================================
	// Outputs of MEM/WB Pipeline Register
	wire [11:0] wb_pc4;				// PC + 4
	wire [31:0] wb_inst;			// 32bit instruction
	wire [31:0] wb_ALUout;			// ALU output
	wire [31:0] wb_DIVout;			// Divider output
	wire [31:0] wb_loaddata;		// Output of LOAD BLOCK
	wire [31:0] wb_imm;				// 32bit Immediate
	wire [4:0] wb_rd;				// Destination register
	wire [11:0] wb_PC;				// PC

	// Control signals
	wire wb_wr_en;					// For WB stage
	wire [2:0] wb_sel_data;			// For WB stage

	// Datapath signals
	wire [31:0] wb_wr_data;
// &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&





// Signals for BHT ===============================================================
	wire if_prediction;				// Input to sel_PC mux
	wire [1:0] exe_correction;		// input to sel_PC mux
	wire [10:0] if_PBT;				// Predicted branch target
	wire [10:0] exe_PBT;				// Predicted branch target
	wire [10:0] exe_CNI;				// Correct Next Instruction
	wire branch_flush;
	wire jump_flush;
// &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&





// Data Forwarding Control Signals ===============================================
	wire fw_exe_to_id_A;
    wire fw_exe_to_id_B;

    wire fw_mem_to_id_A;
    wire fw_mem_to_id_B;

	wire fw_wb_to_id_A;
    wire fw_wb_to_id_B;

    wire fw_wb_to_exe_A;
    wire fw_wb_to_exe_B;

	wire load_hazard;
// &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&





// Clock Gating + SF_Controller ==================================================
	// wire CLK_BUF;			// Clock buffer output
	wire if_clk;			// CLK input to PC
	wire id_clk;			// CLK input to IF/ID pipereg
	wire exe_clk;			// CLK input to ID/EXE pipereg
	wire mem_clk;			// CLK input to EXE/MEM pipereg & DATAMEM
	wire wb_clk;			// CLK input to MEM/WB pipereg
	wire rf_clk;			// CLK input to Register file
	
	wire if_clk_en;
	wire id_clk_en;
	wire exe_clk_en;
	wire mem_clk_en;
	wire wb_clk_en;
	wire rf_clk_en;
	
	wire if_stall;			// Controls PC + Instmem stall
	wire id_stall;			// Controls IF/ID + BHT stall
	wire exe_stall; 		// Controls ID/EXE stall
	wire mem_stall;			// Controls EXE/MEM + Datamem stall
	wire wb_stall; 			// Controls MEM/WB stall

	wire if_flush;			// Controls PC flush
	wire id_flush;			// Controls IF/ID flush
	wire exe_flush; 		// Controls ID/EXE flush
	wire mem_flush; 		// Controls EXE/MEM flush
	wire wb_flush; 			// Controls MEM/WB flush
// &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&





// ID Baseline Instructions ======================================================
    wire [2:0] id_base_dm_select;
    wire [2:0] id_base_imm_select;
    wire [2:0] id_base_sel_data;
    wire [1:0] id_base_store_select;
    wire [3:0] id_base_ALU_op;
    wire id_base_sel_opA;
    wire id_base_sel_opB;
    wire id_base_is_stype;
    wire id_base_wr_en;
    wire [4:0] id_base_rsA = id_inst[19:15];
    wire [4:0] id_base_rsB = id_inst[24:20];
    wire [4:0] id_base_rd = id_inst[11:7];
    wire [31:0] id_base_imm;
    // wire [31:0] id_base_jt;
	wire id_base_is_jump;
	wire id_base_is_btype;
	wire id_base_sel_pc;
	wire id_base_sel_opBR;
// &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&





// Compressed Instructions =======================================================
    wire if_not_comp = (if_inst[1:0] == 2'd3);           // Compressed or not
    wire id_is_comp;
	wire exe_is_comp;
	
	// compressed control signals
    wire [2:0] id_c_dm_select;
    wire [2:0] id_c_imm_select;
    wire [2:0] id_c_sel_data;
    wire [1:0] id_c_store_select;
    wire [3:0] id_c_alu_op;
    wire id_c_sel_opA;
    wire id_c_sel_opB;
	wire id_c_sel_pc;
	wire id_c_sel_opBR;
    wire id_c_is_stype;
    wire id_c_wr_en;
	wire [1:0] id_c_btype;
	wire id_c_use_A;
	wire id_c_use_B;
	wire id_c_is_jump;
	wire id_c_is_btype;
	wire id_c_is_nop;

	// registers and immediates
    wire [4:0] id_c_rsA;
    wire [4:0] id_c_rsB;
    wire [4:0] id_c_rd;
    wire [31:0] id_c_imm;
    wire [31:0] id_c_jt;
    
	// signals for later stages
	wire exe_comp_use_A;
	wire exe_comp_use_B;
	wire [1:0] exe_c_btype;
// &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
    




// Interrupt Controller Signals===================================================

	wire ISR_PC_flush;
	wire ISR_pipe_flush;
	wire sel_ISR;
	wire ret_ISR;
	wire ISR_running;
	wire [11:0] save_PC;

// &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&



/*********************** DATAPATH (INSTANTIATING MODULES) ***********************/
// STALL, FLUSH, and FORWARDING Controller =======================================
	sf_controller SF_CONTROLLER(
		.clk(CLK_BUF),
		.nrst(nrst),

		// Inputs from IF stage
		.if_pc(if_PC),

		// Inputs from ID stage
		.id_pc(id_PC),
		.is_jump(id_is_jump),
		.is_nop(id_is_nop),

		.ISR_PC_flush(ISR_PC_flush),
		.ISR_pipe_flush(ISR_pipe_flush),
		.branch_flush(branch_flush),
		.jump_flush(jump_flush),
		.mul_stall(mul_stall),
		.div_running(exe_div_running),

		// Stall signals
		.if_stall(if_stall),
		.id_stall(id_stall),
		.exe_stall(exe_stall),
		.mem_stall(mem_stall),
		.wb_stall(wb_stall),

		// Flushes/resets
		.if_flush(if_flush),
		.id_flush(id_flush),
		.exe_flush(exe_flush),
		.mem_flush(mem_flush),
		.wb_flush(wb_flush),

		// Clock enables
		.if_clk_en(if_clk_en),
		.id_clk_en(id_clk_en),
		.exe_clk_en(exe_clk_en),
		.mem_clk_en(mem_clk_en),
		.wb_clk_en(wb_clk_en),
		.rf_clk_en(rf_clk_en),

		// Forwarding Unit inputs and outputs
		// Source registers
		.id_rsA(id_rsA),
		.id_rsB(id_rsB),
		.exe_rsA(exe_rsA),
		.exe_rsB(exe_rsB),

		// Destination registers
		.exe_rd(exe_rd),
		.mem_rd(mem_rd),
		.wb_rd(wb_rd),

		// Control signals
		.exe_wr_en(exe_wr_en),
		.mem_wr_en(mem_wr_en),
		.wb_wr_en(wb_wr_en),

		.id_sel_opA(id_sel_opA),
		.id_sel_opB(id_sel_opB),

		//.id_sel_data(id_sel_data),
		.exe_sel_data(exe_sel_data),
		.mem_sel_data(mem_sel_data),
		.wb_sel_data(wb_sel_data),

		.id_is_stype(id_is_stype),
		//.exe_is_stype(exe_is_stype),

		.id_imm_select(id_imm_select),

		.id_opcode(id_opcode),
		.exe_opcode(exe_opcode),
		.exe_comp_use_A(exe_comp_use_A),
		.exe_comp_use_B(exe_comp_use_B),
		.exe_is_comp(exe_is_comp),
		.id_sel_opBR(id_sel_opBR),

		// Outputs
		.fw_exe_to_id_A(fw_exe_to_id_A),
		.fw_exe_to_id_B(fw_exe_to_id_B),
		.fw_mem_to_id_A(fw_mem_to_id_A),
		.fw_mem_to_id_B(fw_mem_to_id_B),
		.fw_wb_to_id_A(fw_wb_to_id_A),
		.fw_wb_to_id_B(fw_wb_to_id_B),

		.fw_wb_to_exe_A(fw_wb_to_exe_A),
		.fw_wb_to_exe_B(fw_wb_to_exe_B),
		.load_hazard(load_hazard)
	);

// CLOCKS ========================================================
	// BUFG clk_buf(
	// 	.I(CLK),
	// 	.O(CLK_BUF)
	// );

	BUFGCE en_iF (
	 	.I(CLKIP_OUT),
	 	.CE(if_clk_en),
	 	.O(if_clk)
	);

	BUFGCE en_id (
	 	.I(CLKIP_OUT),
	 	.CE(id_clk_en),
	 	.O(id_clk)
	);

	BUFGCE en_exe (
	 	.I(CLKIP_OUT),
	 	.CE(exe_clk_en),
	 	.O(exe_clk)
	);

	BUFGCE en_mem (
	 	.I(CLKIP_OUT),
	 	.CE(mem_clk_en),
	 	.O(mem_clk)
	);

	BUFGCE en_wb (
	 	.I(CLKIP_OUT),
	 	.CE(wb_clk_en),
	 	.O(wb_clk)
	);

	BUFGCE en_rf(
	 	.I(CLKIP_OUT),
	 	.CE(rf_clk_en),
	 	.O(rf_clk)
	);


// IF Stage ======================================================================
	pc PC( 
		.clk(if_clk),
		.nrst(nrst),

		.flush(if_flush),
		.stall(if_stall),

		.addr_in(if_pcnew),
		.inst_addr(if_PC)
	);

	instmem INSTMEM( 
		.clk(CLK_BUF),
		.sel_ISR(sel_ISR),

		.addr(if_PC),
		.inst(if_inst)
	);

	interrupt_controller INT_CON(
		.clk(CLK_BUF),
		.nrst(nrst),
		.stall(if_stall),

		.if_pcnew(if_pcnew),
		.if_PC(if_PC),
		.exe_opcode(exe_opcode),
		.int_sig(int_sig),

		.if_prediction(if_prediction),
		.exe_correction(exe_correction),
		.id_jump_in_bht(id_jump_in_bht),
		.id_sel_pc(id_sel_pc),

		//.ISR_stall(ISR_stall),
		.ISR_PC_flush(ISR_PC_flush),
		.ISR_pipe_flush(ISR_pipe_flush),
		.sel_ISR(sel_ISR),
		.ret_ISR(ret_ISR),
		//.ISR_en(ISR_en),

		.ISR_running(ISR_running),
		.save_PC(save_PC)
	);

	// PC + 4
	assign if_pc4 = if_PC + (if_not_comp ? 12'd4 : 12'd2); // buff_stall ? if_PC : if_PC + 12'd4;

	// PC Selection
	// Check for exe_correction, then jumps in ID stage, then check if_prediction last
	// This is so when a branch/jump in the EXE or ID stage has to flush earlier stages,
	// branches/jumps in the IF stage that are predicted to take the branch target won't get
	// executed since they're supposed to be flushed anyway.
	always@(*) begin
		if(ret_ISR)
			if_pcnew = save_PC;
		else begin
			case(exe_correction)
				2'b10: if_pcnew = {exe_CNI, 1'h0};
				2'b11: if_pcnew = {exe_PBT, 1'h0};
				default: begin
					case({id_jump_in_bht, id_sel_pc})
						2'b01: if_pcnew = id_branchtarget;
						default: if_pcnew = if_prediction? {if_PBT, 1'h0} : if_pc4;
					endcase
				end
			endcase
		end
	end

	pipereg_if_id IF_ID(
		.clk(id_clk),
		.nrst(nrst),

		.flush(id_flush),
		.stall(id_stall),

		.if_pc4(if_pc4), 	.id_pc4(id_pc4),
		.if_inst(if_inst), 	.id_inst(id_inst),
		.if_PC(if_PC), 		.id_PC(id_PC)
	);



// ID Stage ======================================================================
	// Selecting operands
	// id_fwdopA is passed through ID/EXE pipeline register to the ALU
	assign id_fwdopA = fw_exe_to_id_A?
							(exe_sel_data == 3'd4)? exe_DIVout		:
							(exe_sel_data == 3'd2)? exe_imm			: 
							(exe_sel_data == 3'd1)? exe_ALUout		:
													exe_pc4			:												 
					   fw_mem_to_id_A?
					   		(mem_sel_data == 3'd4)? mem_DIVout		:
					   		(mem_sel_data == 3'd3)? mem_loaddata	:
					   		(mem_sel_data == 3'd2)? mem_imm			:
					   		(mem_sel_data == 3'd1)? mem_ALUout		:
					   								mem_pc4			:
					   fw_wb_to_id_A?
					   		wb_wr_data								:
					   id_sel_opA?
					   		id_rfoutA : id_PC;
							   
	// id_fwdopB is passed through ID/EXE pipeline register to the ALU
	assign id_fwdopB = (fw_exe_to_id_B && !id_is_stype)?
							(exe_sel_data == 3'd4)? exe_DIVout		:             
							(exe_sel_data == 3'd2)? exe_imm			: 
							(exe_sel_data == 3'd1)? exe_ALUout 		:
													exe_pc4			:
					   (fw_mem_to_id_B && !id_is_stype)?
					   		(mem_sel_data == 3'd4)? mem_DIVout		:
					   		(mem_sel_data == 3'd3)? mem_loaddata	:
					   		(mem_sel_data == 3'd2)? mem_imm			:
					   		(mem_sel_data == 3'd1)? mem_ALUout		:
					   								mem_pc4			:
					   (fw_wb_to_id_B && !id_is_stype)?
					   		wb_wr_data								:                 
                    	id_sel_opB?
	                    	id_imm : id_rfoutB;
	
	// id_fwdstore is passed through ID/EXE pipeline register & is sent to STOREBLOCK
	assign id_fwdstore = (fw_exe_to_id_B && id_is_stype)?
							(exe_sel_data == 3'd4)? exe_DIVout		:
							(exe_sel_data == 3'd2)? exe_imm			: 
							(exe_sel_data == 3'd1)? exe_ALUout 		:
													exe_pc4			:
						 (fw_mem_to_id_B && id_is_stype)?
						 	(mem_sel_data == 3'd4)? mem_DIVout 		:
						 	(mem_sel_data == 3'd3)? mem_loaddata	:
						 	(mem_sel_data == 3'd2)? mem_imm			:
						 	(mem_sel_data == 3'd1)? mem_ALUout		:
						 							mem_pc4			:
						 (fw_wb_to_id_B && id_is_stype)?
						 	wb_wr_data : id_rfoutB;
	
	// Control Unit
	controller1 CONTROL(
		// Inputs
		.opcode(id_opcode),
		.funct3(id_funct3),
		.funct7(id_funct7),

		// Outputs
		.ALU_op(id_base_ALU_op),
		.div_valid(id_div_valid),
		.div_op(id_div_op),
		.sel_opA(id_base_sel_opA),
		.sel_opB(id_base_sel_opB),
		.is_stype(id_base_is_stype),

		.is_jump(id_base_is_jump),
		.is_btype(id_base_is_btype),

		.wr_en(id_base_wr_en),
		.dm_select(id_base_dm_select),
		.imm_select(id_base_imm_select),
		.sel_pc(id_base_sel_pc),
		.sel_data(id_base_sel_data),
		.store_select(id_base_store_select),
		.sel_opBR(id_base_sel_opBR)
	);

	regfile RF(
		.clk(rf_clk),
		.nrst(nrst),

		.wr_en(wb_wr_en),
		.wr_data(wb_wr_data),
		.dest_addr(wb_rd),

		.src1_addr(id_rsA),		.src2_addr(id_rsB),
		.src1_out(id_rfoutA),	.src2_out(id_rfoutB)
	);

	shiftsignshuff SHIFTSIGNSHUFF(
		.imm_select(id_base_imm_select),
		.inst(id_inst[31:7]),
		.imm(id_base_imm)
	);

	// Branch target address computation
	// id_brOP = rfoutA for JALR only
	
	/*
	assign id_brOP = (fw_exe_to_id_A && id_opcode == 7'h67)?(
						(exe_sel_data == 3'd4)? exe_DIVout		:
					 	(exe_sel_data == 3'd2)? exe_imm			:
					 	(exe_sel_data == 3'd1)? exe_ALUout		:
					 							exe_pc4)		:
					 (fw_mem_to_id_A  && id_opcode == 7'h67)?(
					 	(mem_sel_data == 3'd4)? mem_DIVout		: 
						(mem_sel_data == 3'd3)? mem_loaddata 	:
						(mem_sel_data == 3'd2)? mem_imm 		:
						(mem_sel_data == 3'd1)? mem_ALUout		:
												mem_pc4)		:
					 (fw_wb_to_id_A  && id_opcode == 7'h67)? 
					 					wb_wr_data				:
					 (id_sel_opBR)? id_rfoutA : id_PC;
	*/
	assign id_brOP = (id_sel_opBR) ? id_fwdopA : id_PC;
	assign id_branchtarget = id_brOP + (id_is_comp ? (id_sel_opBR ? 32'd0: id_c_jt) : id_base_imm);

    compressed_decoder C_DECODER (
        // Input
        .inst(id_inst[15:0]),
        
        // Type indicator (output)
        .is_compressed(id_is_comp),
        
        // Control signals (output)
        .dm_select(id_c_dm_select),
        .imm_select(id_c_imm_select),
        .sel_data(id_c_sel_data),
        .store_select(id_c_store_select),
        .alu_op(id_c_alu_op),
        .sel_opA(id_c_sel_opA),
        .sel_opB(id_c_sel_opB),
		.sel_opBR(id_c_sel_opBR),
		.sel_pc(id_c_sel_pc),
        .is_stype(id_c_is_stype),
        .wr_en(id_c_wr_en),
		.btype(id_c_btype),
		.use_A(id_c_use_A),
		.use_B(id_c_use_B),
		.is_jump(id_c_is_jump),
		.is_btype(id_c_is_btype),
		.is_nop(id_c_is_nop),
        
        // Results (output)
        .rs1(id_c_rsA),
        .rs2(id_c_rsB),
        .rd(id_c_rd),
        .imm(id_c_imm),
        .jt(id_c_jt)
    );
    
    assign id_dm_select = id_is_comp ? id_c_dm_select : id_base_dm_select; 
    assign id_sel_data = id_is_comp ? id_c_sel_data : id_base_sel_data;
    assign id_store_select = id_is_comp ? id_c_store_select : id_base_store_select;
    assign id_ALU_op = id_is_comp ? id_c_alu_op : id_base_ALU_op;
    assign id_is_stype = id_is_comp ? id_c_is_stype : id_base_is_stype;
    assign id_wr_en = id_is_comp ? id_c_wr_en : id_base_wr_en;
    assign id_imm = id_is_comp ? id_c_imm : id_base_imm;
    assign id_rd = id_is_comp ? id_c_rd : id_base_rd;
    assign id_rsA = id_is_comp ? id_c_rsA: id_base_rsA;
    assign id_rsB = id_is_comp ? id_c_rsB : id_base_rsB;
    assign id_sel_opA = id_is_comp ? id_c_sel_opA : id_base_sel_opA;
    assign id_sel_opB = id_is_comp ? id_c_sel_opB : id_base_sel_opB;
	assign id_sel_opBR = id_is_comp ? id_c_sel_opBR : id_base_sel_opBR;
	assign id_sel_pc = id_is_comp ? id_c_sel_pc : id_base_sel_pc;
	assign id_is_jump = id_is_comp ? id_c_is_jump : id_base_is_jump;
	assign id_is_btype = id_is_comp ? id_c_is_btype : id_base_is_btype;
	assign id_imm_select = id_is_comp ? id_c_imm_select : id_base_imm_select;
	assign id_is_nop = id_is_comp ? id_c_is_nop : (id_inst == 32'h13);
    
	pipereg_id_exe ID_EXE(
		.clk(exe_clk),
		.nrst(nrst),

		.flush(exe_flush),
		.stall(exe_stall),

		.id_pc4(id_pc4),					.exe_pc4(exe_pc4),
		.id_fwdopA(id_fwdopA),				.exe_fwdopA(exe_fwdopA),
		.id_fwdopB(id_fwdopB),				.exe_fwdopB(exe_fwdopB),

		.id_inst(id_inst),					.exe_inst(exe_inst),
		.id_branchtarget(id_branchtarget),	.exe_branchtarget(exe_branchtarget),

		.id_fwdstore(id_fwdstore),			.exe_fwdstore(exe_fwdstore),
		
		.id_imm(id_imm),					.exe_imm(exe_imm),
		.id_rd(id_rd),						.exe_rd(exe_rd),
		.id_PC(id_PC),						.exe_PC(exe_PC),

		// Control signals go here
		.id_ALU_op(id_ALU_op),				.exe_ALU_op(exe_ALU_op),

		.id_c_btype(id_c_btype),			.exe_c_btype(exe_c_btype),
		.id_sel_opBR(id_sel_opBR),			.exe_sel_opBR(exe_sel_opBR),

		// .id_sel_opA(id_sel_opA),				.exe_sel_opA(exe_sel_opA),
		// .id_sel_opB(id_sel_opB),				.exe_sel_opB(exe_sel_opB),
		.id_div_valid(id_div_valid),		.exe_div_valid(exe_div_valid),
		.id_div_op(id_div_op),				.exe_div_op(exe_div_op),
		.id_is_stype(id_is_stype),			.exe_is_stype(exe_is_stype),
		.id_wr_en(id_wr_en),				.exe_wr_en(exe_wr_en),
		.id_dm_select(id_dm_select),		.exe_dm_select(exe_dm_select),
		.id_sel_data(id_sel_data),			.exe_sel_data(exe_sel_data),
		.id_store_select(id_store_select), 	.exe_store_select(exe_store_select),
		.id_comp_use_A(id_c_use_A),			.exe_comp_use_A(exe_comp_use_A),
		.id_comp_use_B(id_c_use_B),			.exe_comp_use_B(exe_comp_use_B),
		.id_is_comp(id_is_comp),			.exe_is_comp(exe_is_comp),
		.id_rs1(id_rsA),					.exe_rs1(exe_rsA),
		.id_rs2(id_rsB),					.exe_rs2(exe_rsB)
	);



// EXE Stage =====================================================================
	// Selecting operands
	assign opA = fw_wb_to_exe_A? wb_loaddata : exe_fwdopA;
	assign opB = (fw_wb_to_exe_B && !exe_is_stype) ? wb_loaddata : exe_fwdopB;

	assign exe_rstore = (fw_wb_to_exe_B && exe_is_stype)? wb_loaddata : exe_fwdstore;

	alu ALU(
		.CLK(CLK_BUF),
		.nrst(nrst),
		.load_hazard(load_hazard),

		.op_a(opA),
		.op_b(opB),
		.ALU_op(exe_ALU_op),

		.res(exe_ALUout),
		.mul_stall(mul_stall),
		.z(exe_z),
		.less(exe_less),
		.signed_less(exe_signed_less)
	);

	// NOTE: 
	divider_unit DIVIDER(
		.CLK(CLK_BUF),
		.nrst(nrst),
		.load_hazard(load_hazard),

		.opA(opA),
		.opB(opB),

		.id_div_valid(id_div_valid),
		.id_div_op_0(id_div_op[0]),
		.exe_div_valid(exe_div_valid),
		.exe_div_op(exe_div_op),

		.div_running(exe_div_running),
		.DIVout(exe_DIVout)
	);

	branchpredictor BHT(
		.CLK(CLK_BUF),
		.nrst(nrst),

		.ISR_running(ISR_running),

		.stall(id_stall),

		.if_PC(if_PC[11:1]),

		.id_PC(id_PC[11:1]),
		.id_branchtarget(id_branchtarget[11:1]),
		.id_is_jump(id_is_jump),
		.id_is_btype(id_is_btype),

		.exe_PC(exe_PC[11:1]),
		.exe_branchtarget(exe_branchtarget[11:1]),
		.exe_sel_opBR(exe_sel_opBR),
		.exe_z(exe_z),
		.exe_less(exe_less),
		.exe_signed_less(exe_signed_less),
		.exe_btype(exe_btype),
		.exe_c_btype(exe_c_btype),
		
		// Outputs
		.if_prediction(if_prediction),
		.exe_correction(exe_correction),
		
		.branch_flush(branch_flush),
		.jump_flush(jump_flush),
		.id_jump_in_bht(id_jump_in_bht),

		.if_PBT(if_PBT),
		.exe_PBT(exe_PBT),
		.exe_CNI(exe_CNI)
	);

	storeblock STOREBLOCK(
		.opB(exe_rstore),
		.byte_offset(exe_ALUout[1:0]),
		.store_select(exe_store_select),
		.is_stype(exe_is_stype),
		.data(exe_storedata),
		.dm_write(exe_dm_write)
	);
	
	pipereg_exe_mem EXE_MEM(
		.clk(mem_clk),
		.nrst(nrst),

		.flush(mem_flush),
		.stall(mem_stall),

		.exe_pc4(exe_pc4),					.mem_pc4(mem_pc4),
		.exe_inst(exe_inst),				.mem_inst(mem_inst),
		.exe_ALUout(exe_ALUout),			.mem_ALUout(mem_ALUout),
		.exe_DIVout(exe_DIVout),			.mem_DIVout(mem_DIVout),
		.exe_storedata(exe_storedata),		.mem_storedata(mem_storedata),
		.exe_imm(exe_imm),					.mem_imm(mem_imm),
		.exe_rd(exe_rd),					.mem_rd(mem_rd),
		.exe_PC(exe_PC),					.mem_PC(mem_PC),

		// Control signals
		.exe_dm_write(exe_dm_write),		.mem_dm_write(mem_dm_write),
		.exe_wr_en(exe_wr_en),				.mem_wr_en(mem_wr_en),
		.exe_dm_select(exe_dm_select),		.mem_dm_select(mem_dm_select),
		.exe_sel_data(exe_sel_data),		.mem_sel_data(mem_sel_data)
	);



// MEM Stage =====================================================================
	datamem DATAMEM(
		.core_clk(mem_clk),
		.con_clk(CLK_BUF),
		.nrst(nrst),

		.dm_write(exe_dm_write),
		.exe_data_addr(exe_ALUout[12:2]),
		.mem_data_addr(mem_ALUout[12:2]),
		.data_in(exe_storedata),

		// .BTN(BTN),
		// .SW(SW),
		// .LED(LED),

		.con_write(con_write),
		.con_addr(con_addr),
		.con_in(con_in),

		.data_out(mem_DATAMEMout),
		.con_out(con_out)
	);

	loadblock LOADBLOCK(
		.data(mem_DATAMEMout),
		.byte_offset(mem_ALUout[1:0]),
		.dm_select(mem_dm_select),
		.loaddata(mem_loaddata)
	);

	pipereg_mem_wb MEM_WB(
		.clk(wb_clk),
		.nrst(nrst),

		.flush(wb_flush),
		.stall(wb_stall),

		.mem_pc4(mem_pc4),					.wb_pc4(wb_pc4),
		.mem_inst(mem_inst),				.wb_inst(wb_inst),
		.mem_ALUout(mem_ALUout),			.wb_ALUout(wb_ALUout),
		.mem_DIVout(mem_DIVout),			.wb_DIVout(wb_DIVout),
		.mem_loaddata(mem_loaddata),		.wb_loaddata(wb_loaddata),
		.mem_imm(mem_imm),					.wb_imm(wb_imm),
		.mem_rd(mem_rd),					.wb_rd(wb_rd),
		.mem_PC(mem_PC),					.wb_PC(wb_PC),

		// Control signals
		.mem_wr_en(mem_wr_en),				.wb_wr_en(wb_wr_en),
		.mem_sel_data(mem_sel_data),		.wb_sel_data(wb_sel_data)
	);



// WB Stage ======================================================================
	// Selector MUX
	assign wb_wr_data = (wb_sel_data == 3'd0) ? wb_pc4 : 
						(wb_sel_data == 3'd1) ? wb_ALUout : 
						(wb_sel_data == 3'd2) ? wb_imm :
						(wb_sel_data == 3'd4) ? wb_DIVout :
						wb_loaddata;



endmodule