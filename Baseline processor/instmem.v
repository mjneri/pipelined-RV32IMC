`timescale 1ns / 1ps

module instmem(
	input clk,
	input [11:0] addr, 
	output [31:0] inst
);

	// Instmem that uses BLOCKMEM from Vivado IP Catalog
	// Generate as Single port ROM
	// Synchronous read
	wire [10:0] addr_2 = addr[11:1] + 11'd1;

	blk_mem_gen_instmem BLOCKMEM(
		.clka(~clk),
		.addra({addr[11:1]}),
		.douta(inst[15:0]),
		.ena(1'b1),
		.clkb(~clk),
		.addrb({addr_2[10:0]}),
		.doutb(inst[31:16]),
		.enb(1'b1)
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