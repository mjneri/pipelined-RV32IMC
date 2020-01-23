`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/23/2020 05:24:24 PM
// Design Name: 
// Module Name: storeblock
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


module storeblock(
    input [31:0] opB,
    input [1:0] byte_offset,
    input [1:0] store_select,
    input is_stype,
    output [31:0] data,
    output [3:0] dm_write
    );
    
    parameter sw = 2'd2;
    parameter sh = 2'd1;
    parameter sb = 2'd0;
    
    wire [31:0] nboff_data;
    
    assign nboff_data = (store_select == sb) ? {24'd0 , opB[7:0]} : (store_select == sh) ? {16'd0, opB[15:0]} : opB ;
    assign data = nboff_data << (4*byte_offset);
    
    assign dm_write = (is_stype && byte_offset == 2'd0) ? 4'b0001 : (is_stype && byte_offset == 2'd1) ? 4'b0010 : (is_stype && byte_offset == 2'd2) ? 4'b0100 : (is_stype && byte_offset == 2'd3) ? 4'b1000 : 4'b0000;
endmodule
