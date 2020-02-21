`timescale 1ns / 1ps
/*
    Interrupt Controller Module
*/
module interrupt_controller(
    input clk,
    input nrst,
    input [11:0] PC,            // Input from PC module
    input [6:0] if_opcode,         // Used to catch URET Instructionz
	input interrupt_signal,
    input [1:0] exe_correction,
    input if_prediction,
    input id_jump_in_bht,
    input id_sel_pc,
    input if_clk_en,
    output ISR_stall,
    output ISR_flush,
	output reg sel_ISR,
    output reg ret_ISR,
    output reg ISR_en,
    output reg ISR_running,
    output reg [11:0] save_PC
);

    reg [2:0] ISR_stall_counter;
    assign ISR_stall = (ISR_stall_counter!=0) ||    // Stall for 5 cycles
                        (if_opcode==7'h73);         // Catch URET instruction

    assign ISR_flush = 0;

    wire save_PC_en;
    assign save_PC_en = ((!interrupt_signal & ISR_en) || // Capture first clock edge
                        (ISR_stall & ((exe_correction!=0) | if_prediction | (id_sel_pc & !id_jump_in_bht)))) // Catch any change in PC while pipeline finishes
                        & !(ISR_running);   //Di massave PC during ISR

    always@(posedge clk) begin
        if(!nrst)begin
            sel_ISR <= 0;
            ret_ISR <= 0;
            ISR_en <= 1;
            save_PC <= 12'd0;
            ISR_running <= 0;
            ISR_stall_counter <= 0;
        end else begin
            if(!interrupt_signal & !(sel_ISR | !ISR_en)) begin
                ISR_stall_counter <= 1;
                ISR_en <= 0;
            end else if(interrupt_signal & !(ISR_running | ISR_stall))
                ISR_en <= 1;

            if(if_opcode==7'h73) begin
                ISR_stall_counter <= 1;
                ret_ISR <= 1;
                sel_ISR <= 0;
            end

            if(save_PC_en) begin
                save_PC <= PC;
            end else begin
                save_PC <= save_PC;
            end

            if(ISR_stall_counter!=0) begin
                if(if_clk_en)
                    ISR_stall_counter <= ISR_stall_counter+1;
            end

            if((ISR_stall_counter == 3'd3) & !ISR_running) begin
                ISR_stall_counter <= 0;
                ISR_running <= 1;
                sel_ISR <= 1;
            end else if((ISR_stall_counter == 3'd2) & ISR_running) begin
                ISR_stall_counter <= 0;
                ISR_running <= 0;
                ret_ISR <= 0;
            end
        end
    end
	
endmodule