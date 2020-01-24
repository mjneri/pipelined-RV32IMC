`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/23/2020 05:19:55 AM
// Design Name: 
// Module Name: tb_sb
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


module tb_sb();
    reg [31:0] opB;
    reg [1:0] byte_offset;
    reg [1:0] store_select;
    reg is_stype;
    
    wire [31:0] data;
    wire [3:0] dm_write;
    
    storeblock UUT(
        .opB(opB),
        .byte_offset(byte_offset),
        .store_select(store_select),
        .is_stype(is_stype),
        .data(data),
        .dm_write(dm_write)
    );
    
    initial begin
        opB = 32'd1;    //not s type
        byte_offset = 2'd0;
        store_select = 2'd2;
        is_stype = 1'd0;
        #100 
        byte_offset = 2'd0; //sw zero offset
        store_select = 2'd2;
        is_stype = 1'd1;
        #100    //sw 1 offset
        byte_offset = 2'd1;
        store_select = 2'd2;
        is_stype = 1'd1;
        #100    //sw 2 offset
        byte_offset = 2'd2;
        store_select = 2'd2;
        is_stype = 1'd1;
        #100    //sw 3 offset
        byte_offset = 2'd3;
        store_select = 2'd2;
        is_stype = 1'd1;
        #100    //sh 0 offset
        byte_offset = 2'd0;
        store_select = 2'd1;
        is_stype = 1'd1;
        #100    //sh 3 offset
        byte_offset = 2'd3;
        store_select = 2'd1;
        is_stype = 1'd1;
        #100    //sb 0 offset
        byte_offset = 2'd3;
        store_select = 2'd0;
        is_stype = 1'd1;
        #100    //sb 1 offset
        byte_offset = 2'd1;
        store_select = 2'd0;
        is_stype = 1'd1;
    end

endmodule
