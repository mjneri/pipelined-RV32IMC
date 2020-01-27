`timescale 1ns / 1ps

module datamem(
	input clk,

	// Inputs from within the core
	input [3:0] dm_write,
	input [9:0] data_addr,
	input [31:0] data_in,

	// Inputs from protocol controllers
	input [3:0] con_write,	// Similar to dm_write
	input [9:0] con_addr,	// datamem address from protocol controller
	input [31:0] con_in,		// data input from protocol controller

	output [31:0] data_out,	// data output to within the core
	output [31:0] con_out	// data output to protocol controller
);
	
	// Datamem uses Block Memory from Vivado Block Mem. Generator module
	/*blk_mem_gen_datamem BLOCKMEM(
		.clka(~clk),
		.wea(dm_write),
		.addra(data_addr),
		.dina(data_in),
		.douta(data_out)
	);
	assign con_out = data_out;*/
	// Cant display contents of BLOCKRAM in testbench
	
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
	end
endmodule