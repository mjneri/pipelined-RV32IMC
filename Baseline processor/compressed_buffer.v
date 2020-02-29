`timescale 1ns / 1ps
/*

    Compressed Instruction Buffer

    This module implements the buffer necessary to properly support halfword (16-bit) length instructions
    when mixed with word length instructions.
    
    The decoder is separate and will be in the ID stage instead.

*/

module compressed_buffer (
    input clk,
    input nrst,
    input [31:0] inst,
    input ext_stall,
    output reg_inst,
    output buff_stall,
    output [31:0] out_inst
    );

    //reg temp_buff_stall;
    reg [15:0] buffer_inst;        // instruction buffer
    reg full;
    wire [1:0] inst_low2     = inst[1:0];
    wire [1:0] buff_low2     = buffer_inst[1:0];
    wire is_word        = full ? (buff_low2 == 2'd3) : (inst_low2 == 2'd3);
    assign reg_inst = !is_word;
    reg temp_buff_stall;
    assign buff_stall = temp_buff_stall;
    wire [15:0] lo_half        = inst[31:16];
    wire [15:0] hi_half        = inst[15:0];
    assign out_inst     =   (full   ?   (is_word    ?   {lo_half, buffer_inst} : {16'd0, buffer_inst}) :
                                        (is_word    ?   inst : {16'd0, hi_half}));

    always@ (posedge clk) begin
        if (!nrst) begin
            buffer_inst <= 16'd0;
            full <= 1'b0;
            temp_buff_stall <= 1'b0;
        end
        else if (inst != 32'd0) begin
            // legal instruction -- proceed
            if (!ext_stall) begin
                if (full) begin
                    if (is_word) begin
                        buffer_inst <= hi_half;
                        full <= 1'b1;
                        temp_buff_stall <= 1'b0;
                    end
                    else begin
                        buffer_inst <= hi_half;
                        full <= 1'b0;
                        temp_buff_stall <= 1'b0;
                    end
                end
                else begin
                    if (is_word) begin
                        buffer_inst <= 16'd0;
                        full <= 1'b0;
                        temp_buff_stall <= 1'b0;
                    end
                    else begin
                        buffer_inst <= lo_half;
                        full <= 1'b1;
                        temp_buff_stall <= 1'b1;
                    end
                end
            end
            else begin
                buffer_inst <= buffer_inst;
                full <= full;
                temp_buff_stall <= temp_buff_stall;
            end
        end
    end

endmodule

