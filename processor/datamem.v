//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// datamem.v -- Data memory module
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Author: Microlab 198 Pipelined RISC-V Group (2SAY1920)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Module Name: datamem.v
// Description: This module contains the Block Memory Generator IP Modules needed
//				to implement a ~4kB memory for the RISCV processor.
//				Block Memory Generator IP settings for both modules:
//					- Native Interface, True DUAL PORT RAM
//					- Byte write enabled (8bits per byte)
//					- common clock &  generate address unchecked
//					- minimum area algorithm
//					PORT settings (both port a & b)
//						- 32bit write & read width, 1024 write & read depth
//						- Read First operating mode, Always Enabled
//						- checkboxes left unchecked
//					
//
// Revisions:
// Revision 0.01 - File Created
// Additional Comments:
// 
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=


`timescale 1ns / 1ps
`include "constants.vh"

module datamem(
	input core_clk,				// Gated clock signal
	input con_clk,				// un-gated clock signal
	input nrst,

	// Inputs from the RISCV core
	input [3:0] dm_write,
	input [`DATAMEM_BITS-1:0] data_addr,
	input [`DATAMEM_WIDTH-1:0] data_in,

	// Inputs from protocol controllers
	// NOTE: protocol controllers cannot read from FPGAIO
	input [3:0] con_write,				// Similar to dm_write
	input [`DATAMEM_BITS-1:0] con_addr,	// datamem address from protocol controller
	input [`DATAMEM_WIDTH-1:0] con_in,	// data input from protocol controller

	// Outputs
	output [`DATAMEM_WIDTH-1:0] data_out,	// data output to the RISC-V core
	output [`DATAMEM_WIDTH-1:0] con_out		// data output to protocol controller
);
	
	// Block memory outputs
	wire [`DATAMEM_WIDTH-1:0] coremem_douta, coremem_doutb;
	wire [`DATAMEM_WIDTH-1:0] protocolmem_douta, protocolmem_doutb;

	// Determine which blockmem output to select
	// If x_sel = 1, select PROTOCOLMEM output, else select COREMEM output
	wire core_sel = data_addr[10];
	wire protocol_sel = con_addr[10];

	// Datamem that uses BLOCKMEM from Vivado IP Catalog
	// Blockmem generated as TRUE DUAL PORT RAM
	// Synchronous read
	// Addresses 0x000 - 0x3FF (Word-aligned addresses)
	blk_mem_gen_datamem COREMEM(
		.clka(core_clk),
		.wea(dm_write),
		.addra(data_addr[9:0]),
		.dina(data_in),
		.douta(coremem_douta),

		.clkb(con_clk),
		.web(4'b0),
		.addrb(con_addr[9:0]),
		.dinb(32'b0),
		.doutb(coremem_doutb)
	);

	// Addresses 0x400 - 0x40F	(Word-aligned addresses)
	blk_mem_gen_protocol PROTOCOLMEM(
		.clka(core_clk),
		.wea(4'b0),
		.addra(data_addr[3:0]),
		.dina(32'b0),
		.douta(protocolmem_douta),

		.clkb(con_clk),
		.web(con_write),
		.addrb(con_addr[3:0]),
		.dinb(con_in),
		.doutb(protocolmem_doutb)
	);

	// Assigning data_out for the Core
	reg core_sel_reg = 0;
	always@(posedge core_clk) begin
		if(!nrst) core_sel_reg <= 0;
		else core_sel_reg <= core_sel;
	end
	assign data_out = core_sel_reg? protocolmem_douta : coremem_douta;

	// Assigning con_out
	reg protocol_sel_reg = 0;
	always@(posedge con_clk) begin
		if(!nrst) protocol_sel_reg <= 0;
		else protocol_sel_reg <= protocol_sel;
	end
	assign con_out = protocol_sel_reg? protocolmem_doutb : coremem_doutb;
endmodule