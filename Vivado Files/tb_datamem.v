`timescale 1ns / 1ps

module tb_datamem();
	
	reg clk;
	reg [3:0] dm_write;
	reg [9:0] data_addr;
	reg [31:0] data_in;
	wire [31:0] data_out;
	
	datamem uut(
		.clk(clk),
		.dm_write(dm_write),
		.data_addr(data_addr),
		.data_in(data_in),
		.data_out(data_out)
	);
	

	always
		#5 clk = ~clk;
	
	initial begin
		$display("BEFORE WRITES:");
		$display("0x%X: %X", 10'h0, uut.memory[10'h0]);
		$display("0x%X: %X", 10'h1, uut.memory[10'h1]);
		$display("0x%X: %X", 10'h2, uut.memory[10'h2]);
		$display("0x%X: %X", 10'h3, uut.memory[10'h3]);
		$display("0x%X: %X", 10'h4, uut.memory[10'h4]);
		$display("0x%X: %X", 10'h5, uut.memory[10'h5]);
		$display("0x%X: %X", 10'h6, uut.memory[10'h6]);
		$display("=================================");

		clk = 0;
		dm_write = 0;
		data_addr = 10'h0;
		data_in = 32'h0;

		// Test read
		#20;
		data_addr = 10'h1;
		#20;
		data_addr = 10'h2;
		#20;
		data_addr = 10'h3;
		#40;
		
		// Test write
		// SB
		dm_write = 4'b0001;
		data_addr = 10'h0;
		data_in = 32'hc1c1c1c1;
		#20;
		dm_write = 4'b0010;
		data_addr = 10'h1;
		data_in = 32'hc1c1c1c1;
		#20;
		dm_write = 4'b0100;
		data_addr = 10'h2;
		data_in = 32'hc1c1c1c1;
		#20;
		dm_write = 4'b1000;
		data_addr = 10'h3;
		data_in = 32'hc1c1c1c1;
		
		// SH
		#20;
		dm_write = 4'b0011;
		data_addr = 10'h4;
		data_in = 32'hc1c1c1c1;
		#20;
		dm_write = 4'b1100;
		data_addr = 10'h5;
		data_in = 32'hc1c1c1c1;
		
		// SW
		#20;
		dm_write = 4'b1111;
		data_addr = 10'h6;
		data_in = 32'hc1c1c1c1;
		#20;

		$display("AFTER WRITES:");
		$display("0x%X: %X", 10'h0, uut.memory[10'h0]);
		$display("0x%X: %X", 10'h1, uut.memory[10'h1]);
		$display("0x%X: %X", 10'h2, uut.memory[10'h2]);
		$display("0x%X: %X", 10'h3, uut.memory[10'h3]);
		$display("0x%X: %X", 10'h4, uut.memory[10'h4]);
		$display("0x%X: %X", 10'h5, uut.memory[10'h5]);
		$display("0x%X: %X", 10'h6, uut.memory[10'h6]);
		$display("=================================");

		$finish;
	end

endmodule