`timescale 1ns / 1ps

module loadblock(
	// Output of DATAMEM
	input [31:0] data,

	// ALUout[1:0]
	input [1:0] byte_offset,

	// Control signal
	input [2:0] dm_select,

	// Output loaddata (Data to be loaded to REGFILE)
	output reg [31:0] loaddata
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

	always@(*) begin
		case(dm_select)
			LB:
				case(byte_offset)
					2'd1: loaddata = { {24{data[15]}}, data[15:8] };
					2'd2: loaddata = { {24{data[23]}}, data[23:16] };
					2'd3: loaddata = { {24{data[31]}}, data[31:24] };
					default: loaddata = { {24{data[7]}}, data[7:0] };
				endcase
			LBU:
				case(byte_offset)
					2'd1: loaddata = { 24'd0, data[15:8] };
					2'd2: loaddata = { 24'd0, data[23:16] };
					2'd3: loaddata = { 24'd0, data[31:24] };
					default: loaddata = { 24'd0, data[7:0] };
				endcase
			LH:
				case(byte_offset)
					2'd2: loaddata = { {16{data[31]}}, data[31:16] };
					2'd3: loaddata = { {16{data[31]}}, data[31:16] };
					default: loaddata = { {16{data[15]}}, data[15:0] };
				endcase
			LHU:
				case(byte_offset)
					2'd2: loaddata = { 16'd0, data[31:16] };
					2'd3: loaddata = { 16'd0, data[31:16] };
					default: loaddata = { 16'd0, data[15:0] };
				endcase
			default: loaddata = data[31:0];
		endcase
	end
	
endmodule