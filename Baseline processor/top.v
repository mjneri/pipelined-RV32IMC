`timescale 1ns / 1ps

/*
	This module will instantiate the required modules
	for the project, which include the RISC-V Core, the
	Clocking Wizard, and the Protocol Controllers.
*/

module top(
	input CLK100MHZ,
	input nrst,

	// This will be the output of the protocol controllers
	// and will be mapped to the IO pins of the FPGA
	output [3:0] ck_io
);

endmodule