`timescale 1ns / 1ps

module instmem(
	input clk,
	input [11:0] addr,
	input sel_ISR,
	output [31:0] inst
);
	wire [31:0] inst_mem;
	wire [31:0] inst_isr;

	// Instmem that uses BLOCKMEM from Vivado IP Catalog
	// Generate as Single port ROM
	// Synchronous read
	blk_mem_gen_instmem INSTMEM(
		.clka(~clk),
		.addra(addr[11:2]),
		.douta(inst_mem)
	);

	blk_mem_gen_isr INT_MEM(
		.clka(~clk),
		.addra(addr[7:2]),
		.douta(inst_isr)
	);

	assign inst = sel_ISR? inst_isr : inst_mem;

	// For this part:
	// Instmem that was coded s.t. Vivado generates an RTL_ROM
	// Asynchronous read
	/*reg [31:0] memory [0:1023];
	/*reg [31:0] memory [0:511];
	initial begin
		$readmemh("instmem.mem", memory);
		$readmemh("interrupt.mem", int_mem);
	end

	assign inst = sel_ISR? int_mem[addr[11:2]] :  memory[addr[11:2]];*/

endmodule