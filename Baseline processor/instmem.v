`timescale 1ns / 1ps

module instmem(
	input clk,
	input sel_ISR,

	input [11:0] addr, 
	output [31:0] inst
);
	
	wire [31:0] prog;
	wire [31:0] isr;
    wire [10:0] addr_2 = addr[11:1] + 11'd1;
    
	// Instmem that uses BLOCKMEM from Vivado IP Catalog
	// Generate as DUAL port ROM
	// Synchronous read
	blk_mem_gen_instmem BLK_INST(
		.clka(clk),
		.addra(addr[11:1]),
		.douta(prog[15:0]),

		.clkb(clk),
		.addrb(addr_2[10:0]),
		.doutb(prog[31:16])
	);

	blk_mem_gen_isr BLK_ISR(
		.clka(clk),
		.addra(addr[11:1]),
		.douta(isr[15:0]),

		.clkb(clk),
		.addrb(addr_2[10:0]),
		.doutb(isr[31:16])
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