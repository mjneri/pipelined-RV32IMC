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


module tb_storeblock();
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
        $display("TESTING STORE BLOCK MODULE\n================");
        $display("===| NOT S-TYPE INST |===");
        opB = 32'h75c0e198;    //not s type
        byte_offset = 2'd0;
        store_select = 2'd2;
        is_stype = 1'd0;
        #20;
        $strobe("opB: 0x%X\tbyte_offset: %d\tdata: 0x%X\tdm_write: 0b%B", opB, byte_offset, data, dm_write);

        #10;
        $display("===| SW |===");
        #50;
        byte_offset = 2'd0; //sw zero offset
        store_select = 2'd2;
        is_stype = 1'd1;
        $strobe("opB: 0x%X\tbyte_offset: %d\tdata: 0x%X\tdm_write: 0b%B", opB, byte_offset, data, dm_write);

        #50;    //sw 1 offset
        byte_offset = 2'd1;
        store_select = 2'd2;
        is_stype = 1'd1;
        $strobe("opB: 0x%X\tbyte_offset: %d\tdata: 0x%X\tdm_write: 0b%B", opB, byte_offset, data, dm_write);

        #50;    //sw 2 offset
        byte_offset = 2'd2;
        store_select = 2'd2;
        is_stype = 1'd1;
        $strobe("opB: 0x%X\tbyte_offset: %d\tdata: 0x%X\tdm_write: 0b%B", opB, byte_offset, data, dm_write);

        #50;    //sw 3 offset
        byte_offset = 2'd3;
        store_select = 2'd2;
        is_stype = 1'd1;
        $strobe("opB: 0x%X\tbyte_offset: %d\tdata: 0x%X\tdm_write: 0b%B", opB, byte_offset, data, dm_write);

        #10;
        $display("===| SH |===");
        #50;    //sh 0 offset
        byte_offset = 2'd0;
        store_select = 2'd1;
        is_stype = 1'd1;
        $strobe("opB: 0x%X\tbyte_offset: %d\tdata: 0x%X\tdm_write: 0b%B", opB, byte_offset, data, dm_write);

        #50;    //sh 1 offset
        byte_offset = 2'd1;
        store_select = 2'd1;
        is_stype = 1'd1;
        $strobe("opB: 0x%X\tbyte_offset: %d\tdata: 0x%X\tdm_write: 0b%B", opB, byte_offset, data, dm_write);

        #50;    //sh 2 offset
        byte_offset = 2'd2;
        store_select = 2'd1;
        is_stype = 1'd1;
        $strobe("opB: 0x%X\tbyte_offset: %d\tdata: 0x%X\tdm_write: 0b%B", opB, byte_offset, data, dm_write);

        #50;    //sh 3 offset
        byte_offset = 2'd3;
        store_select = 2'd1;
        is_stype = 1'd1;
        $strobe("opB: 0x%X\tbyte_offset: %d\tdata: 0x%X\tdm_write: 0b%B", opB, byte_offset, data, dm_write);

        #10;
        $display("===| SB |===");
        #50;    //sb 0 offset
        byte_offset = 2'd0;
        store_select = 2'd0;
        is_stype = 1'd1;
        $strobe("opB: 0x%X\tbyte_offset: %d\tdata: 0x%X\tdm_write: 0b%B", opB, byte_offset, data, dm_write);

        #50;    //sb 1 offset
        byte_offset = 2'd1;
        store_select = 2'd0;
        is_stype = 1'd1;
        $strobe("opB: 0x%X\tbyte_offset: %d\tdata: 0x%X\tdm_write: 0b%B", opB, byte_offset, data, dm_write);

        #50;    //sb 2 offset
        byte_offset = 2'd2;
        store_select = 2'd0;
        is_stype = 1'd1;
        $strobe("opB: 0x%X\tbyte_offset: %d\tdata: 0x%X\tdm_write: 0b%B", opB, byte_offset, data, dm_write);

        #50;    //sb 3 offset
        byte_offset = 2'd3;
        store_select = 2'd0;
        is_stype = 1'd1;
        $strobe("opB: 0x%X\tbyte_offset: %d\tdata: 0x%X\tdm_write: 0b%B", opB, byte_offset, data, dm_write);
        #50;
        $finish;
    end

endmodule
