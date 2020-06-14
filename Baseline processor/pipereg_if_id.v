//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// pipereg_if_id.v -- IF/ID Pipeline register module
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Author: Microlab 198 Pipelined RISC-V Group (2SAY1920)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Module Name: pipereg_if_id.v
// Description:
//
// Revisions:
// Revision 0.01 - File Created
// Additional Comments:
// 
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=


`timescale 1ns / 1ps
`include "constants.vh"

module pipereg_if_id(
	input clk,
	input nrst,

	input flush,

	// PC + 4
	input [`PC_ADDR_BITS-1:0] if_pc4,
	output reg [`PC_ADDR_BITS-1:0] id_pc4,

	// Instruction from INSTMEM
	input[`WORD_WIDTH-1:0] if_inst,
	output reg [`WORD_WIDTH-1:0] id_inst,

	// PC for debugging
	input [`PC_ADDR_BITS-1:0] if_PC,
	output reg [`PC_ADDR_BITS-1:0] id_PC
);
	
	initial begin
		id_pc4 <= 0;
		id_inst <= 0;

		id_PC <= 0;
	end

	always@(posedge clk) begin
		if(!nrst || flush) begin
			id_pc4 <= 0;
			id_inst <= 0;

			id_PC <= 0;
		end
		else begin
			id_pc4 <= if_pc4;
			id_inst <= if_inst;
			
			id_PC <= if_PC;
		end
	end
endmodule