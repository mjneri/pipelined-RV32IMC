`timescale 1ns / 1ps
/*

    Compressed Instruction Decoder

    This module implements the decoder that translates compressed instructions into
    their corresponding control signals and register/immediate data.

*/

module compressed_decoder(
    input clk,
    input nrst,
    input [15:0] inst,
    output is_compressed,
    output [2:0] dm_select,
    output [2:0] imm_select,
    output [1:0] sel_data,
    output [1:0] store_select,
    output [4:0] rs1,
    output [4:0] rs2,
    output [4:0] rd,
    output [15:0] imm,
    output [19:0] jt
    );

    // instruction encoding
    wire [1:0] opcode = inst[1:0];                        // opcode used by all instructions
    wire [2:0] funct3 = inst[15:13];                      // function code used by most instructions except for the following:
    wire [3:0] funct4 = inst[15:12];                      // function code used by CR-type instructions
    wire [5:0] funct6 = inst[15:10];                      // function code used by CA-type instructions
    wire [1:0] funct2 = inst[6:5];                        // function code used by CA-type instructions
    wire [4:0] rd7 = inst[11:7];                          // full (5-bit) register addressing used by CR-type instructions
    wire [4:0] rs2 = inst[6:2];                           // full register addressing used by CI- and CR-type instructions
    wire [2:0] rs1_eff = inst[9:7];                       // abdridged register used by CL-, CS-, CA-, and CB-type instructions
    wire [2:0] rs2_eff = inst[4:2];                       // abdridged register used by CL-, CS-, CA-, and CIW-type instructions
    /*
    wire [5:0] imm_css = inst[12:7];                      // immediate argument used by CSS-type instructions 
    wire [7:0] imm_iw = inst[12:5];                       // target offset used by CIW-type instructions 
    wire [4:0] imm_cc = {inst[12:10], inst[6:5]};         // immediate argument used by CL- and CS-type instructions 
    wire [6:0] imm_bo = {inst[12:10]. inst[6:2]};         // branch target offset used by CB-type instructions     
    wire [10:0] imm_jt = inst[12:2];                       // jump target offset used by CJ-type instructions 
    */

    // decoding logic
    wire not_funct3 = (funct3 == 3'b100);

    // immediates
    wire [11:0] imm_jt = {inst[12], inst[8], inst[10:9], inst[6], inst[7], inst[2], inst[11], inst[5:3], 1'b0};
    wire [16:0] imm_nzuimm = {11'b0, inst[12], inst[6:2]};
    wire [16:0] imm_imm = {11{inst[12]}, inst[12], inst[6:2]};
    

    

    
    // outputs
    
    assign is_compressed = !(opcode == 2'b11);

    

endmodule