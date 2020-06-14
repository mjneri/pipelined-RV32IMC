//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// btndebounce.v -- Button Debouncer
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Author: Microlab 198 Pipelined RISC-V Group (2SAY1920)
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Module Name: btndebounce.v
// Description:
//
// Revisions:
// Revision 0.01 - File Created
// Additional Comments:
// 
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

`timescale 1ns / 1ps

module btndebounce(
	// 50MHz clock is expected
    input CLK,
    input nrst,

    input [3:0] btn,

    output reg [3:0] db_btn
    );

	// assume each input becomes stable after ~20ms
	// assume only one button press at a time
	// note: debouncing multiple inputs requires multiple counters.
	// one counter means only one input can be debounced.
	reg [20:0] count;		// 21 bit counter
	wire in = |btn;			// asserts if any button is pressed
	wire max = count[20];	// determine if first 20 bits exceeded max value (20ms passed)

	// counter behavior
	always@(posedge CLK) begin
		if(!nrst)
			count <= 0;
		else
			case({in, max})
				2'b10: count <= count + 1;
				2'b01: count <= count + 1;
				2'b00: count <= 0;
			endcase
	end
	
	// output assignment
	always@(posedge CLK) begin
		if(!nrst) begin
			db_btn <= 0;
		end
		else begin
			case({in, max})
				2'b11: db_btn <= btn;
				2'b00: db_btn <= btn;
			endcase
		end
	end
	
endmodule
