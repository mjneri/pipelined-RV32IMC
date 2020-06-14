//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// controller1.v -- RISCV 32bit Instructions decoder
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Author: Microlab 198 Pipelined RISC-V Group (2SAY1920)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Module Name: controller1.v
// Description: This module implements the decoder that translates 32bit instructions into
//              their corresponding control signals.
//
// Revisions:
// Revision 0.01 - File Created
// Additional Comments:
// 
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=


`timescale 1ns / 1ps
`include "constants.vh"

module controller1(
    // Input from 32bit instruction
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,

    output [3:0] ALU_op,        // Input to ALU
    output div_valid,			// Input to Divider unit (based on tvalid input of Divider IP Module)
    output [1:0] div_op,		// Input to Divider unit
    output sel_opA,             // Input to opA selection mux
    output sel_opB,             // Input to opB selection mux
    output is_stype,            // Input to STOREBLOCK

    output is_jump,             // Input to BHT
    output is_btype,            // Input to BHT

    output wr_en,               // Input to regfile
    output [2:0] dm_select,     // Input to LOADBLOCK
    output [2:0] imm_select,    // Input to SHIFTSIGNSHUFF block
    output sel_pc,				// Input to PC selection MUX
    output [2:0] sel_data,      // Input to WB data selection MUX
    output [1:0] store_select,  // Input to STOREBLOCK
    output sel_opBR             // Input to Branch target computation MUX
);
    
    ///////////////////////////////////////////////////////////////////////
    // Legend of Opcodes                                                 //
    // U-type Instructions - LUI (7'h37), AUIPC (7'h17)                  //
    // J-type Instructions - JAL (7'h6F), JALR (7'h67)                   //
    // B-type Instructions (7'h63) - BEQ, BNE, BLT, BGE, BLTU, BGEU      //
    // I-type Instructions [Load] (7'h3) - LB, LH, LW, LBU, LHU          //
    // S-type Instructions (7'h23) - SB, SH, SW                          //
    // I-type Instructions [Operations] (7'h13)                          //
    // R-type Instructions [Operations] (7'h33)                          //
    ///////////////////////////////////////////////////////////////////////
    
    assign sel_opA = (opcode == `OPC_AUIPC) ? 1'h0 : 1'h1;  
    //sel_opA = 0 if inst is AUIPC
    // 0: select PC as operand
    // 1: select rfoutA as operand

    assign sel_opB = (opcode == `OPC_RTYPE || opcode == `OPC_BTYPE) ? 1'h0 : 1'h1;  
    //sel_opB = 0 if R-type inst or B-type inst
    // 0: rfoutB
    // 1: imm

    assign is_stype = !(opcode == `OPC_STYPE) ? 1'h0 : 1'h1;

    assign is_btype = (opcode == `OPC_BTYPE)? 1'h1 : 1'h0;

    assign is_jump = (opcode == `OPC_JAL || opcode == `OPC_JALR)? 1'h1 : 1'h0;

    assign wr_en = !(opcode == `OPC_STYPE || opcode == `OPC_BTYPE) ? 1'h1 : 1'h0;

    assign dm_select = funct3;

    assign imm_select = (opcode == `OPC_JAL) ? 3'h4 : 
                        (opcode == `OPC_BTYPE) ? 3'h3 : 
                        (opcode == `OPC_LUI || opcode == `OPC_AUIPC) ? 3'h2 : 
                        (opcode == `OPC_STYPE) ? 3'h1 : 3'h0;
    //imm_select:
    // 0 if I-type inst (operations except shift + load)
    // 1 if S-type inst
    // 2 if U-type inst
    // 3 if B-type inst
    // 4 if JAL

    assign sel_pc = (opcode == `OPC_JAL || opcode == `OPC_JALR) ? 1'h1 : 1'h0;
    //sel_pc:
    // 1 if JAL/JALR
    // 0 if R-type, I-type, S-type, U-type inst (PC+4)

    assign sel_data = (opcode == `OPC_JAL || opcode == `OPC_JALR) ? 3'h0 : 
					  (opcode == `OPC_LUI) ? 3'h2 : 
					  (opcode == `OPC_LOAD) ? 3'h3 :
					  (opcode == `OPC_RTYPE && funct7 == 7'h1 && funct3[2] == 1)? 3'h4 :
					  3'h1;
    //sel_data
    // 0 if J-type inst (select PC+4)
    // 1 if R-type, I-type arithmetic, AUIPC (select ALUout)
    // 2 if LUI (select Immediate)
    // 3 if I-type inst [load] (select Loaddata)
    // 4 if DIV[U]/REM[U] (select DIVout)

    assign store_select = (opcode == `OPC_STYPE && funct3 == 3'h0) ? 2'h0 : 
    					  (opcode == `OPC_STYPE && funct3 == 3'h1) ? 2'h1 : 2'h2; 
    //store_select
    // 0 if SB
    // 1 if SH
    // 2 if SW

    assign ALU_op = (opcode == `OPC_RTYPE && funct3 == 3'h0 && funct7 == 7'h20)?								`ALU_SUB	: 
                    (funct3 == 3'h7 && (opcode == `OPC_RTYPE || opcode == `OPC_ITYPE))? 						`ALU_AND	: 
                    (funct3 == 3'h6 && (opcode == `OPC_RTYPE || opcode == `OPC_ITYPE))? 						`ALU_OR		: 
                    (funct3 == 3'h4 && (opcode == `OPC_RTYPE || opcode == `OPC_ITYPE))? 						`ALU_XOR	: 
                    (funct3 == 3'h2 && ((opcode == `OPC_RTYPE && funct7 == 7'h0) || (opcode == `OPC_ITYPE)))? 	`ALU_SLT	: 
                    (funct3 == 3'h3 && ((opcode == `OPC_RTYPE && funct7 == 7'h0) || (opcode == `OPC_ITYPE)))? 	`ALU_SLTU	: 
                    (funct3 == 3'h1 && ((opcode == `OPC_RTYPE && funct7 == 7'h0) || (opcode == `OPC_ITYPE)))? 	`ALU_SLL	:
                    (funct3 == 3'h5 && funct7 == 7'h0 && (opcode == `OPC_RTYPE || opcode == `OPC_ITYPE))? 		`ALU_SRL	:  
                    (funct3 == 3'h5 && funct7 == 7'h20 && (opcode == `OPC_RTYPE || opcode == `OPC_ITYPE))? 		`ALU_SRA	:

                    (funct3 == 3'h0 && funct7 == 7'h1 && opcode == `OPC_RTYPE)? `ALU_MUL	:
                    (funct3 == 3'h1 && funct7 == 7'h1 && opcode == `OPC_RTYPE)? `ALU_MULH	:
                    (funct3 == 3'h2 && funct7 == 7'h1 && opcode == `OPC_RTYPE)? `ALU_MULHSU	:
                    (funct3 == 3'h3 && funct7 == 7'h1 && opcode == `OPC_RTYPE)? `ALU_MULHU	:
                    4'h1;
    //ALU_op
    // 1 if ADD (R-type), ADDI (I-type), I-type [load], S-type
    // 2 if SUB (R-type)
    // 3 if AND, ANDI
    // 4 if OR, ORI
    // 5 if XOR, XORI
    // 6 if SLT, SLTI
    // 7 if SLTU, SLTUI
    // 8 if SLL, SLLI
    // 9 if SRL, SRLI
    // 10 if SRA, SRAI
    
    // 11 if MUL
    // 12 if MULH
    // 13 if MULHSU
    // 14 if MULHU

    assign div_op = (funct3 == 3'h4 && funct7 == 7'h1 && opcode == `OPC_RTYPE)? 2'd0	:
    				(funct3 == 3'h5 && funct7 == 7'h1 && opcode == `OPC_RTYPE)? 2'd1	:
    				(funct3 == 3'h6 && funct7 == 7'h1 && opcode == `OPC_RTYPE)? 2'd2	:
    				2'd3;
    // div_op
    // 0 if DIV, 1 if DIVU, 2 if REM, 3 (REMU) by 'default'

    assign div_valid = ((funct3 == 3'h4 || funct3 == 3'h5 || funct3 == 3'h6 || funct3 == 3'h7) && funct7 == 7'h1 && opcode == `OPC_RTYPE);
    // div_valid
    // assert if the instruction is DIV[U]/REM[U]

    assign sel_opBR = (opcode == `OPC_JALR)? 1'h1 : 1'h0;   // if jalr, select rfoutA, else select PC
    
endmodule
