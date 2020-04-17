//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// instmem.v -- Instruction memory module
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Author: Microlab 198 Pipelined RISC-V Group (2SAY1920)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Module Name: compressed_decoder.v
// Description: This module implements the 8kB Instruction memory used by the RISC-V core.
//				4kB each are allocated for the main instmem & ISR ROMs. Both ROMs are
//				halfword addressable for compressed instructions support.
//
// Revisions:
// Revision 0.01 - File Created
// Additional Comments:
// 
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=


`timescale 1ns / 1ps

`define MEM_DEPTH 2048
`define MEM_WIDTH 16
`define WORD_WIDTH 32

module instmem(
	input clk,
	input sel_ISR,

	input [11:0] addr,
	output [31:0] inst
);
	
	wire [`WORD_WIDTH-1:0] prog;
	wire [`WORD_WIDTH-1:0] isr;
	wire [11:0] addr_1 = addr[11:1];
    wire [11:0] addr_2 = addr[11:1] + 11'd1;

	/*
	// Instmem that uses BLOCKMEM from Vivado IP Catalog
	// Generate as DUAL port ROM
	// Synchronous read
	blk_mem_gen_instmem BLK_INST(
		.clka(~clk),
		.addra(addr_1[11:1]),
		.douta(prog[15:0]),

		.clkb(~clk),
		.addrb(addr_2[10:0]),
		.doutb(prog[31:16])
	);

	blk_mem_gen_isr BLK_ISR(
		.clka(~clk),
		.addra(addr_1[11:1]),
		.douta(isr[15:0]),

		.clkb(~clk),
		.addrb(addr_2[10:0]),
		.doutb(isr[31:16])
	);
    */

	// For this part:
	// Instmem that was coded s.t. Vivado generates an RTL_ROM
	// Asynchronous read
	reg [`MEM_WIDTH-1:0] instmem [0:`MEM_DEPTH-1];
	reg [`MEM_WIDTH-1:0] isr_mem [0:`MEM_DEPTH-1];
	initial begin
		$readmemh("instmem.mem", instmem);
		$readmemh("isr_mem.mem", isr_mem);
	end
	assign prog = {instmem[addr_2], instmem[addr_1]};
	assign isr = {isr_mem[addr_2], isr_mem[addr_1]};


	assign inst = sel_ISR? isr : prog;
endmodule