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
	output reg sel_ISR,
    output reg ret_ISR,
    output reg ISR_en,
    output reg ISR_stall,
    output reg [11:0] save_PC
);
    wire save_PC_en;
    assign save_PC_en = sel_ISR & ISR_stall & exe_correction & if_prediction & id_sel_pc;

    reg [2:0] ISR_counter;

    always@(posedge clk) begin
        if(!nrst)begin
            sel_ISR <= 0;
            ret_ISR <= 0;
            ISR_en <= 0;
            ISR_stall <= 0;
            save_PC <= 12'd0;
            counter <= 0;
        end else begin
            if(!interrupt_signal & !sel_ISR) begin
                sel_ISR <= 1;
                ISR_stall <= 1;
            end

            if(if_opcode==7'h73) begin
                sel_ISR <= 0;
                ret_ISR <= 1;
                ISR_stall <= 1;
            end else begin
                ret_ISR <= 0;
            end

            if(save_PC_en) begin
                save_PC <= PC;
            end else begin
                save_PC <= save_PC;
            end

            if(ISR_stall) begin
                if(counter == 3'd5) begin
                    ISR_stall <= 0;
                    ISR_counter <= 0;
                end else begin
                    ISR_counter <= _ISRcounter+1;
                end
            end
        end

    end
	
endmodule