`timescale 1ns / 1ps

module tb_interrupt_controller();
    reg clk, nrst;

    reg [11:0] PC;
    reg [6:0] if_opcode;
    reg interrupt_signal;
    reg [1:0] exe_correction;
    reg if_prediction;
    reg id_sel_pc;
    reg if_clk_en,

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
        .if_clk_en(if_clk_en)
        .sel_ISR(sel_ISR),
        .ret_ISR(ret_ISR),
        .ISR_en(ISR_en),
        .ISR_stall(ISR_stall),
        .save_PC(save_PC)
    );



    task test_int();
        //  control signals input
        input [11:0] pc;
        input [6:0] if_opcd;
        input int_sig;
        input [1:0] exe_corr;
        input if_pred;
        input id_selpc;
        input if_clken;


        begin
            $strobe("PC: %D, OPCODE: %X, interrupt_signal: %D, exe_corr: %X, if_prediction: %D, id_sel_pc: %D, if_clk_en: %D", pc, if_opcd, int_sig, exe_corr, if_pred, id_selpc, if_clken);
            $strobe("\nsel_ISR: %D, ret_ISR: %D, ISR_en: %D, ISR_stall: %D, save_PC: %X", sel_ISR, ret_ISR, ISR_en, ISR_stall, save_PC);
        end

        

    endtask

    always
	    	#5 CLK = ~CLK;

    initial begin
        #20 test_int($random%12, $random%7, $random%1, $random%2, $random%1, $random%1, $random%1);
        #20 test_int($random%12, $random%7, $random%1, $random%2, $random%1, $random%1, $random%1);
        #20 test_int($random%12, $random%7, $random%1, $random%2, $random%1, $random%1, $random%1);
        #20 test_int($random%12, $random%7, $random%1, $random%2, $random%1, $random%1, $random%1);
        $finish
      
    end

endmodule