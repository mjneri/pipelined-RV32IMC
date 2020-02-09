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
    output [31:0] imm,
    output [19:0] jt
    );

    // instruction encoding
    wire [1:0] opcode = inst[1:0];                        // opcode used by all instructions
    wire [2:0] funct3 = inst[15:13];                      // function code used by most instructions except for the following:
    wire funct4 = inst[12];                               // function code used by CA-type instructions
    wire [1:0] funct2 = inst[11:10];                      // function code used by CA-type instructions
    wire [1:0] funct2_lo = inst[6:5];                     // function code used by CA-type instructions

    wire [4:0] rd7 = inst[11:7];                          // full (5-bit) register addressing used by CR-type instructions
    wire [4:0] rs2 = inst[6:2];                           // full register addressing used by CI- and CR-type instructions
    wire [2:0] rs1_abb = inst[9:7];                       // abdridged register used by CL-, CS-, CA-, and CB-type instructions
    wire [2:0] rs2_abb = inst[4:2];                       // abdridged register used by CL-, CS-, CA-, and CIW-type instructions


    // decoding logic
    wire quad_0 = (opcode == 2'd0);
    wire quad_1 = (opcode == 2'd1);
    wire quad_2 = (opcode == 2'd2);
    wire not_func3 = (funct3 == 3'd4);

    wire [5:0] rs1_eff = {2'b01, rs1_abb};
    wire [5:0] rs2_eff = {2'b01, rs2_abb};
    
    // facilitators
    reg [5:0] temp_rs1;
    reg [5:0] temp_rs2;
    reg [5:0] temp_rd;
    reg i_type;
    reg j_type;
    reg jr_type;
    reg b_type;
    reg r_type;
    reg u_type;
    reg ebreak_type;
    reg load_inst;
    reg store_inst;

    // instruction decodes
    always@(*) begin
        // default values

        // logic
        case(opcode) begin
            2'd0: begin
                case(funct3)
                    3'd0: begin
                        // ADDI4SPN -> expands to addi rd', x2, <nzimm[9:2]>
                        temp_rd = rs2_eff;
                        temp_rs1 = 5'd2;
                        i_type = 1'b1;
                    end
                    3'd2: begin
                        // LW -> expands to LW rd', (<imm[6:2]>)rs1'
                        temp_rd = rs2_eff;
                        temp_rs1 = rs1_eff;
                        load_inst = 1'b1;
                    end
                    3'd6: begin
                        // SW -> expands to SW rd', (<imm[6:2]>)rs1'
                        temp_rd = rs2_eff;
                        temp_rs1 = rs1_eff;
                        store_inst = 1'b1;
                    end
                    default: begin
                        
                    end
                endcase
            end
            2'd1: begin
                case(funct3)
                    3'd0: begin
                        // ADDI/NOP 
                        temp_rd = rd7;
                        temp_rs1 = rd7;
                        i_type = 1'b1;
                    end
                    3'd1: begin
                        // JAL -> expands to jal x1, <offset>
                        temp_rd = 5'd1;
                        j_type = 1'b1;
                    end
                    3'd2: begin
                        // LI -> expands to addi rd, x0, <imm[5:0]>
                        temp_rd = rd7;
                        temp_rs1 = 5'd0;
                        i_type = 1'b1;
                    end
                    3'd3: begin
                        // LUI
                        if (rd7 != 5'd2) begin
                            temp_rd = rd7;
                            temp_rs1 = 5'd0;
                            u_type = 1'b1;
                        end
                        // ADDI16SP
                        else begin
                            temp_rd = 5'd2;
                            temp_rs1 = 5'd2;
                            i_type = 1'b1;
                        end
                    end
                    3'd4: begin
                        case(funct2)
                            2'd0: begin
                                // SRLI
                                temp_rd = rs1_eff;
                                temp_rs1 = rs1_eff;
                                i_type = 1'b1;
                            end
                            2'd1: begin
                                // SRAI
                                temp_rd = rs1_eff;
                                temp_rs1 = rs1_eff;
                                i_type = 1'b1;
                            end
                            2'd2: begin
                                // ANDI
                                temp_rd = rs1_eff;
                                temp_rs1 = rs1_eff;
                                i_type = 1'b1;
                            end
                            2'd3: begin
                                if (!funct4) begin
                                    case(funct2_lo)
                                        r_type = 1'b1;
                                        temp_rd = rs1_eff;
                                        temp_rs1 = rs1_eff;
                                        temp_rs2 = rs2_eff;
                                        // SUB
                                        2'd0: 
                                            //opcode
                                        // XOR
                                        2'd1:
                                            //opcode
                                        // OR
                                        2'd2:
                                            //opcode
                                        // AND
                                        2'd3:
                                            //opcode
                                    endcase
                                end
                            end
                        endcase
                    end
                    3'd5: begin
                        // J -> expands to jal x0, <offset>
                        temp_rd = 5'd0;
                        j_type = 1'b1;
                    end
                    3'd6: begin
                        // BEQZ
                        temp_rs1 = rs1_eff;
                        temp_rs2 = 5'd0;
                        b_type = 1'b1;
                    end
                    3'd7: begin
                        // BNEZ
                        temp_rs1 = rs1_eff;
                        temp_rs2 = 5'd0;
                        b_type = 1'b1;
                    end
                endcase
            end
            2'd2: begin
                case(funct3)
                    3'd0: begin
                        // SLLI
                        temp_rd = rd7;
                        temp_rs1 = rd7;
                        i_type = 1'b1;
                    end
                    3'd2: begin
                        // LWSP > expands to lw rd, (<nzimm[7:2]>)x2
                        temp_rd = rd7;
                        temp_rs1 = 5'd2;
                        load_inst = 1'b1;
                    end
                    3'd6: begin
                        // SWSP
                        temp_rd = rd7;
                        temp_rs1 = 5'd2;
                        store_inst = 1'b1;
                    end
                    3'd4: begin
                        if (funct4) begin
                            if (rs2 == 5'd0) begin
                                if (rd7 == 5'd0) begin
                                    // EBREAK
                                    ebreak_type = 1'b1;
                                end
                                else begin
                                    // JALR -> expands to jalr x1, 0(rs1)
                                    jr_type = 1'b1;
                                    temp_rs1 = rd7;
                                    temp_rd = 5'd1;
                                end
                            end
                            else begin
                                // ADD
                                temp_rd = rd7;
                                temp_rs1 = rd7;
                                temp_rs2 = rs2;
                                r_type = 1'b1;
                            end
                        end
                        else begin
                            if (rs2 == 5'd0) begin
                                // JR -> expands to jalr x0, 0(rs1)
                                jr_type = 1'b1;
                                temp_rs1 = rd7;
                                temp_rd = 5'd0;
                            end
                            else begin
                                // MV
                                temp_rd = rd7;
                                temp_rs1 = rd7;
                                temp_rs2 = 5'd0;
                                r_type = 1'b1;
                            end
                        end
                    end
                    default: begin

                    end
                endcase
            end
            default: begin
                // regular instruction
            end
        end
    end

    // control signals









    // immediates

    /* Immediate table

    =================================================================
    |   immediate type  |12 |11 |10 | 9 | 8 | 7 | 6 | 5 | 4 | 3 | 2 | bits
    =================================================================
    |     jump_imm      |11 | 4 | 9 | 8 |10 | 6 | 7 | 3 | 2 | 1 | 5 |
    |    branch_imm     | 8 | 4 | 3 | x | x | x | 7 | 6 | 2 | 1 | 5 |
    |     ls_uimm       | 5 | 4 | 3 | x | x | x | 2 | 6 | x | x | x |
    |    lwsp_uimm      | 5 | x | x | x | x | x | 4 | 3 | 2 | 7 | 6 |
    |    swsp_uimm      | 5 | 4 | 3 | 8 | 7 | 6 | x | x | x | x | x |
    |      nzimm        | 5 | x | x | x | x | x | 4 | 3 | 2 | 1 | 0 |
    |       imm         | 5 | x | x | x | x | x | 4 | 3 | 2 | 1 | 0 |
    |      nzuimm       | 5 | x | x | x | x | x | 4 | 3 | 2 | 1 | 0 |
    |    lui_nzuimm     |17 | x | x | x | x | x |16 |15 |14 |13 |12 |
    |   addsp_nzuimm    | 9 | x | x | x | x | x | 4 | 6 | 8 | 7 | 5 |
    =================================================================

    */
    wire sign = 1'b1; // sign logic
    
    

    

    
    // outputs
    
    assign is_compressed = !(opcode == 2'b11);

    

endmodule