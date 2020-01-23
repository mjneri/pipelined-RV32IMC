`timescale 1ns / 1ps

module loadblock(
	// Output of DATAMEM
	input [31:0] data,

	// ALUout[1:0]
	input [1:0] byte_offset,

	// Control signal
	input [2:0] dm_select,

	// Output loaddata (Data to be loaded to REGFILE)
	output [31:0] loaddata
);

	/*Output of BLOCKRAM DATAMEM is ALWAYS word-aligned
	LOADBLOCK determines (depending if instruction is LB/LH)
	whether the data needs to be shifted*/

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

	assign loaddata = 	(dm_select == LB)? (
							(byte_offset == 2'd1)? { {24{data[15]}}, data[15:8] } :
							(byte_offset == 2'd2)? { {24{data[23]}}, data[23:16] } :
							(byte_offset == 2'd3)? { {24{data[31]}}, data[31:24] } :
							{ {24{data[7]}}, data[7:0] } )					:

						(dm_select == LBU)? (
							(byte_offset == 2'd1)? { 24'd0, data[15:8] } 	:
							(byte_offset == 2'd2)? { 24'd0, data[23:16] } 	:
							(byte_offset == 2'd3)? { 24'd0, data[31:24] } 	:
							{ 24'd0, data[7:0] } )							:

						(dm_select == LH)? (
							(byte_offset == 2'd2)? { {16{data[31]}}, data[31:16] } :
							{ {16{data[15]}}, data[15:0] }	)				:

						(dm_select == LHU)? (
							(byte_offset == 2'd2)? { 16'd0, data[31:16] } 	:
							{ 16'd0, data[15:0] }	)						:

						data[31:0];
endmodule