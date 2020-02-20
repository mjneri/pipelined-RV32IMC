`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/16/2020 06:26:18 PM
// Design Name: 
// Module Name: tb_divider
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


module tb_divider();
	reg CLK;
	reg nrst;
	reg CLKEN;

	reg [31:0] divisor;
	reg divisor_valid;

	reg [31:0] dividend;
	reg dividend_valid;

	wire divisor_ready;
	wire dividend_ready;

	wire [63:0] out_tdata;
	wire out_tuser;
	wire out_valid;

	reg [15:0] cycles;

	div_gen_signed UUT(
		.s_axis_divisor_tdata(divisor),
		.s_axis_divisor_tready(divisor_ready),
		.s_axis_divisor_tvalid(divisor_valid),

		.s_axis_dividend_tdata(dividend),
		.s_axis_dividend_tready(dividend_ready),
		.s_axis_dividend_tvalid(dividend_valid),

		.aclk(CLK),
		.aclken(CLKEN),
		.aresetn(nrst),

		.m_axis_dout_tdata(out_tdata),
		//.m_axis_dout_tuser(out_tuser),
		.m_axis_dout_tvalid(out_valid)
	);

	always #10 CLK = ~CLK;

	always@(posedge CLK) begin
		if(!nrst)
			cycles <= 0;
		else
			cycles <= cycles + 1;
	end

	initial begin
		CLK = 0;
		nrst = 0;
		CLKEN = 1;

		divisor = 32'h0;
		divisor_valid = 0;
		dividend = 32'h0;
		dividend_valid = 0;

		#100;
		nrst = 1;

		#40;
		dividend = 32'd12;
		// dividend_valid = 1;

		divisor = 32'd5;
		// divisor_valid = 1;

		#20;
		dividend = 32'd100;
		divisor = -32'd6;

		dividend_valid = 1;
		divisor_valid = 1;

		#20;
		// dividend_valid = 0;
		// divisor_valid = 0;
		dividend = 32'd25;
		divisor = 32'd4;

		#20;
		dividend = 32'd204;
		divisor = 32'd12;

		#20;
		dividend = 1;
		divisor = 0;

		#20;
		dividend = 0;
		divisor = 1;

		dividend_valid = 0;
		divisor_valid = 0;

		#80;
		dividend = 100;
		divisor = 0;
		dividend_valid = 1;
		divisor_valid = 1;
		#20;
		dividend_valid = 0;
		divisor_valid = 0;
	end
endmodule