`timescale 1ns / 1ps
/*
    Interrupt Controller Module
*/
module interrupt_controller(
	input clk,
	input nrst,
	input stall,				// Input from sf_controller

	input [11:0] if_pcnew,		// Input to PC (if_pcnew)
	input [11:0] if_PC,			// current PC
	input [6:0] if_opcode,		// Used to catch URET Instruction
	input int_sig,

	input if_prediction,
	input [1:0] exe_correction,
	input id_jump_in_bht,
	input id_sel_pc,

	//output ISR_stall,
	output ISR_PC_flush,
    output ISR_pipe_flush,
	output reg sel_ISR,
	output reg ret_ISR,
	//output reg ISR_en,

	output reg ISR_running,		// Determines if the ISR is running
	output reg [11:0] save_PC
);

    reg [2:0] ISR_stall_counter;
    reg ISR_en;
    wire ISR_stall = (ISR_stall_counter!=0) ||    	// Stall for 5 cycles
                        (if_opcode==7'h73);			// Catch URET instruction

    assign ISR_PC_flush = (interrupt_captured) || (ISR_stall & !ret_ISR) & !stall & (!(ISR_stall_counter < 3'd2) | (save_PC == if_PC));
    assign ISR_pipe_flush = (ISR_stall) & !stall & ((!(ISR_stall_counter < 3'd2) & !ret_ISR) | ret_ISR  | (save_PC == if_PC));

    reg interrupt_captured;
    wire save_PC_en;
    assign save_PC_en = (interrupt_captured || // Capture first clock edge
                        (ISR_stall & ((exe_correction!=0) | if_prediction | (id_sel_pc & !id_jump_in_bht)))) // Catch any change in PC while pipeline finishes
                         & !(ISR_running);   //Di massave PC during ISR

	initial begin
		sel_ISR <= 0;
		ret_ISR <= 0;
		ISR_en <= 1;
		save_PC <= 12'd0;
		ISR_running <= 0;
		ISR_stall_counter <= 0;
	end
	
    always@(posedge clk) begin
        if(!nrst)begin
            sel_ISR <= 0;
            ret_ISR <= 0;
            ISR_en <= 1;
            save_PC <= 12'd0;
            ISR_running <= 0;
            ISR_stall_counter <= 0;
            interrupt_captured <= 0;
        end else begin
            if(int_sig & !(sel_ISR | !ISR_en)) begin
                ISR_stall_counter <= 1;
                ISR_en <= 0;
            end else if(!int_sig & !(ISR_running | ISR_stall))
                ISR_en <= 1;

            if(if_opcode==7'h73) begin
                ISR_stall_counter <= 1;
                ret_ISR <= 1;
                sel_ISR <= 0;
            end

            if(save_PC_en) begin
                save_PC <= if_pcnew;
            end

            if(ISR_stall_counter!=0) begin
                if(!stall)
                    ISR_stall_counter <= ISR_stall_counter+1;
            end

            if((ISR_stall_counter == 3'd5) & !ISR_running) begin
                ISR_stall_counter <= 0;
                ISR_running <= 1;
                sel_ISR <= 1;
            end else if((ISR_stall_counter == 3'd5) & ISR_running) begin
                ISR_stall_counter <= 0;
                ISR_running <= 0;
                ret_ISR <= 0;
            end

            if (int_sig & ISR_en)
                interrupt_captured <= 1;
            
            if (interrupt_captured)
                interrupt_captured <= 0;
        end
    end
	
endmodule