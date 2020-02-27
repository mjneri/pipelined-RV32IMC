`timescale 1ns / 1ps

module regfile(
	input 				clk,
	input 				nrst,
	input 				wr_en,
	input		[31:0]	wr_data,
	input 		[4:0]	src1_addr,
	input 		[4:0]	src2_addr,
	input 		[4:0]	dest_addr,
	output 		[31:0] 	src1_out,
	output 		[31:0] 	src2_out
);

	reg  		[31:0]	regfile	[0:31];

	assign src1_out		= regfile[src1_addr];
	assign src2_out		= regfile[src2_addr];
   
	integer i;
	initial begin
		for(i = 0; i < 32; i = i + 1)
			regfile[i]	<=	32'd0;
	end
	
	//wire rf_clk = wr_en & !clk;
	
	// Write regfile
	always@(posedge clk)
		if(!nrst)
			for(i = 0; i < 32; i = i + 1)
				regfile[i]	<=	32'd0;
		else
			if(wr_en && (dest_addr != 5'd0))
				regfile[dest_addr]	<= wr_data;
endmodule