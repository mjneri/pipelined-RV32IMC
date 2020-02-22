//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// top.v -- Container for the RISC-V Core + other modules
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Author: Microlab 198 Pipelined RISC-V Group (2SAY1920)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Module Name: top.v
// Description: This module will instantiate the required modules
//				for the project, which include the RISC-V Core, the
//				Clocking Wizard, and the Protocol Controllers.
//				The XDC file will be based on the io ports of this module
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=


`timescale 1ns / 1ps
module top(
	input CLK100MHZ,
	input nrst,

	// This will be the output of the protocol controllers
	// and will be mapped to the IO pins of the FPGA
	output UART_TX
);

// DECLARING WIRES
	wire CLKIP_OUT;			// Output of CLKIP module
	wire locked;			// determines stability of CLKIP output

	// Uncomment the following if needed:
	wire [9:0] con_addr;	// Output datamem address from protocol controllers or uartdump
	//wire [3:0] con_write;	// Write enable signal from protocol controllers or uartdump
	//wire [31:0] con_in;	// Input data to datamem from protocol controllers or uartdump
	wire [31:0] con_out;	// Output data of datamem based on con_addr

/*=== INSTANTIATING MODULES ===*/
	// Generate using LogiCORE Clocking Wizard from Vivado IP Catalog
	// PLL, Minimize Output Jitter, 50MHz output
	clk_wiz_0 CLKIP(
		.clk_in1(CLK100MHZ),
		.clk_out1(CLKIP_OUT),
		.resetn(nrst),
		.locked(locked)
	);

	// RISC-V CORE
	core RISCVCORE(
		.CLK(CLKIP_OUT),
		.nrst(nrst & locked),

		.con_write(4'h0),
		.con_addr(con_addr),
		.con_in(32'h0),

		.con_out(con_out)
	);

	// Protocol Controllers OR UART Controller
	uart_datamemdump UARTDUMP(
		.CLK(CLKIP_OUT),
		.nrst(nrst & locked),
		.con_data(con_out),

		// Outputs
		.con_addr(con_addr),
		.TX(UART_TX)
	);

endmodule