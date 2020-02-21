`timescale 1ns / 1ps

module pc(
	input clk,
	input nrst,
	input en,
	
	input [11:0] addr_in,
	
	output reg [11:0] inst_addr
);

	always@(posedge clk)
		if(!nrst)
			inst_addr <= 12'h0;
		else if(en)
			inst_addr <= addr_in;
endmodule