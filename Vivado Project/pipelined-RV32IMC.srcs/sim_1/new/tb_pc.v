`timescale 1ns / 1ps

module tb_pc();
	
	reg clk;
	reg nrst;
	reg [11:0] addr_in;
	wire [11:0] inst_addr;

	pc uut(
		.clk(clk),
		.nrst(nrst),
		.addr_in(addr_in),
		.inst_addr(inst_addr)
	);

	// Test using 100MHz clock
	always
		#5 clk = ~clk;

	initial begin
		clk = 0;
		nrst = 0;
		addr_in = 12'h4;

		#100;
		nrst = 1;
		#10;
		addr_in = 12'h8;
		#10;
		addr_in = 12'hc;
		#10;
		addr_in = 12'h10;
		#5;
		nrst = 0;
		#5;
		addr_in = 12'h4;
	end

endmodule