`timescale 1ns/1ps

module tb_protocolcon();

	reg CLK;
	reg nrst;
	
	reg [31:0]	mem_in;			// Data from Core Datamem
	wire [10:0]	mem_addr;		// Word-aligned address
	wire [31:0]	mem_out;		// Output data to datamem
	wire [3:0]	mem_wr;
	
	// SPI
	wire sck;
	reg miso;
	wire mosi;
	wire ss0;
	wire ss1;
	wire ss2;
	wire ss3;
	
	// UART
	wire uart_enc;
	reg uart_dec;
	
	//I2C
	reg i2c_scl_i;
	reg i2c_sda_i;
	wire i2c_scl_o;
	wire i2c_scl_t;
	wire i2c_sda_o;
	wire i2c_sda_t;
	wire i2c_slave_sda_o;

	// Interrupt signal
	wire int_sig;


endmodule