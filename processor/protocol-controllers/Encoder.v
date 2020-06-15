//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Encoder.v -- UART Transmitter module
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Author: Microlab 198 Single-cycle RISC-V Group (2SAY1819)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Module Name: Encoder.v
// Description:
//
// Revisions:
// Revision 0.01 - File Created
// Revision 1.00 - File modified by Pipelined RISC-V Group (2SAY1920)
// Additional Comments:
//		(!en & en_reg) is used for TX_BUFFER.wr due to how mcont.v & tx_buffer.v work.
//		(Effectively, the logic !en & en_reg will assert for one cycle only, which allows
//      input data to be stored only once in the buffer).
// 
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

`timescale 1ns / 1ps
module Encoder(
    input clk,
    input nrst,

    input [7:0] data_in,		// UART_DIN
    input en,					// UART_CON[0]: EN
    input [1:0] parity,			// PARITY: 	00 -- no parity bit
								//		   	01 -- even parity
								//		   	10 -- odd parity
								//		   	11 -- no parity bit
    input stop_sel,				// STOP_SEL: 0 -- 1 stop bit
								//			 1 -- 2 stop bits
    input [23:0] baudcontrol,	// BAUDCONTROL = (Fcoreclk/Fbaudrate) - 1

    output reg uart_enc,		// UART_TX Pin
    output reg [7:0] uart_rco	// uart_rco[7]: TRMT (transmit buffer empty)
								// uart_rco[6]: TXBF (transmit buffer full)
								// uart_rco[5:1]: BUFFER_COUNT
								// uart_rco[0]: WRDONE
);
    
    // For determining the status of the operation, a finite state machine (FSM)
	// is implemented. Here is a description of what occurs during each state:
	//
	// IDLE         -- Do nothing. Wait until at least 1 byte is saved in the buffer.
    //                  Next state is START.
    // START        -- Send the START bit for one cycle based on the set baud rate.
    //                  Next state is DATA.
    // DATA         -- Send the LSB (data[0]), advancing through the data bits by incrementing
    //                  bit_index & shifting the data right by 1 bit. Once the data is finished sending,
	//					check if the PARITY bit setting is enabled. If so, next state is PARITY. Else,
	//					next state is STOP.
	// PARITY		-- Send either an even or odd parity bit (based on the settings in uart_con). Next state
	//					is STOP.
	// STOP			-- Send 1 or 2 stop bits (depending on the setting). If the buffer is not yet empty, next
	//					state is START. Else, next state is IDLE.
	parameter [7*8:0] s_idle 	= 	"___IDLE",
					  s_start 	= 	"__START",
					  s_data 	= 	"___DATA",
					  s_stop 	= 	"___STOP",
					  s_parity 	= 	"_PARITY";
	// parameter s_idle = 3'd0;
	// parameter s_start = 3'd1;
	// parameter s_data = 3'd2;
	// parameter s_stop = 3'd3;
	// parameter s_parity = 3'd4;
    
	// Declaring other signals
    reg [7*8:0] state;			// FSM signals
    reg [23:0] clk_count;		// clock based on the baud rate
    reg [2:0] bit_index;		// determines which bit is being sent
    reg [7:0] data;				// the data being sent
    reg parity_bit;				// contains the parity bit (depending on the setting)
	reg stop_bit;				// determines if a stop bit has been sent. used for sending 2 stop bits.
    reg en_reg;					// used for asserting TX_BUFFER.wr for one cycle
    
    wire [7:0] buffer_out;  	// data from the buffer that will be sent
    wire buffer_empty;			// determines if the buffer is empty
    wire buffer_full;			// determines if the buffer is full
    wire [4:0] buffer_count;	// determines how much data is stored in the buffer

	// TX_BUFFER can store up to 16 bytes of data.
    tx_buffer TX_BUFFER(
        .CLK(clk),
        .nrst(nrst),

        .wr(!en & en_reg),		// used s.t. wr is asserted for one cycle only (this is described at the module description above)
        .rd( (bit_index == 3'd7) & (clk_count == 24'd0) ),
        .data_in(data_in),

        .data_out(buffer_out),
        .buffer_count(buffer_count),
        .buffer_empty(buffer_empty),
        .buffer_full(buffer_full)
    );

	// Initializing registers
    initial begin
        state <= s_idle;
        clk_count <= 0;
        bit_index <= 0;
        data <= 0;
		parity_bit <= 0;
		stop_bit <= 0;
        en_reg <= 0;
        uart_rco <= 0;
    end

    // This controls en_reg
    always@(posedge clk) begin
        if(!nrst)
            en_reg <= 0;
        else
            en_reg <= en;
    end

	// This controls state transitions, the clock counter, bit index,
	// parity bit, and the data to be sent. States described above.
    always@(posedge clk) begin
        if(!nrst) begin
            state <= s_idle;
            clk_count <= 0;
            bit_index <= 0;
            data <= 0;
			parity_bit <= 0;
			stop_bit <= 0;
        end
        else begin
            case(state)
                s_idle: 
				begin
                    if(!buffer_empty) begin
                        state <= s_start;
                        data <= buffer_out;
						parity_bit <= (parity == 2'b01)? ^buffer_out 	:	// even parity
									  (parity == 2'b10)? ~(^buffer_out) :	// odd parity
									  1;
                    end
                    else
						state <= s_idle;
                end

                s_start:
                    if(clk_count < baudcontrol) begin
                        clk_count <= clk_count+1;
                        state <= s_start;
                    end
                    else begin
                        clk_count <= 0;
						stop_bit <= 0;		// reset stop_bit to 0
                        state <= s_data;
                	end

                s_data:
                    if(clk_count < baudcontrol) begin
                        clk_count <= clk_count+1;
                        state <= s_data;
                    end
                    else begin
                        clk_count <= 0;
                        if(bit_index < 3'd7) begin
                            bit_index <= bit_index + 3'd1;
                            data <= {1'd0,data[7:1]};
                            state <= s_data;
                         end
                         else begin
                            bit_index <= 0;
                            data <= {1'd0,data[7:1]};
                            state <= (^parity)? s_parity : s_stop;
                         end
                    end

                s_parity:
                    if(clk_count < baudcontrol) begin
                        clk_count <= clk_count+1;
                        state <= s_parity;
                    end
                    else begin
                        clk_count <= 0;
                        state <= s_stop;
                    end

                s_stop:
                    if(clk_count < baudcontrol) begin
                        clk_count <= clk_count+1;
                        state <= s_stop;
                    end
                    else begin
                        clk_count <= 0;
						stop_bit <= 1;				// assert stop_bit, which means at least 1 stop bit has been sent.
						if(stop_sel && !stop_bit)
							state <= s_stop;		// send the second stop bit.
                        else if(!buffer_empty) begin
                            state <= s_start;
                            data <= buffer_out;
                            parity_bit <= (parity == 2'b01)? ^buffer_out 	:	// even parity
									  	  (parity == 2'b10)? ~(^buffer_out) :	// odd parity
									  	  1;
                        end
                        else state <= s_idle;
                    end

                default:
                    state <= s_idle;
            endcase
        end
    end

	// This controls the UART Output Control contents (uart_rco[7:0]) and 
	// the uart_enc port (which corresponds to the TX pin of the UART module).
    always@(*) begin
        uart_rco[0] = (state == s_stop && ((stop_sel && stop_bit) || !stop_sel))? 1'b1 : 1'b0;      // WRDONE
		uart_rco[5:1] = buffer_count;	// BUFFER_COUNT
		uart_rco[6] = buffer_full;		// TXBF
		uart_rco[7] = buffer_empty;		// TRMT

        case(state)
            s_idle: uart_enc = 1;

            s_start: uart_enc = 0;

            s_data: uart_enc = data[0];

            s_parity: uart_enc = parity_bit;

            s_stop: uart_enc = 1;

            default: uart_enc = 1;
        endcase
    end
endmodule