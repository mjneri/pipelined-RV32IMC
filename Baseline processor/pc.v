`timescale 1ns / 1ps

module pc(
	input				clk,
	input				nrst,
	input				en,
	
	input		[11:0]	addr_in,
	
	output reg	[11:0]	inst_addr
);

	always@(posedge clk)
		inst_addr	<=	!nrst	?	12'h0 	:	// Reset
						en		?	addr_in :
									inst_addr;
endmodule