`timescale 1ns / 1ps
/* 
    Clock Controller module

    A handy excuse to merge controlling for stalls and flushes (bad for performance), 
    and clock gating (good for power usage).
    
    An intended feature down the line is to treat back-to-back issues of the same branch instruction as a NOP.
    A branch that links to itself, after all, results in the processor spinning its wheels.

    Stall(s) are (currently) as follows:
        - L(B/H/W)/inst pair (stall at ID)

        LW      IF  ID  EXE MEM WB
        inst        IF  ID  EXE MEM WB
                            ^- hazard: need to stall since memory not read yet
*/

module sf_controller(
    input clk,
    input nrst,
    // IF stage
    input [31:0] if_inst,       // -- current instmem output
    input buffer_stall,         // checks if compressed buffer calls stall
    // ID stage
    input [31:0] id_inst,       // ID stage inst
    input is_jump,              // uses controller1 to find if jump or not (low-asserted)
    input is_nop,
    // EXE stage
    input branch_flush,         // branch unit tells if IF/ID are flushed
    input [1:0] exe_sel_data,   // for checking if a load inst
    input [4:0] exe_rd,
    // forwarding signals 
    // clocks
    output if_en,               // controls PC + instmem stall
    output id_en,               // controls IF/ID stage register stall
    output exe_en,              // controls ID/EXE stage register stall
    output mem_en,              // controls EXE/MEM stage register and datamem stall
    output wb_en,               // controls MEM/WB stage register clock
    output rf_en                // controls RF clock
    );
    
    assign rf_en = 1'b1;
    assign wb_en = 1'b1;

    wire exe_load = (exe_sel_data == 2'd3);

    wire [6:0] if_opcode = if_inst[6:0];
    wire [6:0] id_opcode = id_inst[6:0];
    wire [4:0] id_rs1 = id_inst[24:20];
    wire [4:0] id_rs2 = id_inst[19:15];

    wire load_stall = exe_load && ((id_rs1 == exe_rd) || (id_rs2 == exe_rd));
    
    assign if_en    = !load_stall;
    assign id_en    = !load_stall;
    assign exe_en   = 1;
    assign mem_en   = 1;
    
endmodule
