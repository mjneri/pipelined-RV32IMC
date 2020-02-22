`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:30:41 11/28/2018 
// Design Name: 
// Module Name:    btn_debounce 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module btn_debounce(
	// 50MHz clock is expected
    input CLK,
    input nrst,

    input [3:0] btn,

    output reg [3:0] db_btn
    );

	// assume each input becomes stable after ~20ms
	
	reg [20:0] count;		// 21 bit counter
	wire in = |btn;			// asserts if any button is pressed
	wire max = count[3];	// determine if first 20 bits exceeded max value (20ms passed)
	
	// counter behavior
	always@(posedge CLK) begin
		if(!nrst)
			count <= 0;
		else
			if(in && !max)
				count <= count + 1;
		    else if(!in)
		        	count <= 0;
	end
	
	// output assignment
	always@(posedge CLK) begin
		if(!nrst) begin
			db_btn <= 0;
		end
		else begin
			if(max)
				db_btn <= btn;
		end
	end
	
endmodule
