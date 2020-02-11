`timescale 1ns / 1ps
`define CLK_PD 20
`define DEL_IN 5
module tb_buffer();
    reg [31:0] test_mem [0:15];
    reg clk;
    reg nrst;
    reg [31:0] inst;
    wire buffer_stall;
    wire [31:0] out_inst;
    integer i;
    always
	    #(`CLK_PD/2.0) clk = ~clk;

    compressed_buffer cbufftest (
        clk,
        nrst,
        inst,
        buffer_stall,
        out_inst
    );
    initial begin
        $dumpfile("ccc.vcd");
        $dumpvars(0, tb_buffer);
        $readmemh("cbuff_test.txt", test_mem);
        #5
        inst = 32'd0;
        nrst = 0;
        clk = 0;
        #`CLK_PD;
        #`CLK_PD;
        nrst = 1;
        #(`CLK_PD/2);
        i = 0;
        while (i < 16) begin
            inst = test_mem[i];
            #(`CLK_PD - 1);
            if (!buffer_stall)
                i++;
            #1;
        end
        $finish;
    end

endmodule