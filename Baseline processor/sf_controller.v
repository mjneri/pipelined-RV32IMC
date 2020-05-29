//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// sf_controller.v -- Stall + flush + forwarding controller module
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Author: Microlab 198 Pipelined RISC-V Group (2SAY1920)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Module Name: sf_controller.v
// Description:
// 				A handy excuse to merge controlling for stalls and flushes (bad for performance), 
// 				and clock gating (good for power usage).
// 				This controller now also includes the forwarding unit controller in order to reduce the number of wire declarations in the core module.
// 				Stalls and flushes are handled using a mix of clock gating, and additional support logic that facilitates stalling or flushing in the
// 				corresponding pipeline registers.
// 				The scenarios currently supported by the gating logic are as follows:
// 					- Stalls
// 						All stalls are handled by disabling the clock for the corresponding stage.
// 						e.g. an ID-stage stall will have the ID stage clock disabled.
// 					- Flushes
// 						A flush will result in a case-by-case resolution of what will happen. Be prepared for inconsistent behavior.
// 						To give two examples:
// 							- A MEM-stage flush due to a data hazard will result in the MEM stage clock getting disabled on the current
// 							  WB stage clock getting disabled on the next cycle, and will force a non-flush on the next cycle.
// 							- The ISR flushes (ISR_PC_flush and ISR_pipe_flush) work together, but act differently.
// 							  Only the ISR_pipe_flush signal can actually disable the IF- and ID-stage clocks.
// 						What *is* consistent, however, is that flushes get propagated to later stages via the *_prev_flush registers,
// 						with the exception of the IF-stage. 
// 					- Looping Jumps
// 						A looping jump is defined as a jump whose target address is the same as its own address.
// 						Such jumps are detected by checking if the ID-stage instruction is a jump, and if the IF- and ID-stage PC
// 						addresses are equal. If both conditions are met, the result is to disable the IF- and ID-stage clocks, and
// 						to the EXE stage.
// 						Due to how the interrupt memory space is currently implemented, looping jumps cannot be escaped from without resetting.
// 						As such, please use branches to wait for interrupts instead.
// 					- NOPs
// 						These are treated as EXE-stage flushes, but the implementation disables the EXE-stage clock as well. 
//
// Revisions:
// Revision 0.01 - File Created
// Additional Comments:
// 
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=


`timescale 1ns / 1ps

module sf_controller(
    // Uncomment the ff. if needed
    input clk,
    input nrst,

    // IF stage
    input [`PC_ADDR_BITS-1:0] if_pc,

    // ID stage inputs
	input [`PC_ADDR_BITS-1:0] id_pc,
    input is_jump,				// uses controller1 to find if jump or not
    input is_nop,				// ID Stage NOP
    
    input ISR_PC_flush,			// Output flush signals of interrupt controller
    input ISR_pipe_flush,

    input branch_flush,			// Output flush signals from BHT
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

	// Data (Forwarding) Read-After-Write Hazards
    wire hzd_exe_to_id_A;
    wire hzd_mem_to_exe_A;
    wire hzd_mem_to_exe_B;

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

	/* 
	
		*_prev_flush registers keep track of whether the current stage has contains an instruction that has been flushed.
		
		For example:
		- id_prev_flush tracks whether an instruction was flushed from the ID stage on the previous cycle.
		  Thus, it corresponds to the EXE stage on the current cycle.

	*/
	reg id_prev_flush = 0;
	reg exe_prev_flush = 0;
	reg mem_prev_flush = 0;
    reg wb_prev_flush = 0;

    // results of forwarding
    assign fw_exe_to_id_A = t_fw_exe_to_id_A;
    assign fw_exe_to_id_B = t_fw_exe_to_id_B;
    assign fw_mem_to_id_A = t_fw_mem_to_id_A;
    assign fw_mem_to_id_B = t_fw_mem_to_id_B;
    assign fw_wb_to_id_A = t_fw_wb_to_id_A;
    assign fw_wb_to_id_B = t_fw_wb_to_id_B;

    assign fw_wb_to_exe_A = t_fw_wb_to_exe_A && !wb_prev_flush;
    assign fw_wb_to_exe_B = t_fw_wb_to_exe_B && !wb_prev_flush;

    wire loop_jump = (if_pc == id_pc) && is_jump && ~id_sel_opBR && ~id_stall && ~exe_flush;
    
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

    // Flushes/Resets
    assign if_flush = ISR_PC_flush;
    assign id_flush = ISR_pipe_flush || jump_flush || branch_flush;
    assign exe_flush = jalr_hazard || branch_flush || is_nop;
    assign mem_flush = (load_hazard && ~mem_prev_flush) || div_running || mul_stall;	// flushing the MEM-stage for two straight cycles is disabled for forwarding reasons
    assign wb_flush = 1'b0;

    // Enables
	reg prev_nrst = 0;
    wire shut_down = (prev_nrst && ~nrst);
	// A note: the shut_down signal is meant to be a stopgap measure that should be re-evaluated depending on
	// how the processor core is meant to reset or not between cases of nrst deasserting.
	// In other words, this signal solves a problem where the processor does not actually reset when nrst is deasserted
	// due to the nature of the clock enable signals.
	//
	// The processor resetting when nrst is deasserted is intended, but other behavior may be desired.
	// For example, a signal to put the processor to sleep until it is meant to wake up, without going through polling loop
	// or waiting for an interrupt.
	//
	// I'm definitely overthinking this.

    assign if_clk_en = shut_down || (~(if_stall || (loop_jump && ~ISR_pipe_flush)) && nrst);
    assign id_clk_en = shut_down || (~(id_stall || (loop_jump && ~ISR_pipe_flush)) && nrst);
    assign exe_clk_en = shut_down || (~(exe_stall || id_prev_flush || is_nop) && nrst);
    assign mem_clk_en = shut_down || (~(mem_flush || exe_prev_flush) && nrst);
    assign wb_clk_en = shut_down || (~mem_prev_flush && nrst);
    assign rf_clk_en = shut_down ||  (~wb_prev_flush && wb_wr_en && nrst);

	initial begin
		prev_nrst <= 1'b0;
		id_prev_flush <= 1'b0;
		exe_prev_flush <= 1'b0;
		mem_prev_flush <= 1'b0;
		wb_prev_flush <= 1'b0;
	end

    always@(posedge clk) begin
        if (!nrst) begin
			prev_nrst <= 1'b0;
            id_prev_flush <= 1'b0;
            exe_prev_flush <= 1'b0;
            mem_prev_flush <= 1'b0;
            wb_prev_flush <= 1'b0;
        end
        else begin
			prev_nrst <= 1'b1;
            id_prev_flush <= ((id_flush || loop_jump) && ~ISR_pipe_flush);
            exe_prev_flush <= (id_prev_flush ? id_prev_flush : exe_flush);
            mem_prev_flush <= (exe_prev_flush ? exe_prev_flush : mem_flush);
            wb_prev_flush <= (mem_prev_flush ? mem_prev_flush : wb_flush);
        end
    end
endmodule
