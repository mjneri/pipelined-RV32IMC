//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Decoder.v -- UART Receiver module
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Author: Microlab 198 Single-cycle RISC-V Group (2SAY1819)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Module Name: Decoder.v
// Description:
//
// Revisions:
// Revision 0.01 - File Created
// Revision 1.00 - File modified by Pipelined RISC-V Group (2SAY1920)
// Additional Comments:
// 
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

`timescale 1ns / 1ps

module Decoder(
	input clk,
	input nrst,

	input uart_dec,				// UART_RX pin

	input [23:0] baudcontrol,	// BAUDCONTROL = (Fcoreclk/Fbaudrate) - 1
	input [1:0] parity,			// PARITY: 	00 -- no parity bit
								//		   	01 -- even parity
								//		   	10 -- odd parity
								//		   	11 -- no parity bit
	input stop_sel,				// STOP_SEL: 0 -- 1 stop bit
								//			 1 -- 2 stop bits

	output reg rddone,			// uart_rco[8]: RDDONE
	output reg perr,			// uart_rco[9]: PERR (parity error)
	output reg [31:0] data_out
);
	// For determining the status of the operation, a finite state machine (FSM)
	// is implemented. Here is a description of what occurs during each state:
	//
	// IDLE         -- Do nothing. Wait until START bit is detected. Next state is START
    // START        -- Sample the START bit. Next state is DATA.
    // DATA         -- Sample the DATA bits. If a parity bit is expected, next state is PARITY.
	//					else, next state is STOP.
	// PARITY		-- Sample the parity bit. Check if the parity bit received is correct (based on the received data).
	//					Assert 'perr' if an error is detected. Next state is STOP.
	// STOP			-- Sample 1 or 2 stop bits depending on 'stop_sel'. Next state is IDLE.
	parameter [7*8:0] s_idle = "___IDLE",
					  s_start = "__START",
					  s_data = "___DATA",
					  s_stop = "___STOP",
					  s_parity = "_PARITY";
  // parameter s_idle = 3'd0;
  // parameter s_start = 3'd1;
  // parameter s_data = 3'd2;
  // parameter s_parity = 3'd3;
  // parameter s_stop = 3'd4;
  
	// Declaring other signals
	reg r_data = 1'b1;			// UART_RX; Pulled-up by default based on UART specs
	reg [7*8:0] state;			// FSM signals
	reg [23:0] clk_count;		// clock based on the baud rate
	reg [2:0] bit_index;		// determines which bit was received
	reg parity_check;			// computed parity bit based on data received
	reg stop_bit;				// determinesif a stop bit was received. used for receiving 2 stop bits.
	reg [7:0] recv_buffer;		// buffer for received data before being saved to data_out

	// This controls rddone, parity_check, and r_data
	always@(*) begin
		r_data = uart_dec;
		// Assert rddone for once cycle only (even if 1 or 2 stop bits are received)
		rddone = (state == s_stop && ((stop_sel && stop_bit) || !stop_sel))? 1'b1 : 1'b0;
		
		parity_check <=  (parity == 2'b01)? ^recv_buffer[7:0] 		:	// even parity
						(parity == 2'b10)? ~(^recv_buffer[7:0]) 	:	// odd parity
						1;
	end

	// Initializing registers
	initial begin
		state <= s_idle;
		clk_count <= 0;
		bit_index <= 0;
		data_out <= 0;
		stop_bit <= 0;
		perr <= 0;
		recv_buffer <= 0;
	end

	always@(posedge clk) begin
		if(!nrst) begin
			state <= s_idle;
			clk_count <= 0;
			bit_index <= 0;
			data_out <= 0;
			stop_bit <= 0;
			perr <= 0;
			recv_buffer <= 0;
		end 
		else begin
			case(state)
				s_idle: 
					begin
						stop_bit <= 0;
						bit_index <= 0;
						state <= (r_data == 1'b0)? s_start : s_idle;
					end
				
				s_start: 
					begin
						if (clk_count == (baudcontrol >> 1)) begin
							// clk_count is checked w/ baudcontrol/2 s.t. the middle of the bits
							// is sampled [https://www.nandland.com/vhdl/modules/module-uart-serial-port-rs232.html].
							if (r_data == 1'b0) begin
								clk_count <= 0;  
								state <= s_data;
							end 
							else
								state <= s_idle;
						end
						else begin
							clk_count <= clk_count + 1;
							state <= s_start;
						end
					end

				s_data: 
					begin
						if (clk_count < baudcontrol) begin
							clk_count <= clk_count + 1;
							state <= s_data;
						end
						else begin
							// Sample the data
							clk_count <= 0;
							if (bit_index < 3'd7) begin
								bit_index <= bit_index + 1;
								recv_buffer[bit_index] <= r_data;
								state <= s_data;
							end
							else begin
								recv_buffer[bit_index] <= r_data;
								// Write to data_out only after receiving all data bits. Also, writing to data_out
								// is done in this state so that when transitioning to s_stop, the received data is
								// already in data_out (this can be better understood by looking at waveforms).
								data_out[7:0] <= {r_data, recv_buffer[6:0]};
								state <= parity? s_parity : s_stop;
							end
						end
					end

				s_parity:
					begin
						if(clk_count < baudcontrol) begin
							clk_count <= clk_count+1;
							state <= s_parity;
						end else begin
							clk_count <= 0;
							perr <= (^parity)? (r_data != parity_check) : 0;	// if PARITY == 00/11 (no parity bits), PERR = 0
																				// NOTE: it is expected in this state that r_data is the parity bit.
							state <= s_stop;
						end
					end

				s_stop:
					begin
						if (clk_count < baudcontrol) begin
							clk_count <= clk_count + 1;
							state <= s_stop;
						end else begin
							clk_count <= 0;
							stop_bit <= 1;					// assert stop_bit. Used for STOP_SEL as described below.
							perr <= (^parity)? perr : 0;	// since s_parity is not taken if PARITY is set to 00/11, 
															// set PERR to 0 in this state in that case. Else, retain PERR value

							if(stop_sel && !stop_bit)
								state <= s_stop;			// if STOP_SEL is set s.t. 2 stop bits are expected,
															// go back to s_stop for 1 more cycle.
							else
								state <= s_idle;
						end
					end

				default: state <= s_idle;
			endcase
		end
	end
endmodule