`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/19/2020 06:16:48 PM
// Design Name: 
// Module Name: controller1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module controller1(
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,

    // Z and less would most likely be taken as an input by the BHT
    //input z,
    //input less,

    output [3:0] ALU_op,
    output sel_opA,
    output sel_opB,
    output is_stype,
    output wr_en,
    output [2:0] dm_select,
    output [2:0] imm_select,
    //output [1:0] sel_pc,
    output [1:0] sel_data,
    output [1:0] store_select
    //output mask
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
    
    parameter lui_inst = 7'h37;
    parameter auipc_inst = 7'h17;
    parameter jal_inst = 7'h6F;
    parameter jalr_inst = 7'h67;
    parameter b_type = 7'h63;
    parameter i_type = 7'h13;
    parameter s_type = 7'h23;
    parameter r_type = 7'h33;
    parameter load_inst = 7'h3;
    
    // Comment out later once branch prediction is being implemented
    //assign b_taken = (opcode == b_type && funct3 == 3'h0 && z) || (opcode == b_type && funct3 == 3'h1 && !z) || (opcode == b_type && funct3 == 3'h4 && less) || (opcode == b_type && funct3 == 3'h5 && !less) || (opcode == b_type && funct3 == 3'h6 && less) || (opcode == b_type && funct3 == 3'h7 && !less);
    
    //assign output_element condition ? value_if_true : value_if_false;
    assign sel_opA = (opcode == auipc_inst || opcode == jal_inst) ? 1'h0 : 1'h1;  //sel_opA = 0 if inst is AUIPC or JAL
    assign sel_opB = (opcode == r_type || opcode == b_type) ? 1'h0 : 1'h1;  //sel_opB = 0 if R-type inst or B-type inst
    assign is_stype = !(opcode == s_type) ? 1'h0 : 1'h1;    //dm_write = 1 if S-type inst
    assign wr_en = !(opcode == s_type || opcode == b_type) ? 1'h1 : 1'h0;
    assign dm_select = funct3;
    assign imm_select = (opcode == jal_inst || opcode == jalr_inst) ? 3'h4 : (opcode == b_type) ? 3'h3 : (opcode == lui_inst || opcode == auipc_inst) ? 3'h2 : (opcode == s_type) ? 3'h1 : 3'h0;
    //imm_select:
    // 0 if I-type inst (operations except shift + load)
    // 1 if S-type inst
    // 2 if U-type inst
    // 3 if B-type inst
    // 4 if J-type inst

    //assign sel_pc = 1;//(opcode == jal_inst || opcode == jalr_inst) ? 2'h0 : (opcode == b_type && b_taken) ? 2'h1 : 2'h2;
    //sel_pc:
    // 0 if J-type inst
    // 1 if B-type inst AND branch taken
    // 2 if R-type, I-type, S-type, U-type inst

    assign sel_data = (opcode == jal_inst || opcode == jalr_inst) ? 2'h0 : (opcode == lui_inst) ? 2'h2 : (opcode == load_inst) ? 2'h3 : 2'h1;
    //sel_data
    // 0 if J-type inst
    // 1 if R-type, I-type [operations], AUIPC
    // 2 if LUI
    // 3 if I-type inst [load]

    assign store_select = (opcode == s_type && funct3 == 3'h0) ? 2'h0 : (opcode == s_type && funct3 == 3'h1) ? 2'h1 : 2'h2; 
    //store_select
    // 0 if SB
    // 1 if SH
    // 2 if SW

    assign ALU_op = ((opcode == b_type) || (opcode == r_type && funct3 == 3'h0 && funct7 == 7'h20)) ? 4'h2 : (funct3 == 3'h7 && (opcode == r_type || opcode == i_type)) ? 4'h3 : (funct3 == 3'h6 && (opcode == r_type || opcode == i_type)) ? 4'h4 : (funct3 == 3'h4 && (opcode == r_type || opcode == i_type)) ? 4'h5 : (funct3 == 3'h2 && (opcode == r_type || opcode == i_type)) ? 4'h6 : (funct3 == 3'h3 && (opcode == r_type || opcode == i_type)) ? 4'h7 : (funct3 == 3'h1 && (opcode == r_type || opcode == i_type)) ? 4'h8 : (funct3 == 3'h5 && funct7 == 7'h0 && (opcode == r_type || opcode == i_type)) ? 4'h9 :  (funct3 == 3'h5 && funct7 == 7'h20 && (opcode == r_type || opcode == i_type)) ? 4'hA : 4'h1;
    //ALU_op
    // 1 if ADD (R-type), ADDI (I-type), I-type [load], S-type
    // 2 if SUB (R-type), B-type
    // 3 if AND, ANDI
    // 4 if OR, ORI
    // 5 if XOR, XORI
    // 6 if SLT, SLTI
    // 7 if SLTU, SLTUI
    // 8 if SLL, SLLI
    // 9 if SRL, SRLI
    // 10 if SRA, SRAI
    
endmodule
