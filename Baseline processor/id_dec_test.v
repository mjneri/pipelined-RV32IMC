`timescale 1ns / 1ps
`include "controller1.v"
`include "shiftsignshuff.v"

module id_dec (
    input [31:0] inst,
	output [4:0] id_rsA, id_rsB,			// source registers
	output [4:0] id_rd,					// destination register
    output [3:0] id_ALU_op,			// For EXE stage 	/
	output id_sel_opA, id_sel_opB,	// For EXE stage 	/ 
	output id_is_stype,				// For EXE stage 	/
	output id_wr_en,					// For WB stage 	/
	output [2:0] id_dm_select,		// For MEM stage 	/
	output [2:0] id_imm_select,		// For ID stage 	/
	output [1:0] id_sel_data,			// For WB stage 	/
	output [1:0] id_store_select,		// For EXE stage 	/
    output [31:0] id_imm
);

// ID Stage ========================================================
	// Outputs of IF/ID Pipeline Register
	wire [11:0] id_pc4;			// PC + 4
	wire [31:0] id_inst;		// 32bit Instruction
	wire [11:0] id_PC;			// PC

	// 32-bit instruction parts
    
	wire [6:0] id_opcode;				// opcode
	wire [2:0] id_funct3;				// funct3
	wire [6:0] id_funct7;				// funct7
	wire [4:0] id_rsA, id_rsB;			// source registers
	wire [4:0] id_rd;					// destination register
	assign id_opcode = inst[6:0];
	assign id_funct3 = inst[14:12];
	assign id_funct7 = inst[31:25];
	assign id_rsA = inst[19:15];
	assign id_rsB = inst[24:20];
	assign id_rd = inst[11:7];

	// Control signals //////////////////////////////////
    /*
	wire [3:0] id_ALU_op;			// For EXE stage 	/
	wire id_sel_opA, id_sel_opB;	// For EXE stage 	/ 
	wire id_is_stype;				// For EXE stage 	/
	wire id_wr_en;					// For WB stage 	/
	wire [2:0] id_dm_select;		// For MEM stage 	/
	wire [2:0] id_imm_select;		// For ID stage 	/
	wire [1:0] id_sel_data;			// For WB stage 	/
	wire [1:0] id_store_select;		// For EXE stage 	/
    */
	/////////////////////////////////////////////////////

	// Inputs to ID/EXE Pipereg 														
	wire [31:0] id_rfoutA, id_rfoutB;	// Regfile outputs 								
	wire [31:0] id_imm;					// Output of SHIFT, SIGN EXT, AND SHUFFLE block 

	wire [31:0] id_opA;
	wire [31:0] id_opB;

    controller1 CONTROL(
		// Inputs
		.opcode(id_opcode),
		.funct3(id_funct3),
		.funct7(id_funct7),

		// Outputs
		.ALU_op(id_ALU_op),
		.sel_opA(id_sel_opA),
		.sel_opB(id_sel_opB),
		.is_stype(id_is_stype),
		.wr_en(id_wr_en),
		.dm_select(id_dm_select),
		.imm_select(id_imm_select),
		.sel_data(id_sel_data),
		.store_select(id_store_select)
	);

    shiftsignshuff SHIFTSIGNSHUFF(
		.imm_select(id_imm_select),
		.inst(inst[31:7]),
		.imm(id_imm)
	);
endmodule