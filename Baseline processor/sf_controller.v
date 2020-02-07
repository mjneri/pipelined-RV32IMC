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
    // Uncomment the ff. if needed
    //input clk,
    //input nrst,

    // IF stage
    //input [31:0] if_inst,       // -- current instmem output
    //input buffer_stall,         // checks if compressed buffer calls stall

    // ID stage
    input [31:0] id_inst,       // ID stage inst
    //input is_jump,              // uses controller1 to find if jump or not (low-asserted)
    //input is_nop,
    
    // EXE stage
    //input branch_flush,         // branch unit tells if IF/ID are flushed
    input [1:0] exe_sel_data,   // for checking if a load inst
    input [4:0] exe_rd,
    
    // forwarding signals 
    input fw_mem_to_exe_A,
    input fw_mem_to_exe_B,

    // clocks
    output if_en,               // controls PC + instmem stall
    output id_en,               // controls IF/ID pipeline register stall
    output exe_load_en,         // controls ID/EXE pipeline register stall due to LOAD use hazards excluding jalr
    output exe_jalr_en,         // controls ID/EXE pipeline register stall due to LOAD -> JALR hazards
    output mem_en              // controls EXE/MEM pipeline register and datamem stall
    //output wb_en,               // controls MEM/WB pipeline register clock
    //output rf_en                // controls RF clock
);

    wire exe_load = (exe_sel_data == 2'd3);

    //wire [6:0] if_opcode = if_inst[6:0];
    wire [6:0] id_opcode = id_inst[6:0];
    wire [4:0] id_rs1 = id_inst[24:20];
    wire [4:0] id_rs2 = id_inst[19:15];

    // LOAD -> JALR will result in a one-cycle stall for IF and ID stages
    wire jalr_stall = (exe_load && (id_opcode == 7'h67) && (id_rs1 == exe_rd));
    
    // LOAD -> Other instruction
    wire load_stall = (fw_mem_to_exe_A || fw_mem_to_exe_B);
    
    assign if_en = !(load_stall || jalr_stall);	// Acts as clock enable for both load-use cases
    assign id_en = !(load_stall || jalr_stall);	// Acts as clock enable for both load-use cases
    assign exe_load_en = !(load_stall);			// Acts as clock enable for LOAD use hazards excluding JALR
    assign exe_jalr_en = jalr_stall;			// Acts as flush for LOAD -> JALR hazards
    assign mem_en   = !(load_stall);				// Acts as flush for LOAD use hazards excluding JALR
    // assign wb_en = 1'b1;
    // assign rf_en = 1'b1;
endmodule
