`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2020 10:57:20 AM
// Design Name: 
// Module Name: tb_UART
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
module tb_uart_datamemdump();
	reg CLK, nrst;
	reg [31:0] con_data;
	
	wire [9:0] con_addr;
	wire TX;
	
	uart_datamemdump UUT(
		.CLK(CLK),
		.nrst(nrst),
		.con_data(con_data),
		
		.con_addr(con_addr),
		.TX(TX)
	);
	
	always
		#10 CLK = ~CLK;
		
	initial begin
		CLK = 0;
		nrst = 0;
		con_data = 32'h0;
		
		#100;
		// Add stimulus here
		nrst = 1;
		#20;
		con_data = 32'hade1b056;
		#200;
		con_data = 32'hade1b055;
		// #20;
		// nrst = 0;
		// #40;
		// nrst = 1;
	end
endmodule