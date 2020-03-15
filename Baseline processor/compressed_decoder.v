`timescale 1ns / 1ps
/*

    Compressed Instruction Decoder

    This module implements the decoder that translates compressed instructions into
    their corresponding control signals and register/immediate data.

*/

module compressed_decoder(
    // inputs
    input [15:0] inst,

    // type indicator
    output is_compressed,

    // control signals
    output [2:0] dm_select,
    output [2:0] imm_select,
    output [2:0] sel_data,
    output [1:0] store_select,
    output [3:0] alu_op,
    output sel_opA,
    output sel_opB,
    output sel_opBR,
    output sel_pc,
    output is_stype,
    output wr_en,
    output [1:0] btype,
    output use_A,
    output use_B,
    output is_jump,
    output is_btype,

    // results
    output [4:0] rs1,
    output [4:0] rs2,
    output [4:0] rd,
    output [31:0] imm,
    output [31:0] jt
    );

    // instruction encoding
    wire [1:0] opcode = inst[1:0];                        // opcode used by all instructions
    wire [2:0] funct3 = inst[15:13];                      // function code used by most instructions except for the following:
    wire funct4 = inst[12];                               // function code used by CA-type instructions
    wire [1:0] funct2 = inst[11:10];                      // function code used by CA-type instructions
    wire [1:0] funct2_lo = inst[6:5];                     // function code used by CA-type instructions

    wire [4:0] rd7 = inst[11:7];                          // full (5-bit) register addressing used by CR-type instructions
    wire [4:0] rs2_full = inst[6:2];                           // full register addressing used by CI- and CR-type instructions
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
    reg [3:0] temp_op;
    reg i_type;
    reg j_type;
    reg jr_type;
    reg b_type;
    reg r_type;
    reg lui_type;
    reg ebreak_type;
    reg load_inst;
    reg store_inst;

    reg spn_imm;
    reg sp_imm;
    reg lssp_imm;
    reg unsigned_imm;

    // instruction decodes
    always@(*) begin
        // default values
        temp_rs1 = 5'd0;
        temp_rs2 = 5'd0;
        temp_rd = 5'd0;
        temp_op = 4'd1;
        i_type = 1'b0;
        j_type = 1'b0;
        jr_type = 1'b0;
        r_type = 1'b0;
        lui_type = 1'b0;
        ebreak_type = 1'b0;
        load_inst = 1'b0;
        store_inst = 1'b0;
        sp_imm = 1'b0;
        spn_imm = 1'b0;
        lssp_imm = 1'b0;
        unsigned_imm = 1'b0;
        b_type = 1'b0;

        // logic
        case(opcode)
            2'd0: begin
                case(funct3)
                    3'd0: begin
                        // ADDI4SPN -> expands to addi rd', x2, <nzimm[9:2]>
                        temp_rd = rs2_eff;
                        temp_rs1 = 5'd2;
                        i_type = 1'b1;
                        temp_op = 4'd1;
                        spn_imm = 1'b1;
                        unsigned_imm = 1'b1;
                    end
                    3'd2: begin
                        // LW -> expands to LW rd', (<imm[6:2]>)rs1'
                        temp_rd = rs2_eff;
                        temp_rs1 = rs1_eff;
                        load_inst = 1'b1;
                        temp_op = 4'd1;
                        unsigned_imm = 1'b1;
                    end
                    3'd6: begin
                        // SW -> expands to SW rd', (<imm[6:2]>)rs1'
                        temp_rs2 = rs2_eff;
                        temp_rs1 = rs1_eff;
                        store_inst = 1'b1;
                        temp_op = 4'd1;
                        unsigned_imm = 1'b1;
                    end
                    // other cases: non-implemented instructions
                endcase
            end
            2'd1: begin
                case(funct3)
                    3'd0: begin
                        // ADDI/NOP 
                        temp_rd = rd7;
                        temp_rs1 = rd7;
                        i_type = 1'b1;
                        temp_op = 4'd1;
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
                        temp_op = 4'd1;
                    end
                    3'd3: begin
                        // LUI
                        if (rd7 != 5'd2) begin
                            temp_rd = rd7;
                            temp_rs1 = 5'd0;
                            lui_type = 1'b1;
                        end
                        // ADDI16SP
                        else begin
                            temp_rd = 5'd2;
                            temp_rs1 = 5'd2;
                            i_type = 1'b1;
                            temp_op = 4'd1;
                            sp_imm = 1'b1;
                        end
                    end
                    3'd4: begin
                        case(funct2)
                            2'd0: begin
                                // SRLI
                                temp_rd = rs1_eff;
                                temp_rs1 = rs1_eff;
                                i_type = 1'b1;
                                temp_op = 4'd9;
                                unsigned_imm = 1'b1;
                            end
                            2'd1: begin
                                // SRAI
                                temp_rd = rs1_eff;
                                temp_rs1 = rs1_eff;
                                i_type = 1'b1;
                                temp_op = 4'd10;
                                unsigned_imm = 1'b1;
                            end
                            2'd2: begin
                                // ANDI
                                temp_rd = rs1_eff;
                                temp_rs1 = rs1_eff;
                                i_type = 1'b1;
                                temp_op = 4'd3;
                            end
                            2'd3: begin
                                if (!funct4) begin
                                    r_type = 1'b1;
                                    temp_rd = rs1_eff;
                                    temp_rs1 = rs1_eff;
                                    temp_rs2 = rs2_eff;
                                    case(funct2_lo)
                                        // SUB
                                        2'd0: 
                                            temp_op = 4'd2;
                                        // XOR
                                        2'd1:
                                            temp_op = 4'd5;
                                        // OR
                                        2'd2:
                                            temp_op = 4'd4;
                                        // AND
                                        2'd3:
                                            temp_op = 4'd3;
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
                        temp_op = 4'd2;
                    end
                    3'd7: begin
                        // BNEZ
                        temp_rs1 = rs1_eff;
                        temp_rs2 = 5'd0;
                        b_type = 1'b1;
                        temp_op = 4'd2;
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
                        temp_op = 4'd8;
                    end
                    3'd2: begin
                        // LWSP > expands to lw rd, (<nzimm[7:2]>)x2
                        temp_rd = rd7;
                        temp_rs1 = 5'd2;
                        load_inst = 1'b1;
                        temp_op = 4'd1;
                        lssp_imm = 1'b1;
                        unsigned_imm = 1'b1;
                    end
                    3'd6: begin
                        // SWSP
                        temp_rs2 = rs2_full;
                        temp_rs1 = 5'd2;
                        store_inst = 1'b1;
                        temp_op = 4'd1;
                        lssp_imm = 1'b1;
                        unsigned_imm = 1'b1;
                    end
                    3'd4: begin
                        if (funct4) begin
                            if (rs2_full == 5'd0) begin
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
                                temp_rs2 = rs2_full;
                                r_type = 1'b1;
                                temp_op = 4'd1;
                            end
                        end
                        else begin
                            if (rs2_full == 5'd0) begin
                                // JR -> expands to jalr x0, 0(rs1)
                                jr_type = 1'b1;
                                temp_rs1 = rd7;
                                temp_rd = 5'd0;
                            end
                            else begin
                                // MV
                                temp_rd = rd7;
                                temp_rs1 = 5'd0;
                                temp_rs2 = rs2_full;
                                r_type = 1'b1;
                                temp_op = 4'd1;
                            end
                        end
                    end
                    // other cases: non-implemented instructions
                endcase
            end
            
            // 2'd3: regular instruction
            // default values only
            
        endcase
    end

    // control signals

    assign store_select = (store_inst) ? 2'h2 : 2'h0;
    assign dm_select = (load_inst) ? 2'h2 : 2'h0;
    assign sel_opA = (lui_type || j_type) ? 1'b0 : 1'b1;
    assign sel_opB = (r_type || b_type) ? 1'h0 : 1'h1;          //sel_opB = 0 if R-type inst or B-type inst
    assign wr_en = !(store_inst || b_type || inst==16'd0);
    assign imm_select = (j_type) ? 3'h4 : (b_type) ? 3'h3 : (lui_type) ? 3'h2 : (store_inst) ? 3'h1 : 3'h0;
    assign sel_data = (j_type || jr_type) ? 3'h0 : (lui_type) ? 3'h2 : (load_inst) ? 3'h3 : 3'h1;
    assign alu_op = temp_op;
    assign rs1 = temp_rs1;
    assign rs2 = temp_rs2;
    assign rd = temp_rd;
    assign is_stype = store_inst;
    assign is_jump = (jr_type || j_type);
    assign is_btype = b_type;
    // immediates

    /* Immediate table

    =================================================================
    |   immediate type  |12 |11 |10 | 9 | 8 | 7 | 6 | 5 | 4 | 3 | 2 | bits
    =================================================================
    |     jump_imm      |11 | 4 | 9 | 8 |10 | 6 | 7 | 3 | 2 | 1 | 5 |
    |    branch_imm     | 8 | 4 | 3 | x | x | x | 7 | 6 | 2 | 1 | 5 |
    |     ls_uimm       | 5 | 4 | 3 | x | x | x | 2 | 6 | x | x | x |
    |    lwsp_uimm      | 5 | x | x | x | x | x | 4 | 3 | 2 | 7 | 6 |
    |    swsp_uimm      | 5 | 4 | 3 | 2 | 7 | 6 | x | x | x | x | x |
    |      nzimm        | 5 | x | x | x | x | x | 4 | 3 | 2 | 1 | 0 |
    |       imm         | 5 | x | x | x | x | x | 4 | 3 | 2 | 1 | 0 |
    |      nzuimm       | 5 | x | x | x | x | x | 4 | 3 | 2 | 1 | 0 |
    |    lui_nzuimm     |17 | x | x | x | x | x |16 |15 |14 |13 |12 |
    |   addsp_nzuimm    | 9 | x | x | x | x | x | 4 | 6 | 8 | 7 | 5 |
    |   addsp4_nzuimm   | 5 | 4 | 9 | 8 | 7 | 6 | 2 | 3 | x | x | x |
    =================================================================
                          ^- sign bit
                          
    */
    wire sign = inst[12] && !unsigned_imm; 
    wire [4:0] low5 = inst[6:2];
    
    // jump/branch target
    wire [2:0] jump_upper = {sign, inst[8], inst[10]};

    assign jt = {{20{sign}},                             // bits 31:12
                (j_type) ? jump_upper : {3{sign}},      // bits 11:9
                (j_type) ? inst[9]: inst[12],           // bit 8
                inst[6],                                // bit 7
                (j_type) ? inst[7] : inst[5],           // bit 6
                inst[2],                                // bit 5
                inst[11],                               // bit 4
                (j_type) ? inst[5] : inst[10],          // bit 3
                inst[4:3],                              // bits 2:1
                1'b0                                    // bit 0
                };
    
    // immediate selection
    wire shift_inst = (temp_op == 4'd8 || temp_op == 4'd9 || temp_op == 4'd10);
    wire [5:0] lui_set = {sign, low5};

    assign imm = {{14{sign}},                           // bits 31:18
                 (lui_type) ? lui_set : {6{sign}},      // bits 17:12
                 (lui_type) ? 2'd0 : {2{sign}},         // bits 11:10
                 (lui_type) ? 1'd0 : (spn_imm ? inst[10] : (sp_imm ? inst[12] : sign)),   // bit 9
                 (lui_type) ? 1'd0 : ((spn_imm) ? inst[9] : (sp_imm ? inst[4] : sign)),   // bit 8
                 (lui_type) ? 1'd0 : ((spn_imm|(store_inst & lssp_imm)) ? inst[8] : ((sp_imm | (load_inst & lssp_imm)) ? inst[3] : sign)),   // bit 7
                 (lui_type) ? 1'd0 : (lssp_imm ? (load_inst ? inst[2] : inst[7]) : (spn_imm ? inst[7] : ((sp_imm || load_inst || store_inst) ? inst[5] : sign))), // bit 6
                 (lui_type) ? 1'd0 : (sp_imm ? inst[2] : inst[12]), // bit 5
                 (lui_type) ? 1'd0 : (((load_inst && ~lssp_imm) || store_inst || spn_imm) ? inst[11] : inst[6]), // bit 4
                 (lui_type || sp_imm) ? 1'd0 : ((store_inst || (load_inst && !lssp_imm)) ? inst[10] : inst[5]), // bit 3
                 (lui_type || sp_imm) ? 1'd0 : ((store_inst && lssp_imm) ? inst[9] : (spn_imm || (load_inst && ~lssp_imm) || store_inst) ? inst[6] : inst[4]), // bit 2
                 (lui_type || sp_imm || spn_imm || load_inst || store_inst) ? 2'd0 : inst[3:2]  // bits 1:0
                };

    // outputs
    
    assign is_compressed = !(opcode == 2'b11);

    assign btype[1] = (opcode == 2'd1) && (funct3 == 3'd6); // BEQZ
    assign btype[0] = (opcode == 2'd1) && (funct3 == 3'd7); // BNEZ
    assign use_A = !(rs1 == 5'd0);
    assign use_B = !(rs2 == 5'd0);
    assign sel_pc = j_type || jr_type;
    assign sel_opBR = jr_type;
    

endmodule