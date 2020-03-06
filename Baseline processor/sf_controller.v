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

    // ID stage inputs
    //input [6:0] id_opcode,
    //input [4:0] id_rsA,
    //input [4:0] id_rsB,
    //input is_jump,			// uses controller1 to find if jump or not (low-asserted)
    //input is_nop,
    
    // EXE stage inputs
    //input [6:0] exe_opcode,		// for checking if a load inst
    //input exe_wr_en,
    //input [4:0] exe_rd,
    
    input ISR_PC_flush,			// Output flush signal of interrupt controller
    input ISR_pipe_flush,

    input branch_flush,			// Output flush signal from BHT
    input jump_flush,

    input div_running,			// Status of Divider unit

    // Load-use hazards
    input hzd_exe_to_id_A,		// determines LOAD@EXE>JALR@ID hazards
    input hzd_mem_to_exe_A,		// determines LOAD@MEM>EXE hazards
    input hzd_mem_to_exe_B,		// determines LOAD@MEM>EXE hazards

    // Divider status
    //input [1:0] div_status, 	// determines status of Divider unit

    // Stalls/Enables
	output if_stall,			// controls PC + instmem stall
	output id_stall,			// controls IF/ID pipeline register stall
	output exe_stall,			// controls ID/EXE pipeline register stall
	output mem_stall,			// controls EXE/MEM pipeline register and datamem stall
	output wb_stall,			// controls MEM/WB pipeline register stall
	//output rf_stall,			// controls RF stall

	// Flushes/Resets (flushes act as active-high resets)
	output if_flush,			// controls PC flush
	output id_flush,			// controls IF/ID pipeline register flush
	output exe_flush,			// controls ID/EXE pipeline register flush
	output mem_flush,			// controls EXE/MEM pipeline register flush
	output wb_flush 			// controls MEM/WB pipeline register flush
);
    
    wire jalr_hazard = hzd_exe_to_id_A;							// LOAD -> JALR will result in a one-cycle stall for IF and ID stages
    wire load_hazard = (hzd_mem_to_exe_A || hzd_mem_to_exe_B);	// LOAD -> Other instruction
    
    // Stalls/Enables
    assign if_stall = load_hazard || jalr_hazard || div_running;
    assign id_stall = load_hazard || jalr_hazard || div_running;
    assign exe_stall = load_hazard || div_running;					
    assign mem_stall = 1'b0;
    assign wb_stall = 1'b0;
    //assign rf_stall = 1'b0;

    // Flushes/Resets
    assign if_flush = ISR_PC_flush;
    assign id_flush = ISR_pipe_flush || jump_flush || branch_flush;
    assign exe_flush = jalr_hazard || branch_flush;
    assign mem_flush = load_hazard || div_running;
    assign wb_flush = 1'b0;
endmodule
