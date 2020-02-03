`timescale 1ns / 1ps

module tb_instmem();
	reg clk;
	reg [11:0] addr;
	wire [31:0] inst;

	instmem uut(
		.clk(clk),
		.addr(addr),
		.inst(inst)
	);

	always
		#5 clk = ~clk;

	initial begin
		clk = 0;
		addr = 12'h0;
		#10;
		addr = 12'h4;
		#10;
		addr = 12'h8;
		#10;
		addr = 12'hc;
		#10;
		addr = 12'h10;
		#10;
		addr = 12'h14;
		#10;
		addr = 12'h18;
		#10;
		$finish;
	end

endmodule