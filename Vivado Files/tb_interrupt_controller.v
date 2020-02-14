`timescale 1ns / 1ps

module tb_interrupt_controller();
    reg clk, nrst;

    reg [11:0] PC;
    reg [6:0] if_opcode;
    reg interrupt_signal;
    reg [1:0] exe_correction;
    reg if_prediction;
    reg id_sel_pc;

    wire sel_ISR;
    wire ret_ISR;
    wire ISR_en;
    wire ISR_stall;
    wire [11:0] save_PC;

    interrupt_controller UUT(
        .clk(clk),
        .nrst(nrst),
        .PC(PC),
        .if_opcode(if_opcode),
        .interrupt_signal(interrupt_signal),
        .exe_correction(exe_correction),
        .if_prediction(if_prediction),
        .id_sel_pc(id_sel_pc),
        .sel_ISR(sel_ISR),
        .ret_ISR(ret_ISR),
        .ISR_en(ISR_en),
        .ISR_stall(ISR_stall),
        .save_PC(save_PC)
    );


    always
		#5 CLK = ~CLK;

    initial begin
      
      
    end

endmodule