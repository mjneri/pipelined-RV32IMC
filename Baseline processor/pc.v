`timescale 1ns / 1ps

module pc(
	input clk,
	input nrst,
	input en,

	input flush,
	input stall,
	
	input [11:0] addr_in,
	
	output reg [11:0] inst_addr
);
	initial begin
		inst_addr = 12'h0;
	end

	always@(posedge clk)
		if(!nrst || flush)
			inst_addr <= 12'h0;
		else if(en && !stall)
			inst_addr <= addr_in;
endmodule