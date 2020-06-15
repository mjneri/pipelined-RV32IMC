//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// top.v -- Container for the RISC-V Core + other modules
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Author: Microlab 198 Pipelined RISC-V Group (2SAY1920)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Module Name: top.v
// Description: This module instantiates the required modules
//				for the project, which include the RISC-V Core, the
//				Clocking Wizard, and the Protocol Controllers.
//				The XDC file is based on the IO ports of this module
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=


`timescale 1ns / 1ps

`include "constants.vh"

module top(
	input CLK100MHZ,
	input nrst,

	// Protocol controller related I/O
	output ck_io0,		// SCK
	input ck_io1,		// MISO
	output ck_io2,		// MOSI
	output ck_io3,		// SS0
	output ck_io4,		// SS1
	output ck_io5,		// SS2
	output ck_io6,		// SS3

	output ck_io7,		// UART_ENC
	input ck_io8,		// UART_DEC

	inout ck_io38,		// Tristate buffer/I2C SCL
	inout ck_io39		// Tristate buffer/I2C SDA
);

// DECLARING WIRES
	wire CLKIP_OUT;			// Output of CLKIP module
	wire CLK_BUF;			// Global Clock buffer output
	wire CLKFB;				// CLKIP Feedback
	wire CLKFB_BUF;			// CLKFB buffer output
	wire locked;			// determines stability of CLKIP output
	
	// Interrupt signals
	wire [`INT_SIG_WIDTH-1:0] int_sig;

	// Uncomment the following if needed:
	wire [`DATAMEM_BITS-1:0] con_addr;		// Output datamem address from protocol controllers
	wire [3:0] con_write;					// Write enable signal from protocol controllers
	wire [`DATAMEM_WIDTH-1:0] con_in;		// Input data to datamem from protocol controllers
	wire [`DATAMEM_WIDTH-1:0] con_out;		// Output data of datamem based on con_addr

	// Wires for the protocol controllers (based on top_tb.v from Single-cycle RV32IC)
	// I2C
	wire i2c_scl_i;					// SCL from slave device
	wire i2c_sda_i;					// SDA from slave device
	wire i2c_scl_o;					// SCL from master
	wire i2c_scl_t;					// SCL Tristate buffer control
	wire i2c_sda_o;					// SDA from master
	wire i2c_sda_t;					// SDA Tristate buffer control
	wire i2c_slave_sda_o;			// ????????????????

	// Tristate buffers for I2C
	assign i2c_scl_i = ck_io38;
	assign ck_io38 = i2c_scl_t? 1'bZ : i2c_scl_o;

	assign i2c_sda_i = ck_io39;
	assign ck_io39 = (i2c_sda_t & i2c_slave_sda_o)? 1'bZ : i2c_sda_o;

	// SPI
	wire sck;		assign ck_io0 = sck;
	wire miso;		assign miso = ck_io1;
	wire mosi;		assign ck_io2 = mosi;
	wire ss0;		assign ck_io3 = ss0;
	wire ss1;		assign ck_io4 = ss1;
	wire ss2;		assign ck_io5 = ss2;
	wire ss3;		assign ck_io6 = ss3;

	// UART/Decoder + Encoder
	wire uart_enc;	assign ck_io7 = uart_enc;
	wire uart_dec;	assign uart_dec = ck_io8;

/*=== INSTANTIATING MODULES ===*/
	// Generate using LogiCORE Clocking Wizard from Vivado IP Catalog
	// MMCM, Minimize Power, Drive No Buffer, 50MHz output
	clk_wiz_0 CLKIP(
		.clk_in1(CLK100MHZ),
		.clk_out1(CLKIP_OUT),
		.locked(locked),
		.clkfb_in(CLKFB_BUF),
		.clkfb_out(CLKFB)
	);

	// Global clock buffer
	BUFG clk_buf(
		.I(CLKIP_OUT),
		.O(CLK_BUF)
	);

	// Feedback clock buffer
	BUFG clkfb_buf(
		.I(CLKFB),
		.O(CLKFB_BUF)
	);


	// RISC-V CORE
	core RISCVCORE(
		.CLKIP_OUT(CLKIP_OUT),
		.CLK_BUF(CLK_BUF),
		.nrst(nrst & locked),

		.int_sig(int_sig),

		.con_write(con_write),
		.con_addr(con_addr),
		.con_in(con_in),

		.con_out(con_out)
	);

	// Protocol controllers
	mcont PROTOCOL_CON(
		.clk(CLK_BUF),
		.nrst(nrst & locked),

		.mem_in(con_out),
		.mem_addr(con_addr),
		.mem_out(con_in),
		.mem_wr(con_write),

		// SPI pins
		.sck(sck),
		.miso(miso),
		.mosi(mosi),
		.ss0(ss0),
		.ss1(ss1),
		.ss2(ss2),
		.ss3(ss3),
		
		// UART pins
		.uart_enc(uart_enc),
		.uart_dec(uart_dec),
		
		// I2C pins
		.i2c_scl_i(i2c_scl_i),
		.i2c_sda_i(i2c_sda_i),
		.i2c_scl_o(i2c_scl_o),
		.i2c_scl_t(i2c_scl_t),
		.i2c_sda_o(i2c_sda_o),
		.i2c_sda_t(i2c_sda_t),
		.i2c_slave_sda_o(i2c_slave_sda_o),
		
		// Interrupts
		.int_sig(int_sig)
	);

	// For Vivado ILA Capture control; Remove if not needed
	// (* dont_touch = "yes" *) reg [31:0] ila_ctr = 0;
	// always@(posedge CLK_BUF) begin
	// 	if(nrst & locked) ila_ctr <= ila_ctr + 1;
	// 	else ila_ctr <= 0;
	// end

endmodule