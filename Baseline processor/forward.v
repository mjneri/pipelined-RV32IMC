`timescale 1ns / 1ps

module forward(
	input [4:0] id_rsA,
	input [4:0] id_rsB,
    input [4:0] exe_rd,
    input [4:0] mem_rd,
    input [4:0] wb_rd,
    input exe_wr_en,
    input mem_wr_en,
    input wb_wr_en,
    input id_sel_opA,
    input id_sel_opB,

	output exe_forward_id_A,
    output exe_forward_id_B,
    output mem_forward_id_A,
    output mem_forward_id_B,
    output wb_forward_id_A,
    output wb_forward_id_B,
    
    output mem_forward_exe_A,
    output mem_forward_exe_B,
    output wb_forward_exe_A,
    output wb_forward_exe_B );

    wire exe_forward_id_A, mem_forward_id_A, wb_forward_id_A;
    wire exe_forward_id_B, mem_forward_id_B, wb_forward_id_A;

    wire mem_forward_exe_A, wb_forward_exe_A;
    wire mem_forward_exe_B, wb_forward_exe_B;

    assign exe_forward_id_A = (id_rsA == exe_rd) && (id_rsA != 0) && exe_wr_en && id_sel_opA;
    assign exe_forward_id_B = (id_rsB == exe_rd) && (id_rsB != 0) && exe_wr_en && !id_sel_opB;
    assign mem_forward_id_A = (id_rsA == mem_rd) && (id_rsA != 0) && mem_wr_en && id_sel_opA;
    assign mem_forward_id_B = (id_rsB == mem_rd) && (id_rsB != 0) && mem_wr_en && !id_sel_opB;
    assign wb_forward_id_A = (id_rsA == wb_rd) && (id_rsA != 0) && wb_wr_en && id_sel_opA;
    assign wb_forward_id_B = (id_rsB == wb_rd) && (id_rsB != 0) && wb_wr_en && !id_sel_opB;

    assign mem_forward_exe_A = 0;
    assign mem_forward_exe_B = 0;
    assign wb_forward_exe_A = 0;
    assign wb_forward_exe_B = 0;

endmodule