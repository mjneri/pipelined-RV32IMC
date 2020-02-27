`timescale 1ns / 1ps

module datamem(
	input clk,
	input nrst,

	// Inputs from within the core
	input [3:0] dm_write,
	input [10:0] data_addr,
	input [31:0] data_in,

	input [3:0] btn_in,
	input [2:0] switch_in,

	// Inputs from protocol controllers
	input [3:0] con_write,		// Similar to dm_write
	input [9:0] con_addr,		// datamem address from protocol controller
	input [31:0] con_in,		// data input from protocol controller

	output reg [31:0] data_out,		// data output to within the core
	output [31:0] con_out,		// data output to protocol controller
	

	output [3:0] LED_out
);
	
	wire [31:0] blkmem_data_out;
	reg [31:0] btn_reg;
	reg [31:0] switch_reg;
	reg [31:0] LED_reg;

	// Datamem that uses BLOCKMEM from Vivado IP Catalog
	// Blockmem generated as TRUE DUAL PORT RAM
	// Synchronous read
	blk_mem_gen_datamem BLOCKMEM(
		.clka(~clk),
		.wea(dm_write),
		.addra(data_addr),
		.dina(data_in),
		.douta(blkmem_data_out),

		.clkb(~clk),
		.web(con_write),
		.addrb(con_addr),
		.dinb(con_in),
		.doutb(con_out)
	);

	// assign LED_out = LED_reg[3:0];


	// // synchronous read/write for the I/O;

	// // writes (btn and switch)
	// // 0x1000
	// always@(posedge clk) begin
	// 	//switch
	// 	if(!nrst) begin
	// 		switch_reg <= 0;
	// 		btn_reg <= 0;
	// 	end else begin
	// 		switch_reg <= {29'h0, switch_in};
	// 		btn_reg <= {28'h0, btn_in};	
	// 	end
	// end

	// // write to LED
	// always@(posedge clk) begin
	// 	if(!nrst) begin
	// 		LED_reg <= 0;
	// 	end else begin
	// 		if (data_addr==11'h402) begin
	// 			case(dm_write)
	// 				// SW
	// 				4'b1111: LED_reg <= data_in;

	// 				// SH
	// 				4'b0011: LED_reg <= (LED_reg & 32'hffff0000) | (data_in & 32'h0000ffff);
	// 				4'b1100: LED_reg <= (LED_reg & 32'h0000ffff) | (data_in & 32'hffff0000);

	// 				// SB
	// 				4'b0001: LED_reg <= (LED_reg & 32'hffffff00) | (data_in & 32'h000000ff);
	// 				4'b0010: LED_reg <= (LED_reg & 32'hffff00ff) | (data_in & 32'h0000ff00);
	// 				4'b0100: LED_reg <= (LED_reg & 32'hff00ffff) | (data_in & 32'h00ff0000);
	// 				4'b1000: LED_reg <= (LED_reg & 32'h00ffffff) | (data_in & 32'hff000000);
	// 			endcase
	// 		end
	// 	end
	// end

	// // reads ng btn and switch
	// always@(*) begin
	// 	case(data_addr)
	// 		11'h400: data_out <= btn_reg; //btn 
	// 		11'h401: data_out <= switch_reg; //switch
	// 		11'h402: data_out <= LED_out;
	// 		default: data_out <= blkmem_data_out;
	// 	endcase
	// end


	
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