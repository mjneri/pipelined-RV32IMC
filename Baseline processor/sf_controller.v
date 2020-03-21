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
    input clk,
    input nrst,

    // IF stage
    input [11:0] if_pc,

    // ID stage inputs
    input [11:0] id_pc,
    input is_jump,			// uses controller1 to find if jump or not (low-asserted)
    input is_nop,
    
    // EXE stage inputs
    
    input ISR_PC_flush,			// Output flush signal of interrupt controller
    input ISR_pipe_flush,

    input branch_flush,			// Output flush signal from BHT
    input jump_flush,

    input mul_stall,            // Stall due to multiplication
    input div_running,			// Status of Divider unit

    // Stalls/Enables
	output if_stall,			// controls PC + instmem stall
	output id_stall,			// controls IF/ID pipeline register stall
	output exe_stall,			// controls ID/EXE pipeline register stall
	output mem_stall,			// controls EXE/MEM pipeline register and datamem stall
	output wb_stall,			// controls MEM/WB pipeline register stall

	// Flushes/Resets (flushes act as active-high resets)
	output if_flush,			// controls PC flush
	output id_flush,			// controls IF/ID pipeline register flush
	output exe_flush,			// controls ID/EXE pipeline register flush
	output mem_flush,			// controls EXE/MEM pipeline register flush
	output wb_flush, 			// controls MEM/WB pipeline register flush

    // Clock Enables
    output if_clk_en,
    output id_clk_en,
    output exe_clk_en,
    output mem_clk_en,
    output wb_clk_en,
    output rf_clk_en,

    // Forwarding Unit Inputs
    // Source registers
	input [4:0] id_rsA,
	input [4:0] id_rsB,
	input [4:0] exe_rsA,
	input [4:0] exe_rsB,

	// Destination registers
	input [4:0] exe_rd,
	input [4:0] mem_rd,
	input [4:0] wb_rd,

	// Control signals
	input exe_wr_en,
	input mem_wr_en,
	input wb_wr_en,

	input id_sel_opA,
	input id_sel_opB,

	//input [2:0] id_sel_data,
	input [2:0] exe_sel_data,
	input [2:0] mem_sel_data,
	input [2:0] wb_sel_data,

	input id_is_stype,
	//input exe_is_stype,

	input [2:0] id_imm_select,

	input [6:0] id_opcode,
	input [6:0] exe_opcode,
	input exe_comp_use_A,
	input exe_comp_use_B,
	input exe_is_comp,
	input id_sel_opBR,

	// Outputs
	// Forwarding to ID stage
	output fw_exe_to_id_A,
	output fw_exe_to_id_B,
	output fw_mem_to_id_A,
	output fw_mem_to_id_B,
	output fw_wb_to_id_A,
	output fw_wb_to_id_B,

	// Forwarding to EXE stage
	output fw_wb_to_exe_A,
	output fw_wb_to_exe_B,
    output load_hazard          // result of having a L[W/H/B] -> EXE hazard
);

 	// Forwarding to ID stage
	wire t_fw_exe_to_id_A;
	wire t_fw_exe_to_id_B;
	wire t_fw_mem_to_id_A;
	wire t_fw_mem_to_id_B;
	wire t_fw_wb_to_id_A;
	wire t_fw_wb_to_id_B;

	// Forwarding to EXE stage
	wire t_fw_wb_to_exe_A;
	wire t_fw_wb_to_exe_B;

    forwarding_unit FWD(
		// Source registers
		.id_rsA(id_rsA),
		.id_rsB(id_rsB),
		.exe_rsA(exe_rsA),
		.exe_rsB(exe_rsB),

		// Destination registers
		.exe_rd(exe_rd),
		.mem_rd(mem_rd),
		.wb_rd(wb_rd),

		// Control signals
		.exe_wr_en(exe_wr_en),
		.mem_wr_en(mem_wr_en),
		.wb_wr_en(wb_wr_en),

		.id_sel_opA(id_sel_opA),
		.id_sel_opB(id_sel_opB),

		//.id_sel_data(id_sel_data),
		.exe_sel_data(exe_sel_data),
		.mem_sel_data(mem_sel_data),
		.wb_sel_data(wb_sel_data),

		.id_is_stype(id_is_stype),
		//.exe_is_stype(exe_is_stype),

		.id_imm_select(id_imm_select),

		.id_opcode(id_opcode),
		.exe_opcode(exe_opcode),
		.exe_comp_use_A(exe_comp_use_A),
		.exe_comp_use_B(exe_comp_use_B),
		.exe_is_comp(exe_is_comp),
		.id_sel_opBR(id_sel_opBR),

		// Outputs
		.fw_exe_to_id_A(t_fw_exe_to_id_A),
		.fw_exe_to_id_B(t_fw_exe_to_id_B),
		.fw_mem_to_id_A(t_fw_mem_to_id_A),
		.fw_mem_to_id_B(t_fw_mem_to_id_B),
		.fw_wb_to_id_A(t_fw_wb_to_id_A),
		.fw_wb_to_id_B(t_fw_wb_to_id_B),

		.fw_wb_to_exe_A(t_fw_wb_to_exe_A),
		.fw_wb_to_exe_B(t_fw_wb_to_exe_B),

		.hzd_exe_to_id_A(hzd_exe_to_id_A),
		.hzd_mem_to_exe_A(hzd_mem_to_exe_A),
		.hzd_mem_to_exe_B(hzd_mem_to_exe_B)
	);

    reg if_prev_flush;
	reg id_prev_flush;
	reg exe_prev_flush;
	reg mem_prev_flush;
    reg wb_prev_flush;

    // results of forwarding
    assign fw_exe_to_id_A = t_fw_exe_to_id_A; // && !id_prev_flush;
    assign fw_exe_to_id_B = t_fw_exe_to_id_B; // && !id_prev_flush;
    assign fw_mem_to_id_A = t_fw_mem_to_id_A; // && !exe_prev_flush;
    assign fw_mem_to_id_B = t_fw_mem_to_id_B; // && !exe_prev_flush;
    assign fw_wb_to_id_A = t_fw_wb_to_id_A; // && !mem_prev_flush;
    assign fw_wb_to_id_B = t_fw_wb_to_id_B; // && !mem_prev_flush;

    assign fw_wb_to_exe_A = t_fw_wb_to_exe_A; // && !mem_prev_flush;
    assign fw_wb_to_exe_B = t_fw_wb_to_exe_B; // && !mem_prev_flush;

    wire hzd_exe_to_id_A;
    wire hzd_mem_to_exe_A;
    wire hzd_mem_to_exe_B;

    wire loop_jump = (if_pc == id_pc) && is_jump && ~id_stall;
    
    wire jalr_hazard = hzd_exe_to_id_A;							// LOAD -> JALR will result in a one-cycle stall for IF and ID stages
    assign load_hazard = (hzd_mem_to_exe_A || hzd_mem_to_exe_B) && !mem_prev_flush;	// LOAD -> Other instruction
    /* load_hazard result:
        1st cycle: no clock for IF, ID, EXE stage registers
        2nd cycle: no clock for WB stage registers
        3rd cycle: no clock for RF writeback
    */
    
    // Stalls/Enables
    assign if_stall = ((load_hazard  && ~mem_prev_flush) || jalr_hazard || div_running || mul_stall);
    assign id_stall = ((load_hazard  && ~mem_prev_flush) || jalr_hazard || div_running || mul_stall);
    assign exe_stall = ((load_hazard  && ~mem_prev_flush) || div_running || mul_stall);					
    assign mem_stall = 1'b0;
    assign wb_stall = 1'b0;
    //assign rf_stall = 1'b0;

    // Flushes/Resets
    assign if_flush = ISR_PC_flush;
    assign id_flush = ISR_pipe_flush || jump_flush || branch_flush || is_nop;
    assign exe_flush = jalr_hazard || branch_flush;
    assign mem_flush = (load_hazard && ~mem_prev_flush) || div_running || mul_stall;
    assign wb_flush = 1'b0;

    // Enables
    
    assign if_clk_en = ~(if_stall || loop_jump);
    assign id_clk_en = ~(id_stall || if_prev_flush || loop_jump);
    assign exe_clk_en = ~(exe_stall || id_prev_flush);
    assign mem_clk_en = ~(mem_flush || exe_prev_flush);
    assign wb_clk_en = ~(mem_prev_flush);
    assign rf_clk_en = wb_wr_en;

    always@(posedge clk) begin
        if (!nrst) begin
            if_prev_flush <= 1'b0;
            id_prev_flush <= 1'b0;
            exe_prev_flush <= 1'b0;
            mem_prev_flush <= 1'b0;
            wb_prev_flush <= 1'b0;
        end
        else begin
            if_prev_flush <= if_flush;
            id_prev_flush <= (if_prev_flush ? if_prev_flush : id_flush);
            exe_prev_flush <= (id_prev_flush ? id_prev_flush : exe_flush);
            mem_prev_flush <= (exe_prev_flush ? exe_prev_flush : mem_flush);
            wb_prev_flush <= (mem_prev_flush ? mem_prev_flush : wb_flush);
        end
    end
endmodule
