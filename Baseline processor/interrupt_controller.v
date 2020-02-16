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
    input id_sel_pc,
    input if_clk_en,
	output reg sel_ISR,
    output reg ret_ISR,
    output reg ISR_en,
    output ISR_stall,
    output reg [11:0] save_PC
);

    reg ISR_running;
    reg ISR_stall_done;
    reg [2:0] ISR_stall_counter;
    //wire ISR_stall;
    assign ISR_stall = (!interrupt_signal & ISR_en & (ISR_stall_counter==0)) ||  // Capture first clock edge
                        (ISR_stall_counter!=0) || ISR_stall_done;  // Stall for 5 cycles
    
    wire save_PC_en;
    assign save_PC_en = (!interrupt_signal & ISR_en) || // Capture first clock edge
                        (ISR_stall & ((exe_correction!=0) | if_prediction | id_sel_pc)); // Catch any change in PC while pipeline finishes

    always@(posedge clk) begin
        if(!nrst)begin
            sel_ISR <= 0;
            ret_ISR <= 0;
            ISR_en <= 1;
            save_PC <= 12'd0;
            ISR_running <= 0;
            ISR_stall_done <= 0;
            ISR_stall_counter <= 0;
        end else begin
            if(!interrupt_signal & !sel_ISR & ISR_en) begin
                sel_ISR <= 1;
                ISR_stall_counter <= 1;
                ISR_en <= 0;
            end

            if(if_opcode==7'h73) begin
                ISR_stall_counter <= 1;
            end

            if(save_PC_en) begin
                save_PC <= PC;
            end else begin
                save_PC <= save_PC;
            end

            if(ISR_stall_counter!=0) begin
                if(ISR_stall_counter == 3'd3) begin
                    ISR_stall_counter <= 0;
                    ISR_stall_done <= 1;
                end else begin
                    if(if_clk_en)
                        ISR_stall_counter <= ISR_stall_counter+1;
                end 
            end

            if(ISR_stall_done & !ISR_running) begin
                ISR_stall_done <= 0;
                ISR_running <= 1;
                sel_ISR <= 1;
            end else if(ISR_stall_done & ISR_running) begin
                ISR_stall_done <= 0;
                ISR_running <= 0;
                ret_ISR <= 1;
            end

            if(ret_ISR) begin
                ret_ISR <= 0;
                sel_ISR <= 0;
            end
        end
    end
	
endmodule