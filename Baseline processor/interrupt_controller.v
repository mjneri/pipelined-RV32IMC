`timescale 1ns / 1ps
/*
    Interrupt Controller Module
*/
module interrupt_controller(
    input clk,
    input [31:0] PC,
    input [31:0] inst_ISR,
	input interrupt_signal,
    output ISR_stall,
	output sel_ISR,
    output ret_ISR,
    output stall_ISR,
    output ISR_en,
    output [31:0] new_PC
);
    reg [31:0] save_PC;
    reg ISR_running;

    assign sel = interrupt_signal || ISR_running;
    assign sel_ISR = 

    always@(posedge clk) begin
        if(interrupt_signal) begin
            save_PC <= PC;
            ISR_running <= 1;
        end else begin
            save_PC <= save_PC;
            ISR_running <= 0;
        end

        if(inst_ISR==1'd0) begin
            new_PC <= save_PC;
            ISR_running <= 0;    
        end else begin
            new_PC <= PC;
            sel_ISR <= 0;
        end
    end
	
endmodule