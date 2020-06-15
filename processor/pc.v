//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// pc.v -- Program counter module
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Author: Microlab 198 Single-cycle RISC-V Group (2SAY1819)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Module Name: pc.v
// Description:
//
// Revisions:
// Revision 0.01 - File Created
// Revision 1.00 - File modified by Pipelined RISC-V Group (2SAY1920)
// Additional Comments:
// 
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=


`timescale 1ns / 1ps

`include "constants.vh"
module pc(
	input clk,
	input nrst,

	input flush,
	
	input [`PC_ADDR_BITS-1:0] addr_in,
	
	output reg [`PC_ADDR_BITS-1:0] inst_addr
);
	initial begin
		inst_addr = 0;
	end

	always@(posedge clk)
		if(!nrst || flush)
			inst_addr <= 0;
		else
			inst_addr <= addr_in;
endmodule