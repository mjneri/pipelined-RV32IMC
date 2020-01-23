`timescale 1ns / 1ps

module instmem(
	input clk,
	input		[11:0]	addr, 
	output reg	[31:0]	inst
);

	reg			[7:0]	memory	[0:4095];

	initial
		$readmemh ("instmem_parse.mem", memory);
		
	always@(posedge clk) begin
		inst <= {memory[addr + 3],
					memory[addr + 2],
					memory[addr + 1],
					memory[addr]};
	end

endmodule