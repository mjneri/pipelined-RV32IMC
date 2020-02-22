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
	wire UART_TX;
	
	reg [3:0] btn_in;
	reg [2:0] switch_in;
	wire [3:0] LED_out;

	top TOP(
		.CLK100MHZ(CLK100MHZ),
		.nrst(nrst),
		.btn_in(btn_in),
		.switch_in(switch_in),
		.LED_out(LED_out),
		.UART_TX(UART_TX)
	);

	always
		#5 CLK100MHZ = ~CLK100MHZ;

	initial begin
		CLK100MHZ = 0;
		nrst = 0;
		btn_in = 4'b0;
		switch_in = 3'b0;
		

		#100 nrst = 1;
		#50000
		btn_in = 4'b0001;
		#2100
		btn_in = 4'b0;
		#1000000
		btn_in = 4'b0100;
		#2100
		btn_in = 4'b0;
		
		
	end
endmodule