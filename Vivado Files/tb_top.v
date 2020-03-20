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
	reg [3:0] BTN;
	reg [2:0] SW;
	wire [3:0] LED;
	wire UART_TX;

	top TOP(
		.CLK100MHZ(CLK100MHZ),
		.nrst(nrst),

		.BTN(BTN),
		.SW(SW),
		.LED(LED),

		.UART_TX(UART_TX)
	);

	always
		#5 CLK100MHZ = ~CLK100MHZ;

	initial begin
		CLK100MHZ = 0;
		nrst = 0;
		BTN = 0;
		SW = 0;

		#100 nrst = 1;
		#100 BTN[1] = 1;
	end
	
	reg [11:0] mem_PC, wb_PC;
	always@(posedge TOP.CLKIP_OUT) begin
		if(!nrst) begin
			mem_PC <= 0;
			wb_PC <= 0;
		end else begin
			mem_PC <= {TOP.RISCVCORE.exe_PC, 1'b0};
			wb_PC <= mem_PC;
		end
	end
endmodule