`timescale 1ns / 1ps

module instmem(
	input clk,
	input [11:0] addr, 
	output [31:0] inst
);

	// Instmem that uses BLOCKMEM from Vivado IP Catalog
	// Generate as Single port ROM
	// Synchronous read
	blk_mem_gen_instmem BLOCKMEM(
		.clka(~clk),
		.addra(addr[11:2]),
		.douta(inst)
	);


	// For this part:
	// Instmem that was coded s.t. Vivado generates an RTL_ROM
	// Asynchronous read
	/*reg [31:0] memory [0:1023];
	initial begin
		$readmemh("instmem.mem", memory);
	end

	assign inst = memory[addr[11:2]];*/

endmodule