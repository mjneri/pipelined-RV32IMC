`timescale 1ns / 1ps

/*
	This module will instantiate the required modules
	for the project, which include the RISC-V Core, the
	Clocking Wizard, and the Protocol Controllers.
	The XDC file will be based on the io ports of this module
*/

module top(
	input CLK100MHZ,
	input nrst,
	//input SW,

	input [3:0] btn_in,
	input [2:0] switch_in,

	// This will be the output of the protocol controllers
	// and will be mapped to the IO pins of the FPGA
	output [3:0] LED_out,
	output UART_TX
);

//-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-//
//				DECLARING WIRES					//
//-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-//

	wire CLKIP_OUT;			// Output of CLKIP module
	wire locked;			// determines stability of CLKIP output
	wire [3:0] db_btn;		// Debounced button inputs
	wire int_sig;			// Interrupt signal

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
        	.int_sig(!int_sig),

		.btn_in(db_btn),
		.switch_in(switch_in),

		.con_write(4'h0),
		.con_addr(con_addr),
		.con_in(32'h0),

		.con_out(con_out),
		.LED_out(LED_out)
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

	// Button debouncing
	btndebounce DEBOUNCE(
		.CLK(CLKIP_OUT),
		.nrst(nrst & locked),

		.btn(btn_in),
		.db_btn(db_btn)
	);

	// interrupt signal
	assign int_sig = (|db_btn | |switch_in);	//add debounce to button

endmodule