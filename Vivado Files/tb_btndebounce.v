`timescale 1ns / 1ps
module tb_btndebounce();
	reg CLK, nrst;
	reg [3:0] btn;
	wire [3:0] db_btn;

	btndebounce UUT(
		.CLK(CLK),
		.nrst(nrst),
		.btn(btn),
		.db_btn(db_btn)
	);

	always
		#10 CLK = ~CLK;

	initial begin
		CLK = 0;
		nrst = 0;
		btn = 0;

		#100;
		nrst = 1;

		#10 btn[1] = ~btn[1];
		#20 btn[1] = ~btn[1];;
		#10 btn[1] = ~btn[1];
		#200 btn[1] = ~btn[1];
		#50 btn[1] = ~btn[1];

		#600 btn[1] = ~btn[1];
		#7 btn[1] = ~btn[1];
		#12 btn[1] = ~btn[1];
		#20 btn[1] = ~btn[1];
		#5 btn[1] = ~btn[1];
	end
endmodule