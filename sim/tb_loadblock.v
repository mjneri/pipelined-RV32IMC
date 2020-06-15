`timescale 1ns / 1ps

module tb_loadblock();
	reg [31:0] data;
	reg [1:0] byte_offset;
	reg [2:0] dm_select;
	wire [31:0] loaddata;

	loadblock uut(
		.data(data),
		.byte_offset(byte_offset),
		.dm_select(dm_select),
		.loaddata(loaddata)
	);

	// Define parameters for dm_select
	parameter LB = 3'd0;
	parameter LH = 3'd1;
	parameter LW = 3'd2;
	parameter LBU = 3'd4;
	parameter LHU = 3'd5;

	initial begin
		data = 32'h0;
		byte_offset = 2'd0;
		dm_select = 3'd0;

		// TEST LB
		$display("===| TESTING LB | ===");
		#20;
		data = 32'hade1b055;
		$strobe("DATAMEMout: 0x%X\tbyte_offset: %d\tloaddata: 0x%X", data, byte_offset, loaddata);
		#20;
		byte_offset = 2'h1;
		$strobe("DATAMEMout: 0x%X\tbyte_offset: %d\tloaddata: 0x%X", data, byte_offset, loaddata);
		#20;
		byte_offset = 2'h2;
		$strobe("DATAMEMout: 0x%X\tbyte_offset: %d\tloaddata: 0x%X", data, byte_offset, loaddata);
		#20;
		byte_offset = 2'h3;
		$strobe("DATAMEMout: 0x%X\tbyte_offset: %d\tloaddata: 0x%X", data, byte_offset, loaddata);
		#20;
		byte_offset = 2'h0;
		$strobe("DATAMEMout: 0x%X\tbyte_offset: %d\tloaddata: 0x%X", data, byte_offset, loaddata);
		#40;
		
		// TEST LBU
		$display("===| TESTING LBU | ===");
		dm_select = 3'd4;
		$strobe("DATAMEMout: 0x%X\tbyte_offset: %d\tloaddata: 0x%X", data, byte_offset, loaddata);
		#20;
		byte_offset = 2'h1;
		$strobe("DATAMEMout: 0x%X\tbyte_offset: %d\tloaddata: 0x%X", data, byte_offset, loaddata);
		#20;
		byte_offset = 2'h2;
		$strobe("DATAMEMout: 0x%X\tbyte_offset: %d\tloaddata: 0x%X", data, byte_offset, loaddata);
		#20;
		byte_offset = 2'h3;
		$strobe("DATAMEMout: 0x%X\tbyte_offset: %d\tloaddata: 0x%X", data, byte_offset, loaddata);
		#20;
		byte_offset = 2'h0;
		$strobe("DATAMEMout: 0x%X\tbyte_offset: %d\tloaddata: 0x%X", data, byte_offset, loaddata);
		#40;
		
		// TEST LH
		$display("===| TESTING LH | ===");
		dm_select = 3'd1;
		$strobe("DATAMEMout: 0x%X\tbyte_offset: %d\tloaddata: 0x%X", data, byte_offset, loaddata);
		#20;
		byte_offset = 2'h1;
		$strobe("DATAMEMout: 0x%X\tbyte_offset: %d\tloaddata: 0x%X", data, byte_offset, loaddata);
		#20;
		byte_offset = 2'h2;
		$strobe("DATAMEMout: 0x%X\tbyte_offset: %d\tloaddata: 0x%X", data, byte_offset, loaddata);
		#20;
		byte_offset = 2'h3;
		$strobe("DATAMEMout: 0x%X\tbyte_offset: %d\tloaddata: 0x%X", data, byte_offset, loaddata);
		#20;
		byte_offset = 2'h0;
		$strobe("DATAMEMout: 0x%X\tbyte_offset: %d\tloaddata: 0x%X", data, byte_offset, loaddata);
		#40;
		
		// TEST LHU
		$display("===| TESTING LHU | ===");
		dm_select = 3'd5;
		$strobe("DATAMEMout: 0x%X\tbyte_offset: %d\tloaddata: 0x%X", data, byte_offset, loaddata);
		#20;
		byte_offset = 2'h1;
		$strobe("DATAMEMout: 0x%X\tbyte_offset: %d\tloaddata: 0x%X", data, byte_offset, loaddata);
		#20;
		byte_offset = 2'h2;
		$strobe("DATAMEMout: 0x%X\tbyte_offset: %d\tloaddata: 0x%X", data, byte_offset, loaddata);
		#20;
		byte_offset = 2'h3;
		$strobe("DATAMEMout: 0x%X\tbyte_offset: %d\tloaddata: 0x%X", data, byte_offset, loaddata);
		#20;
		byte_offset = 2'h0;
		$strobe("DATAMEMout: 0x%X\tbyte_offset: %d\tloaddata: 0x%X", data, byte_offset, loaddata);
		#40;
		
		// TEST LW
		$display("===| TESTING LW | ===");
		dm_select = 3'd2;
		$strobe("DATAMEMout: 0x%X\tbyte_offset: %d\tloaddata: 0x%X", data, byte_offset, loaddata);
		#20;
		byte_offset = 2'h1;
		$strobe("DATAMEMout: 0x%X\tbyte_offset: %d\tloaddata: 0x%X", data, byte_offset, loaddata);
		#20;
		byte_offset = 2'h2;
		$strobe("DATAMEMout: 0x%X\tbyte_offset: %d\tloaddata: 0x%X", data, byte_offset, loaddata);
		#20;
		byte_offset = 2'h3;
		$strobe("DATAMEMout: 0x%X\tbyte_offset: %d\tloaddata: 0x%X", data, byte_offset, loaddata);
		#20;
		byte_offset = 2'h0;
		$strobe("DATAMEMout: 0x%X\tbyte_offset: %d\tloaddata: 0x%X", data, byte_offset, loaddata);
		#40;
		$finish;
	end

endmodule