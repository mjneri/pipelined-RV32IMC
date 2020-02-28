`timescale 1ns / 1ps

module datamem(
	input clk,
	input nrst,

	// Inputs from within the core
	input [3:0] dm_write,
	input [10:0] data_addr,
	input [31:0] data_in,

	// Ports for FPGA I/O
	input [3:0] BTN,
	input [2:0] SW,
	output [3:0] LED,

	// Inputs from protocol controllers
	// NOTE: protocol controllers cannot read from FPGAIO
	input [3:0] con_write,		// Similar to dm_write
	input [9:0] con_addr,		// datamem address from protocol controller
	input [31:0] con_in,		// data input from protocol controller

	output reg [31:0] data_out,	// data output to the RISC-V core
	output [31:0] con_out		// data output to protocol controller
);
	
	// Datamem that uses BLOCKMEM from Vivado IP Catalog
	// Blockmem generated as TRUE DUAL PORT RAM
	// Synchronous read
	// Addresses 0x000 - 0x3FF (Word-aligned addresses)
	wire [31:0] blk_mem_douta;
	blk_mem_gen_datamem BLOCKMEM(
		.clka(~clk),
		.wea(dm_write),
		.addra(data_addr[9:0]),
		.dina(data_in),
		.douta(blk_mem_douta),

		.clkb(~clk),
		.web(con_write),
		.addrb(con_addr),
		.dinb(con_in),
		.doutb(con_out)
	);
	
	// Memory mapping FPGA I/O to registers. (Directly mapped to registers)
	// Word-aligned Addresses:
	// 0x400 -> BUTTONS (FPGAIO[0])	\\ Input from BUTTONS
	// 0x401 -> SWITCHES (FPGAIO[1])\\ Input from SWITCHES
	// 0x402 -> LEDs (FPGAIO[2])	\\ Input from RISC-VCore
	reg [31:0] FPGAIO [0:2];
	integer i;
	initial begin
		for(i = 0; i < 3; i=i+1)
			FPGAIO[i] <= 0;
	end

	// Writes to FPGAIO[1:0] (BTN, SW)
	always@(posedge clk) begin
		if(!nrst) begin
			FPGAIO[1] <= 32'h0;
			FPGAIO[0] <= 32'h0;
		end else begin
			FPGAIO[1] <= {29'h0, SW};
			FPGAIO[0] <= {28'h0, BTN};
		end
	end

	// Reads & Writes to FPGAIO[2] (LEDs)
	assign LED = FPGAIO[2][3:0];
	always@(posedge clk) begin
		if(!nrst)
			FPGAIO[2] <= 0;
		else begin
			if(data_addr == 11'h402) begin
				case(dm_write)
					// SW
					4'b1111: FPGAIO[2] <= data_in;

					// SH
					4'b0011: FPGAIO[2] <= (FPGAIO[2] & 32'hffff0000) | (data_in & 32'h0000ffff);
					4'b1100: FPGAIO[2] <= (FPGAIO[2] & 32'h0000ffff) | (data_in & 32'hffff0000);

					// SB
					4'b0001: FPGAIO[2] <= (FPGAIO[2] & 32'hffffff00) | (data_in & 32'h000000ff);
					4'b0010: FPGAIO[2] <= (FPGAIO[2] & 32'hffff00ff) | (data_in & 32'h0000ff00);
					4'b0100: FPGAIO[2] <= (FPGAIO[2] & 32'hff00ffff) | (data_in & 32'h00ff0000);
					4'b1000: FPGAIO[2] <= (FPGAIO[2] & 32'h00ffffff) | (data_in & 32'hff000000);
				endcase
			end
		end
	end

	// Assigning data_out
	always@(*) begin
		case(data_addr)
			11'h400: data_out = FPGAIO[0];
			11'h401: data_out = FPGAIO[1];
			11'h402: data_out = FPGAIO[2];
			default: data_out = blk_mem_douta;
		endcase
	end

	// For this part:
	// Datamem that was coded s.t. Vivado generates RTL_RAM for the memory
	// Asynchronous read
	/*
	reg [31:0] memory [0:511];		// Addresses 0x000 to 0x1FF
	reg [31:0] con_mem [0:511];		// Addresses 0x200 to 0x3FF

	initial begin
		$readmemh("datamem.mem", memory);
	end

	// read
	// Core read
	assign data_out = (data_addr[9] == 1'h1)? con_mem[data_addr] : memory[data_addr];

	// Protocol controller read
	assign con_out = (con_addr[9] == 1'h1)? con_mem[con_addr] : memory[con_addr];

	// write
	always@(posedge clk) begin
		case(dm_write)
			// SW
			4'b1111: memory[data_addr] <= data_in;

			// SH
			4'b0011: memory[data_addr] <= (memory[data_addr] & 32'hffff0000) | (data_in & 32'h0000ffff);
			4'b1100: memory[data_addr] <= (memory[data_addr] & 32'h0000ffff) | (data_in & 32'hffff0000);

			// SB
			4'b0001: memory[data_addr] <= (memory[data_addr] & 32'hffffff00) | (data_in & 32'h000000ff);
			4'b0010: memory[data_addr] <= (memory[data_addr] & 32'hffff00ff) | (data_in & 32'h0000ff00);
			4'b0100: memory[data_addr] <= (memory[data_addr] & 32'hff00ffff) | (data_in & 32'h00ff0000);
			4'b1000: memory[data_addr] <= (memory[data_addr] & 32'h00ffffff) | (data_in & 32'hff000000);
		endcase
	end

	always@(posedge clk) begin
		case(con_write)
			// SW
			4'b1111: con_mem[con_addr] <= con_in;

			// SH
			4'b0011: con_mem[con_addr] <= (con_mem[con_addr] & 32'hffff0000) | (con_in & 32'h0000ffff);
			4'b1100: con_mem[con_addr] <= (con_mem[con_addr] & 32'h0000ffff) | (con_in & 32'hffff0000);

			// SB
			4'b0001: con_mem[con_addr] <= (con_mem[con_addr] & 32'hffffff00) | (con_in & 32'h000000ff);
			4'b0010: con_mem[con_addr] <= (con_mem[con_addr] & 32'hffff00ff) | (con_in & 32'h0000ff00);
			4'b0100: con_mem[con_addr] <= (con_mem[con_addr] & 32'hff00ffff) | (con_in & 32'h00ff0000);
			4'b1000: con_mem[con_addr] <= (con_mem[con_addr] & 32'h00ffffff) | (con_in & 32'hff000000);
		endcase
	end*/
endmodule