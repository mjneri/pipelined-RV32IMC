//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// tx_buffer.v -- Transmit buffer for UART
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Author: Microlab 198 Pipelined RISC-V Group (2SAY1920)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Module Name: txbuffer.v
// Description: This module contains the transmit buffer for the UART Encoder
//				module. Data is stored in the buffer until it needs to be sent
//				through UART. Data is shifted as the buffer is emptied.
//				The buffer can store 16 bytes at a time.
//				If the buffer is full, additional data is ignored.
//				buffer[0] contains the data being sent.
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

`timescale 1ns / 1ps
module tx_buffer(
	// Inputs
	input CLK,
	input nrst,
	input wr,					// Stores data_in to the buffer if asserted
	input rd,					// Pops data out of the buffer if asserted
	input [7:0] data_in,

	// Outputs
	output [7:0] data_out,
	output reg [4:0] buffer_count,	// tracks how much data is stored in the buffer.
									// buffer_count[4] determines if the buffer has exceeded 16 bytes stored.
	output buffer_empty,
	output buffer_full
);
	// Declaring wires & regs
	reg [7:0] buffer [15:0];				// 16 byte buffer
	wire buffer_wren = wr & (!buffer_full);	// buffer write enable
	wire buffer_pop = rd & (!buffer_empty);	// buffer pop signal (similar to popping a stack)

	// Assigning outputs
	assign buffer_full = buffer_count[4];	// asserts if the buffer is full
	assign buffer_empty = ~(|buffer_count);	// asserts if the buffer is empty
	assign data_out = buffer[0];

	// Initializing the buffer
	integer i;
	initial begin
		buffer_count = 0;
		for(i = 0; i < 16; i = i+1)
			buffer[i] = 0;
	end

	// Buffer count control
	always@(posedge CLK) begin
		if(!nrst)
			buffer_count <= 0;
		else begin
			if(!(buffer_wren && buffer_pop)) begin
				// Increment or decrement only when rd & wr are not asserted at the same time
				if(buffer_wren)
					// Increment buffer_count if buffer_wren is asserted
					buffer_count <= buffer_count + 5'd1;
				else if(buffer_pop)
					// Decrement if rd is asserted AND buffer is not empty
					buffer_count <= buffer_count - 5'd1;
			end
		end
	end

	// Buffer control
	always@(posedge CLK) begin
		if(!nrst)
			for(i = 0; i < 16; i = i+1)
				buffer[i] <= 0;
		else begin
			if(buffer_wren && buffer_pop) begin
				// if both of the above signals are asserted,
				// push & pop to the buffer at the same time.
				for(i = 0; i < 15; i = i+1)		// POP
					buffer[i] <= buffer[i+1];
				buffer[15] <= 0;

				buffer[buffer_count - 1] <= data_in;	// PUSH
			end
			else if(buffer_wren) begin
				// buffer will only save until it's full (which is when buffer_wren deasserts).
				buffer[buffer_count] <= data_in;
			end
			else if(buffer_pop) begin
				// 'Pop the stack'. Shift the buffer contents
				for(i = 0; i < 15; i = i+1)
					buffer[i] <= buffer[i+1];
				buffer[15] <= 0;
			end
		end
	end

endmodule