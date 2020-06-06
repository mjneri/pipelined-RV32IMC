`timescale 1ns/1ps


/*


SPI DATA IN
=======================================================
|                 SPI_DATA_IN[31:0]                   |
=======================================================

SPI INPUT CONTROL 1
===================================================================================================
| Prescale[31:8] | X |  Slave Select[6:5] | Order | Clock Phase | Clock Polarity |   On   | Enable |
| [23:0]prescale | X |     select[1:0]    | order |     cpha    |      cpol      | turnon |   en   |                  
===================================================================================================

SPI DATA OUT
=======================================================
|                SPI_DATA_OUT[31:0]                   |
=======================================================

SPI OUTPUT CONTROL 1
=======================================================
|       XXX[31:2]           |    Done    |    Busy    | 
=======================================================



*/

module spi(
	// Inputs from core
	input				clk,		// Clock from core (50MHz)

	input				turnon,		// Toggles module on or off
	input				enable,		// Controls SPI transactions

	input		[23:0]	prescale,

	input		[31:0]	din,		// Data in from core
	input		[1:0]	select,		// Slave selector
	
	input				order,		// MSB-first(0) or LSB-first(1)
	input				cpha,		// Default clock phase
	input				cpol,		// Default clock polarity

	// Main I/O
	input				miso,		// When asserted, means that data is transmitted from slave to master
	output				mosi,		// When asserted, means that data is transmitted from master to slave
	output reg			sck,
	
	output 				ss0,		// Low asserted slave select signals
	output 				ss1,
	output 				ss2,
	output 				ss3,
	
	output		[31:0]	rco,		// Contains done and busy flags
	output		[31:0]	dat			// Contains data out
	);
	
	reg [31:0]	din_tmp;			// 32-bit data in buffer
	
	reg	[7:0]	dout;				// 8-bit data out buffer
	reg			busy;
	reg			done;
	assign rco = {30'h0, done, busy};
	assign dat = {24'h0, dout};
	
	reg			[3:0]	ss;			// Slave select register
	reg					toggle;		
	reg			[7:0]	state;		// State register values:
									// If cpha:		8'hFF... -> 8'hEE -> start -> next... -> last(done) -> 8h'FF...
									// If !cpha:	8'hFF... -> start -> next... -> last -> 8h'EE(done) -> 8h'FF...
	
	reg					e_clk;		// Extended Clock
	reg			[23:0]	ctr;		// Clock Counter
	
	// Data transmission logic (32-bit segments)
	assign	mosi = busy ? ((state == 8'hEE) || (state == 8'hFF)) ? 1 : din_tmp[state[4:0]] : 1;
	assign ss0 = ss[0];
	assign ss1 = ss[1];
	assign ss2 = ss[2];
	assign ss3 = ss[3];
	
	// State Interpretation Wires
	wire		[7:0]	start;
	wire		[7:0]	last;
	wire		[7:0]	next;
	assign start = order ? 8'h0 : 8'hF;
	assign last = order ? 8'hF : 8'h0;
	assign next = order ? state + 8'h1 : state - 8'h1;
	
	
	initial begin
		e_clk <= 0;
		ctr <= 24'h0;
		din_tmp <= 32'h0;
		sck <= 1'h1;
		dout <= 8'h0;
		state <= 8'hFF;
		toggle <= 0;
		busy <= 0;
		done <= 0;
		ss[0] <= 1;
		ss[1] <= 1;
		ss[2] <= 1;
		ss[3] <= 1;
	end

	// Extended clock state machine
	always@(posedge clk) begin						
		if(!turnon)	e_clk <= ~e_clk;				// If not turned on, e_clk is a pulse train with HALF the frequency of clk
		else if(ctr == prescale) e_clk <= ~e_clk;	// If turned on, eclk has a frequency of clk divided by 2(prescale+1)
		else e_clk <= e_clk;
	end
	
	// Prescale counter state machine
	always@(posedge clk) begin
		if(!turnon) begin
			ctr <= 24'h0;
			din_tmp <= din;
		end
		else begin
			if(ctr == prescale) ctr <= 24'h0;		// Adds ctr until it reaches the prescale value
			else ctr <= ctr + 24'h1;
			
			if(enable) din_tmp <= din;				// Stores data from core
			else din_tmp <= din_tmp;
		end
	end
	
	// Main I/O state machine (operates at a reduced frequency)
	always@(posedge e_clk) begin
		if(!turnon) begin
			sck <= cpol;
			dout <= 8'h0;
			state <= 8'hFF;
			toggle <= 0;
			busy <= 0;
			done <= 0;
			ss[0] <= 1;
			ss[1] <= 1;
			ss[2] <= 1;
			ss[3] <= 1;
		end
		else begin
			// Toggle Register (Provides a stable enable signal)
			if(busy) toggle <= ~toggle;
			else if(enable) toggle <= 1;
			else toggle <= 0;
			
			// Busy Flag
			if(enable) busy <= 1;
			else if((cpha && toggle) && (state == last)) busy <= 0;
			else if(!cpha && (state == 8'hEE)) busy <= 0;
			else busy <= busy;
			
			// Done Flag
			if(cpha && toggle && (state == last)) done <= 1;
			else if(!cpha && (state == 8'hEE)) done <= 1;
			else done <= 0;
			
			// State Reg
			if(busy)
				if(cpha)
					if(state == 8'hEE) state <= start;
					else if(toggle && (state == last)) state <= 8'hFF;
					else if(toggle) state <= next;
					else state <= state;
				else
					if(state == 8'hEE) state <= 8'hFF;
					else if(!toggle && (state == last)) state <= 8'hEE;
					else if(!toggle) state <= next;
					else state <= state;
			else
				if(enable)
					if(cpha) state <= 8'hEE;
					else state <= start;
				else state <= 8'hFF;
			
			// Slave Select
			if(cpha && toggle && (state == last)) ss[select] <= 1;
			else if(!cpha && (state == 8'hEE)) ss[select] <= 1;
			else if(enable) ss[select] <= 0;
			else ss[select] <= ss[select];
			
			// Data (MISO)
			if(!cpha)
				if(toggle && (state != 8'hEE))
					if(order)
						if(state > 8'h7) dout[state] <= miso;
						else dout <= dout;
					else
						if(state < 8'h8) dout[state] <= miso;
						else dout <= dout;
				else dout <= dout;
			else
				if(!toggle && busy)
					if(order)
						if(state > 8'h7) dout[state] <= miso;
						else dout <= dout;
					else
						if(state < 8'h8) dout[state] <= miso;
						else dout <= dout;
				else dout <= dout;
			
			// SCK operates at the frequency of clk divided by 4(prescale+1)
			if(!busy) sck <= cpol;
			else if(toggle && cpha && (state == last)) sck <= cpol;
			else if(!cpha && (state == 8'hEE)) sck <= cpol;
			else sck <= ~sck;
		end
	end
endmodule