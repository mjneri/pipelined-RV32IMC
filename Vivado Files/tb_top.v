`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/09/2020 11:27:17 PM
// Design Name: 
// Module Name: tb_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_top();

	reg CLK100MHZ, nrst;
	// reg [3:0] BTN;
	// reg [2:0] SW;
	// wire [3:0] LED;
	// wire UART_TX;
	wire ck_io0;
	reg  ck_io1;
	wire ck_io2;
	wire ck_io3;
	wire ck_io4;
	wire ck_io5;
	wire ck_io6;
	wire ck_io7;
	reg  ck_io8;
	wire ck_io38;
	wire ck_io39;

	top TOP(
		.CLK100MHZ(CLK100MHZ),
		.nrst(nrst),

		// .BTN(BTN),
		// .SW(SW),
		// .LED(LED),

		// .UART_TX(UART_TX)
		.ck_io0(ck_io0),
		.ck_io1(ck_io1),
		.ck_io2(ck_io2),
		.ck_io3(ck_io3),
		.ck_io4(ck_io4),
		.ck_io5(ck_io5),
		.ck_io6(ck_io6),
		.ck_io7(ck_io7),
		.ck_io8(ck_io8),
		.ck_io38(ck_io38),
		.ck_io39(ck_io39)
	);

	always
		#5 CLK100MHZ = ~CLK100MHZ;

	initial begin
		CLK100MHZ = 0;
		nrst = 0;
		// BTN = 0;
		// SW = 0;
		ck_io1 = 0;
		ck_io8 = 1;
		// ck_io38 = 0;
		// ck_io39 = 0;

		#100 nrst = 1;
		// #100 BTN[1] = 1;
		// #100000 nrst = 0;
		// #10000 nrst = 1;
	end
	
	// reg [11:0] mem_PC, wb_PC;
	// always@(posedge TOP.CLKIP_OUT) begin
	// 	if(!nrst) begin
	// 		mem_PC <= 0;
	// 		wb_PC <= 0;
	// 	end else begin
	// 		mem_PC <= {TOP.RISCVCORE.exe_PC, 1'b0};
	// 		wb_PC <= mem_PC;
	// 	end
	// end

	// Stimulus for the UART decoder
	reg dec_CLK = 0;						// baud rate clock for decoder input
	integer dec_counter = 0;				// counter for decoder
	always #4350 dec_CLK = ~dec_CLK;		// 115.2kHz clock
	
	always@(posedge dec_CLK) begin
		if(!nrst) dec_counter <= 0;
		else dec_counter <= dec_counter + 1;
	end

	always@(posedge dec_CLK) begin
		if(nrst /* & TOP.locked */) begin						// send only when nrst not pulled down
			// Send 0xe1dadefa (even parity, 1 stop bit)
			if(dec_counter==0) ck_io8 <= 0;					// START bit

			if(dec_counter==1) ck_io8 <= 0;			// 0xA
			if(dec_counter==2) ck_io8 <= 1;			// 0xA
			if(dec_counter==3) ck_io8 <= 0;			// 0xA
			if(dec_counter==4) ck_io8 <= 1;			// 0xA

			if(dec_counter==5) ck_io8 <= 1;			// 0xF
			if(dec_counter==6) ck_io8 <= 1;			// 0xF
			if(dec_counter==7) ck_io8 <= 1;			// 0xF
			if(dec_counter==8) ck_io8 <= 1;			// 0xF

			if(dec_counter==9) ck_io8 <= 0;			// Parity bit
			if(dec_counter==10) ck_io8 <= 1;		// Stop bit
			// ===========================================================
			if(dec_counter==11) ck_io8 <= 0;		// Start bit

			if(dec_counter==12) ck_io8 <= 0;		// 0xE
			if(dec_counter==13) ck_io8 <= 1;		// 0xE
			if(dec_counter==14) ck_io8 <= 1;		// 0xE
			if(dec_counter==15) ck_io8 <= 1;		// 0xE

			if(dec_counter==16) ck_io8 <= 1;		// 0xD
			if(dec_counter==17) ck_io8 <= 0;		// 0xD
			if(dec_counter==18) ck_io8 <= 1;		// 0xD
			if(dec_counter==19) ck_io8 <= 1;		// 0xD

			if(dec_counter==20) ck_io8 <= 0;		// Parity bit
			if(dec_counter==21) ck_io8 <= 1;		// Stop bit
			// ===========================================================
			if(dec_counter==22) ck_io8 <= 0;		// Start bit

			if(dec_counter==23) ck_io8 <= 0;		// 0xA
			if(dec_counter==24) ck_io8 <= 1;		// 0xA
			if(dec_counter==25) ck_io8 <= 0;		// 0xA
			if(dec_counter==26) ck_io8 <= 1;		// 0xA

			if(dec_counter==27) ck_io8 <= 1;		// 0xD
			if(dec_counter==28) ck_io8 <= 0;		// 0xD
			if(dec_counter==29) ck_io8 <= 1;		// 0xD
			if(dec_counter==30) ck_io8 <= 1;		// 0xD

			if(dec_counter==31) ck_io8 <= 1;		// Parity bit
			if(dec_counter==32) ck_io8 <= 1;		// Stop bit
			// ===========================================================
			if(dec_counter==33) ck_io8 <= 0;		// Start bit

			if(dec_counter==34) ck_io8 <= 1;		// 0x1
			if(dec_counter==35) ck_io8 <= 0;		// 0x1
			if(dec_counter==36) ck_io8 <= 0;		// 0x1
			if(dec_counter==37) ck_io8 <= 0;		// 0x1

			if(dec_counter==38) ck_io8 <= 0;		// 0xE
			if(dec_counter==39) ck_io8 <= 1;		// 0xE
			if(dec_counter==40) ck_io8 <= 1;		// 0xE
			if(dec_counter==41) ck_io8 <= 1;		// 0xE

			if(dec_counter==42) ck_io8 <= 0;		// Parity bit
			if(dec_counter==43) ck_io8 <= 1;		// Stop bit
		end
	end

	// For checking UART_TX output of top-level design
	// settings: 115200bps, no parity, 1 stop bit
	reg [7:0] uart_shiftreg = 0;
	reg [7:0] uart_recvd = 0;
	integer uart_counter = 0;
	reg uart_clk = 0;

	// for generating 115.2kHz clock w/ delayed start
	initial begin
		#2655 uart_clk = 1;
		forever begin
			#4350 uart_clk = ~uart_clk;
		end
	end

	// Just manually change uart_counter 'threshold' depending on expected
	// transmission length.
	// SETTINGS: 1 stop bit, even parity -> 11 bits per transaction (start, 8bit data, parity, stop)
	always@(posedge uart_clk) begin
		if(!nrst) uart_counter <= 0;
		else if(uart_counter == 11) uart_counter <= 1;
		else uart_counter <= uart_counter + 1;
	end

	always@(posedge uart_clk) begin
		if(nrst) begin
			if(uart_counter == 11) uart_shiftreg <= 0;
			else begin
				uart_shiftreg[0] <= uart_shiftreg[1];
				uart_shiftreg[1] <= uart_shiftreg[2];
				uart_shiftreg[2] <= uart_shiftreg[3];
				uart_shiftreg[3] <= uart_shiftreg[4];
				uart_shiftreg[4] <= uart_shiftreg[5];
				uart_shiftreg[5] <= uart_shiftreg[6];
				uart_shiftreg[6] <= uart_shiftreg[7];
				uart_shiftreg[7] <= ck_io7;
			end
		end
	end

	always@(posedge uart_clk) begin
		if(nrst) begin
			if(uart_counter == 9) uart_recvd <= uart_shiftreg;
		end
	end

	// For checking MOSI output of top-level design
	// NOTE: just manually change sampling edge (if posedge or negedge)
	// depending on CPHA & CPOL settings. This snippet just helps confirm MOSI.
	// Also, you need to manually change order of the shift register depending on ORD setting.
	reg [15:0] spi_shiftreg = 0;
	integer i = 0;
	always@(posedge ck_io0) begin
		for(i = 15; i > 0; i = i-1)
			spi_shiftreg[i] <= spi_shiftreg[i-1];
		spi_shiftreg[0] <= ck_io2;
	end

	// For checking I2C outputs of top-level design
	// NOTE: Data is sent MSB first. Every 9th bit is reserved for slave ACKs.
	reg SCL = 1'b1;
	reg SDA = 1'b1;
	
	always@(posedge ck_io38) SCL <= 1;
	always@(negedge ck_io38) SCL <= 0;

	always@(posedge ck_io39) SDA <= 1;
	always@(negedge ck_io39) SDA <= 0;

	reg [31:0] i2c_shiftreg = 0;
	integer i2c_counter = 0;

	always@(posedge SCL) begin
		if(!nrst) i2c_counter <= 0;
		else if(i2c_counter == 9) i2c_counter <= 1;
		else i2c_counter <= i2c_counter + 1;
	end

	// Sample the data bits only. Skip ACK bits
	always@(posedge SCL) begin
		if(nrst) begin
			if(i2c_counter != 8) begin
				for(i = 31; i > 0; i = i-1)
					i2c_shiftreg[i] <= i2c_shiftreg[i-1];
				i2c_shiftreg[0] <= SDA;
			end
		end
	end

	// Drive inout ports of the module
	assign ck_io39 = (TOP.i2c_sda_t)? 1'b1 : 1'bZ;
	assign ck_io38 = (TOP.i2c_scl_t)? 1'b1 : 1'bZ;
endmodule