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

	// FPGA I/O pins
	input [3:0] BTN,
	input [2:0] SW,
	output [3:0] LED,

	// This will be the output of the protocol controllers
	// and will be mapped to the IO pins of the FPGA
	output UART_TX
);

// DECLARING WIRES
	wire CLKIP_OUT;			// Output of CLKIP module
	wire CLK_BUF;			// Global Clock buffer output
	wire locked;			// determines stability of CLKIP output
	wire [3:0] db_btn;		// Debounced button inputs
	wire int_sig;			// Interrupt signal
	assign int_sig = (|db_btn) | (|SW);

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

	// Global clock buffer
	BUFG clk_buf(
		.I(CLKIP_OUT),
		.O(CLK_BUF)
	);


	// RISC-V CORE
	core RISCVCORE(
		.CLK(CLK_BUF),
		.nrst(nrst & locked),

		.int_sig(int_sig),
		.BTN(BTN),
		.SW(SW),
		.LED(LED),

		.con_write(4'h0),
		.con_addr(con_addr),
		.con_in(32'h0),

		.con_out(con_out)

		// Debug signals for Virtual I/O
		// .if_PC(if_PC),
		// .id_PC(id_PC),
		// .exe_PC(exe_PC),
		// .mem_PC(mem_PC),
		// .wb_PC(wb_PC),
		// .if_inst(if_inst),
		// .if_stall(if_stall),
		// .ISR_PC_flush(ISR_PC_flush),
		// .ISR_pipe_flush(ISR_pipe_flush),
		// .ISR_running(ISR_running),
		// .save_PC(save_PC),
		// .jump_flush(jump_flush),
		// .branch_flush(branch_flush),
		// .exe_is_stype(exe_is_stype),
		// .exe_dm_write(exe_dm_write),
		// .exe_ALUout(exe_ALUout),
		// .wb_sel_data(wb_sel_data),
		// .wb_wr_data(wb_wr_data)
	);

	// Protocol Controllers OR UART Controller
	uart_datamemdump UARTDUMP(
		.CLK(CLK_BUF),
		.nrst(nrst & locked),
		.con_data(con_out),

		// Outputs
		.con_addr(con_addr),
		.TX(UART_TX)
	);

	// Button debouncing
	btndebounce DEBOUNCE(
		.CLK(CLK_BUF),
		.nrst(nrst & locked),

		.btn(BTN),
		.db_btn(db_btn)
	);

	// Virtual I/O for H/W Debugging
	// vio_core VIO(
	// 	.clk(CLK_BUF),
	// 	.probe_in18(CLKIP_OUT),

	// 	.probe_in0(if_PC),
	// 	.probe_in1(id_PC),
	// 	.probe_in2(exe_PC),
	// 	.probe_in3(mem_PC),
	// 	.probe_in4(wb_PC),
	// 	.probe_in5(if_inst),
	// 	.probe_in6(if_stall),
	// 	.probe_in7(ISR_PC_flush),
	// 	.probe_in8(ISR_pipe_flush),
	// 	.probe_in9(ISR_running),
	// 	.probe_in10(save_PC),
	// 	.probe_in11(jump_flush),
	// 	.probe_in12(branch_flush),
	// 	.probe_in13(exe_is_stype),
	// 	.probe_in14(exe_dm_write),
	// 	.probe_in15(exe_ALUout),
	// 	.probe_in16(wb_sel_data),
	// 	.probe_in17(wb_wr_data)
	// );

endmodule