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
	always #4340.2778 dec_CLK = ~dec_CLK;	// 115.2kHz clock
	
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
endmodule