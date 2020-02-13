`timescale 1ns / 1ps
/*
    Interrupt Controller Module
*/
module interrupt_controller(
    input clk,
    input [11:0] PC,            // Input from PC module
    input [31:0] inst,          // Used to catch URET Instructionz
	input interrupt_signal,
    output ISR_stall,
	output sel_ISR,
    output ret_ISR,
    output ISR_en,
    output reg ISR_running,
    output reg [11:0] save_PC
);
    reg ISR_running;
    reg [2:0] ISR_counter;

    assign sel_ISR = interrupt_signal || ISR_running;
    assign ISR_stall = sel_ISR;
    assign ret_ISR = inst==1'd0;

    always@(posedge clk) begin
        if(interrupt_signal) begin
            save_PC <= PC;
            ISR_running <= 1;
        end else begin
            save_PC <= save_PC;
            ISR_running <= 0;
        end

        if(inst_ISR==7'h73) begin
            ISR_running <= 0;   
        end else begin
            sel_ISR <= 0;
        end

        if(ISR_stall==1'b1) begin
            if(ISR_counter==3'b101) begin
                ISR_stall <= 0;
                ISR_counter <= 3'b0; 
            end else begin
                ISR_counter <= ISR_counter + 3'b1;
            end
        end
        

    end
	
endmodule