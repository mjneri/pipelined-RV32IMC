//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// interrupt_controller.v -- Interrupt controller module
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Author: Microlab 198 Pipelined RISC-V Group (2SAY1920)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Module Name: interrupt_controller.v
// Description: This module implements the interrupt controller that controls the 
//              flow of instructions in the datapath whenever an interrupt signal
//              is detected.
//
// Revisions:
// Revision 0.01 - File Created
// Additional Comments:
// 
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

`timescale 1ns / 1ps

`include "constants.vh"

module interrupt_controller(
	input clk,                  	// Ungated clock input
	input nrst,
	input stall,					// Input from sf_controller

	input [`PC_ADDR_BITS-1:0] if_pcnew,			// Input to PC (if_pcnew)
	input [`PC_ADDR_BITS-1:0] if_PC,			// current PC address
	input [6:0] exe_opcode,						// Used to catch URET Instruction

	// Interrupt signal source
	input [`INT_SIG_WIDTH-1:0] int_sig,

	// Inputs from BHT (check branchpredictor.v for more info about each signal)
	input if_prediction,
	input [1:0] exe_correction,
	input id_jump_in_bht,
	input id_sel_pc,

	// Outputs
	output ISR_PC_flush,			// Flushes PC
    output ISR_pipe_flush,			// Flushes IF/ID Pipeline register
	output reg sel_ISR,				// selects ISR_MEM in instmem.v; select ISR
	output reg ret_ISR,				// selects save_PC as input to PC; return from ISR

	output reg ISR_running,			// Determines if the ISR is running. Asserted until pipeline switches back from ISR to main program.
	output reg [`PC_ADDR_BITS-1:0] save_PC		// saved PC address
);

    // Declare wires & regs
	integer i = 0;					// Used for FOR loops
    reg [2:0] ISR_stall_counter;	// Used for counting how many cycles the pipeline should "stall" before running the ISR; start/end sequence initiates once counter value != 0
    reg [`INT_SIG_WIDTH-1:0] ISR_en;// Interrupts can be triggered only if this signal is asserted
	reg interrupt_captured;			// Asserts for 1 cycle when int_sig & ISR_en are both asserted
    wire ISR_stall;					// Indicates that the pipeline is "stalled"
	wire save_PC_en;				// Asserted for 1 cycle during the ISR start sequence & whenever a branch/jump instruction takes the branch target; Won't assert during ISR end sequence

	// Assert if the ISR start/end sequence has started or if URET is detected.
	// NOTE: start/end sequence refers to the period when the pipeline has to stall -> before the ISR executes & after the ISR is finished executing.
	assign ISR_stall = (ISR_stall_counter != 0) || (exe_opcode == `OPC_URET);

	// ISR_PC_flush asserts for the following conditions:
	//		+ save_PC == if_PC; Since save_PC already contains if_PC in this case, the instruction corresponding to if_PC shouldn't be propagated to prevent it from being executed twice.
	//		+ ISR_stall_counter >= 2; In the event that save_PC != if_PC when int_sig is asserted. Always overridden by the case above.
	// It is not asserted:
	//		- when stall is asserted (or when the pipeline is stalled due to division for example)
	//		- during ISR end sequence
    assign ISR_PC_flush = (ISR_stall & !ret_ISR) & !stall & (!(ISR_stall_counter < 3'd2) | (save_PC == if_PC));

	// ISR_pipe_flush asserts for the following conditions:
	//		+ ISR_stall_counter >= 2 && !ret_ISR; Delay pipeflush by one cycle during start sequence
	//		+ ret_ISR; Immediately assert pipeflush during end sequence
	//		+ save_PC == if_PC; immediately assert pipeflush. Overrides first condition in this list
	// It is not asserted:
	//		- when stall is asserted (or when the pipeline is stalled due to division for example)
    assign ISR_pipe_flush = (ISR_stall) & !stall & ((!(ISR_stall_counter < 3'd2) & !ret_ISR) | ret_ISR  | (save_PC == if_PC));

	// save_PC_en asserts for the following conditions:
	//		+ interrupt_captured asserted; assert save_PC_en immediately after interrupt_captured is asserted
	//		+ When a branch is taken during start sequence; This is to make sure that save_PC also captures the branch target address
	// It is not asserted when the ISR is running & during the end sequence (since there is no need to update save_PC during these conditions)
    assign save_PC_en = (interrupt_captured || (ISR_stall & ((exe_correction!=0) | if_prediction | (id_sel_pc & !id_jump_in_bht)))) & !(ISR_running);

    // Initializing registers
	initial begin
		sel_ISR <= 0;
		ret_ISR <= 0;
        interrupt_captured <= 0;
		save_PC <= 0;
		ISR_running <= 0;
		ISR_stall_counter <= 0;
		
		for(i = 0; i < `INT_SIG_WIDTH; i = i+1)
			ISR_en[i] <= 1'b1;
	end

    // This controls save_PC
    always@(posedge clk) begin
        if(!nrst) save_PC <= 0;
        else if(save_PC_en) save_PC <= if_pcnew;
    end
	
    // This controls interrupt_captured
	// NOTE: interrupt_captured asserts for one cycle only. Once the ISR start sequence has started,
	// it won't be able to assert again until after the ISR end sequence finishes.
    always@(posedge clk) begin
        if(!nrst)
            interrupt_captured <= 0;
        else begin
			for(i = 0; i < `INT_SIG_WIDTH; i = i+1) begin
				if(int_sig[i] & ISR_en[i] & !(ISR_stall || ISR_running))
					interrupt_captured <= 1;
				else if(interrupt_captured)
					interrupt_captured <= 0;
			end
        end
    end

	// This controls ISR_stall_counter
	always@(posedge clk) begin
		if(!nrst)
			ISR_stall_counter <= 0;
		else begin
			// Increment ISR_stall_counter unless an external stall is asserted.
            if((ISR_stall_counter != 0) && !stall) 
				ISR_stall_counter <= ISR_stall_counter + 1;
			
			// Initiate ISR startup sequence; Don't set counter to 1 if start sequence has already started (i.e. if counter > 1)
			for(i = 0; i < `INT_SIG_WIDTH; i = i+1)
				if(int_sig[i] & !(!ISR_en[i] || ISR_stall || ISR_running)) 
					ISR_stall_counter <= 1;
			
			// Initiate ISR end sequence once URET opcode is detected
			if(exe_opcode == `OPC_URET) 
				ISR_stall_counter <= 1;
			
			// Reset ISR_stall_counter to 0 once counter value == 5
			if(ISR_stall_counter == 3'd5 && !ISR_running)
				ISR_stall_counter <= 0;
			else if(ISR_stall_counter == 3'd3 && ISR_running)
				ISR_stall_counter <= 0;
		end
	end

	// This controls ISR_en
	always@(posedge clk) begin
		if(!nrst)
			for(i = 0; i < `INT_SIG_WIDTH; i = i+1)
				ISR_en[i] <= 1'b1;
		else begin
			for(i = 0; i < `INT_SIG_WIDTH; i = i+1) begin
				if(int_sig[i] & !(sel_ISR | !ISR_en[i]))
					ISR_en[i] <= 0;				// De-assert ISR_en at the next cycle if int_sig is asserted while ISR_en is asserted
				else if(!int_sig[i] & !(ISR_running | ISR_stall))
					ISR_en[i] <= 1;				// Re-assert ISR_en once int_sig de-asserts & ISR is not running
			end
		end
	end

	// This controls ISR_running, sel_ISR, & ret_ISR
    always@(posedge clk) begin
        if(!nrst)begin
            sel_ISR <= 0;
            ret_ISR <= 0;
            ISR_running <= 0;
        end else begin
            // Initiate ISR end sequence once URET opcode is detected
            if(exe_opcode == `OPC_URET) begin
                ret_ISR <= 1;
                sel_ISR <= 0;
            end

			// ISR_running logic
            if((ISR_stall_counter == 3'd5) & !ISR_running) begin
                ISR_running <= 1;
                sel_ISR <= 1;
            end else if((ISR_stall_counter == 3'd3) & ISR_running) begin
                ISR_running <= 0;
                ret_ISR <= 0;
            end

        end
    end
	
endmodule