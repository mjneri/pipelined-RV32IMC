`timescale 1ns / 1ps

module instmem(
	input clk,
	input sel_ISR,

	input [11:0] addr, 
	output [31:0] inst
);
	
	wire [31:0] prog;
	wire [31:0] isr;

	// Instmem that uses BLOCKMEM from Vivado IP Catalog
	// Generate as DUAL port ROM
	// Synchronous read
	blk_mem_gen_instmem INSTMEM(
		.clka(~clk),
		.addra(addr[11:2]),
		.douta(prog)
	);

	blk_mem_gen_isr INT_MEM(
		.clka(~clk),
		.addra(addr[11:2]),
		.douta(isr)
	);

	assign inst = sel_ISR? isr : prog;

	// For this part:
	// Instmem that was coded s.t. Vivado generates an RTL_ROM
	// Asynchronous read
	/*reg [31:0] memory [0:1023];
	initial begin
		$readmemh("instmem.mem", memory);
	end

	assign inst = memory[addr[11:2]];*/

endmodule