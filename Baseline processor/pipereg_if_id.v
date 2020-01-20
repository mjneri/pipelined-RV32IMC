`timescale 1ns / 1ps

module if_id(
	input clk,
	input nrst,

	// PC + 4
	input [11:0] if_pc4,
	output reg [11:0] id_pc4,

	// Instruction from INSTMEM
	input[31:0] if_inst,
	output reg [31:0] id_inst,

	// PC for debugging
	input [11:0] if_PC,
	output reg [11:0] id_PC
);

	always@(posedge clk) begin
		if(!nrst) begin
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