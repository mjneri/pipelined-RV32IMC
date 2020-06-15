//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// regfile.v -- Register file module
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Author: Microlab 198 Single-cycle RISC-V Group (2SAY1819)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Module Name: regfile.v
// Description:
//
// Revisions:
// Revision 0.01 - File Created
// Revision 1.00 - Modified by Pipelined RISC-V Group (2SAY1920) to include constants.vh
// Additional Comments:
// 
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=


`timescale 1ns / 1ps
`include "constants.vh"

module regfile(
	input 							clk,
	input 							nrst,
	input 							wr_en,
	input		[`WORD_WIDTH-1:0]	wr_data,
	input 		[`REGFILE_BITS-1:0]	src1_addr,
	input 		[`REGFILE_BITS-1:0]	src2_addr,
	input 		[`REGFILE_BITS-1:0]	dest_addr,
	output 		[`WORD_WIDTH-1:0] 	src1_out,
	output 		[`WORD_WIDTH-1:0] 	src2_out
);

	reg [`WORD_WIDTH-1:0] regfile [0:`REGFILE_SIZE-1];

	assign src1_out = regfile[src1_addr];
	assign src2_out = regfile[src2_addr];
   
	integer i;
	initial begin
		for(i = 0; i < `REGFILE_SIZE; i = i + 1)
			regfile[i]	=	0;
	end
	
	// Write regfile
	always@(posedge clk)
		if(!nrst)
			for(i = 0; i < `REGFILE_SIZE; i = i + 1)
				regfile[i]	<=	0;
		else
			if(wr_en && (dest_addr != 5'd0))
				regfile[dest_addr]	<= wr_data;
endmodule