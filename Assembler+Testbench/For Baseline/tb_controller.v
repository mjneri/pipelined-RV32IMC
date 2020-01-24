`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
 
// Create Date: 01/23/2020 02:40:16 AM
// Design Name: 
// Module Name: tb_controller
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


module tb_controller();
    //inputs
    reg [6:0] opcode;
    reg [2:0] funct3;
    reg [6:0] funct7;
    reg z;
    reg less;
    
    //outputs
    wire [3:0] ALU_op;
    wire sel_opA;
    wire sel_opB;
    wire is_stype;
    wire wr_en;
    wire [2:0] dm_select;
    wire [2:0] imm_select;
    wire [1:0] sel_pc;
    wire [1:0] sel_data;
    wire [1:0] store_select;
  
   //Instantiate
   controller1 UUT (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .z(z),
        .less(less),
        .ALU_op(ALU_op),
        .sel_opA(sel_opA),
        .sel_opB(sel_opB),
        .is_stype(is_stype),
        .wr_en(wr_en),
        .dm_select(dm_select),
        .imm_select(imm_select),
        .sel_pc(sel_pc),
        .sel_data(sel_data),
        .store_select(store_select)
   );
    
    initial begin
       // opcode = 7'b0110111;    //lui
       // #100;
       // opcode = 7'b0010111;    //auipc
       // #100;
       // opcode = 7'b1101111;    //jal
       // #100;
       // opcode = 7'b1100111;    //jalr
       // #100;
        //opcode = 7'b1100011;    //btype
       // funct3 = 3'b000;
       // #50
       // funct3 = 3'b001;
        //#50
        //funct3 = 3'b100;
        //#50
        //funct3 = 3'b011;
        //#50
        //funct3 = 3'b101;
        //#50
        //funct3 = 3'b110;
        //#50
        //funct3 = 3'b111;
        //#50
        //funct3 = 3'b010;
        //#100;
        opcode = 7'b0000011;    //ltype
        funct3 = 3'b000;
        #50
        funct3 = 3'b001;
        #50
        funct3 = 3'b111;
        #50
        funct3 = 3'b010;
        #50
        funct3 = 3'b100;
        #50
        funct3 = 3'b101;
        #100;
        opcode = 7'b0100011;    //stype
        funct3 = 3'b000;
        #50
        funct3 = 3'b111;
        #50
        funct3 = 3'b001;
        #50
        funct3 = 3'b010;
        #100;
        opcode = 7'b0010011;    //itype
        funct3 = 3'b000;
        #100;
        funct3 = 3'b010;
        #50;
        funct3 = 3'b011;
        #50
        funct3 = 3'b100;
        #50
        funct3 = 3'b110;
        #50
        funct3 = 3'b111;
        #50
        funct3 = 3'b001;
        #50
        funct3 = 3'b101;
        funct7 = 7'd0;
        #50
        funct7 = 7'b0100000;
        #100
        opcode = 7'b0110011;    //rtype
        funct3 = 3'b000;
        #100;
        funct7 = 7'd0;
        #50;
        funct3 = 3'b010;
        #50;
        funct3 = 3'b011;
        #50
        funct3 = 3'b100;
        #50
        funct3 = 3'b110;
        #50
        funct3 = 3'b111;
        #50
        funct3 = 3'b001;
        #50
        funct3 = 3'b101;
        #50
        funct7 = 7'b0100000;
        #100
        opcode = 7'b0000000;
    end
endmodule
