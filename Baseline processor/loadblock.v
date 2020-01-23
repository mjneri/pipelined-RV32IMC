`timescale 1ns / 1ps

module loadblock(
	// Output of DATAMEM
	input [31:0] data,

	// Control signal
	input [2:0] dm_select,

	// Output loaddata (Data to be loaded to REGFILE)
	output [31:0] loaddata
);

	// ASSUME THAT output of BLOCKRAM is always word-aligned

	/* Based on the control unit, dm_select = funct3 of the instruction
	000 = lb
	001 = lh
	010 = lw
	100 = lbu
	101 = lhu
	*/	
	parameter LB = 3'd0;
	parameter LH = 3'd1;
	parameter LW = 3'd2;
	parameter LBU = 3'd4;
	parameter LHU = 3'd5;

	assign loaddata = 	(dm_select == LB)? { {24{data[7]}}, data[7:0] } :
						(dm_select == LBU)? { 24'd0, data[7:0] } :
						(dm_select == LH)? { {16{data[15]}}, data[15:0] } :
						(dm_select == LHU)? { 16'd0, data[15:0] } :
						data[31:0];
endmodule