`timescale 1ns / 1ps

module tb_regfile();
	
	reg clk, nrst, wr_en;
	reg [31:0] wr_data;
	reg [4:0] src1_addr, src2_addr, dest_addr;
	wire [31:0] src1_out, src2_out;

	regfile uut(
		.clk(clk),
		.nrst(nrst),
		.wr_en(wr_en),
		.wr_data(wr_data),
		.src1_addr(src1_addr),
		.src2_addr(src2_addr),
		.dest_addr(dest_addr),
		.src1_out(src1_out),
		.src2_out(src2_out)
	);

	// Test using 100MHz clock
	always
		#5 clk = ~clk;

	initial begin
		clk = 0;
		nrst = 0;
		wr_en = 0;
		wr_data = 0;
		src1_addr = 0;
		src2_addr = 0;
		dest_addr = 0;

		// Test WRITE
		$display("\n===| Test writes to RF |===");
		#100;
		nrst = 1;
		#15;
		wr_en = 1;
		dest_addr = 32'd0;
		wr_data = 32'hade1b055;
		$strobe("wr_en: %d\tdest_addr: 0x%X\twr_data: 0x%X", wr_en, dest_addr, wr_data);
		$strobe("dest_addr: 0x%X\tcontents: 0x%X\n", dest_addr, uut.regfile[dest_addr]);
		#10;
		wr_en = 0;
		$strobe("wr_en: %d\tdest_addr: 0x%X\twr_data: 0x%X", wr_en, dest_addr, wr_data);
		$strobe("dest_addr: 0x%X\tcontents: 0x%X\n", dest_addr, uut.regfile[dest_addr]);
		#10;
		dest_addr = 32'd1;
		$strobe("wr_en: %d\tdest_addr: 0x%X\twr_data: 0x%X", wr_en, dest_addr, wr_data);
		$strobe("dest_addr: 0x%X\tcontents: 0x%X\n", dest_addr, uut.regfile[dest_addr]);
		#10;
		wr_en = 1;
		$strobe("wr_en: %d\tdest_addr: 0x%X\twr_data: 0x%X", wr_en, dest_addr, wr_data);
		$strobe("dest_addr: 0x%X\tcontents: 0x%X\n", dest_addr, uut.regfile[dest_addr]);
		#10;
		wr_en = 0;
		$strobe("wr_en: %d\tdest_addr: 0x%X\twr_data: 0x%X", wr_en, dest_addr, wr_data);
		$strobe("dest_addr: 0x%X\tcontents: 0x%X\n", dest_addr, uut.regfile[dest_addr]);
		#10;
		dest_addr = 32'd10;
		$strobe("wr_en: %d\tdest_addr: 0x%X\twr_data: 0x%X", wr_en, dest_addr, wr_data);
		$strobe("dest_addr: 0x%X\tcontents: 0x%X\n", dest_addr, uut.regfile[dest_addr]);
		#10;
		wr_en = 1;
		$strobe("wr_en: %d\tdest_addr: 0x%X\twr_data: 0x%X", wr_en, dest_addr, wr_data);
		$strobe("dest_addr: 0x%X\tcontents: 0x%X\n", dest_addr, uut.regfile[dest_addr]);
		#10;
		wr_en = 0;
		$strobe("wr_en: %d\tdest_addr: 0x%X\twr_data: 0x%X", wr_en, dest_addr, wr_data);
		$strobe("dest_addr: 0x%X\tcontents: 0x%X\n", dest_addr, uut.regfile[dest_addr]);

		// Test READ
		// written to registers: x1, x10
		#20;
		$display("\n===| Test reads on RF |===");
		#20;
		src1_addr = 32'd1;
		src2_addr = 32'd10;
		$strobe("src1_addr: 0x%X\tsrc2_addr: 0x%X", src1_addr, src2_addr);
		$strobe("src1_data: 0x%X\tsrc2_data: 0x%X", uut.regfile[src1_addr], uut.regfile[src2_addr]);
		#20;
		src1_addr = 32'd0;
		src2_addr = 32'd11;
		$strobe("src1_addr: 0x%X\tsrc2_addr: 0x%X", src1_addr, src2_addr);
		$strobe("src1_data: 0x%X\tsrc2_data: 0x%X", uut.regfile[src1_addr], uut.regfile[src2_addr]);
		#40;
		$finish;
	end

endmodule