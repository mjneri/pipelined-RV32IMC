`timescale 1ns / 1ps

module forward(
	input [4:0] id_rsA,
	input [4:0] id_rsB,
    input [4:0] exe_rd,
    input [4:0] mem_rd,
    input exe_wr_en,
    input mem_wr_en,

	output exe_forward_A,
    output exe_forward_B,
    output mem_forward_A,
    output mem_forward_B );

wire exe_forward_A, mem_forward_A;
wire exe_forward_B, mem_forward_B;

assign exe_forward_A = (id_rsA == exe_rd) && (id_rsA != 0) && exe_wr_en;
assign exe_forward_B = (id_rsB == exe_rd) && (id_rsB != 0) && exe_wr_en;
assign mem_forward_A = (id_rsA == mem_rd) && (id_rsA != 0) && mem_wr_en;
assign mem_forward_B = (id_rsB == mem_rd) && (id_rsB != 0) && mem_wr_en;

endmodule