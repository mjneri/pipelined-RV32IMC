// Testbench for UART Protocol controllers
`timescale 1ns / 1ps
module tb_uart();
	// Wires & Registers
	reg CLK;
	reg nrst;
	reg [31:0] uart_din;
	reg [31:0] uart_con;

	wire [31:0] uart_dat;
	wire [31:0] uart_rco;
	assign uart_rco[31:7] = 25'd0;

	// RX/TX pins
	wire uart_enc;		// TX
	reg uart_dec;		// RX

	Encoder ENCODER(
		.clk(CLK),
        .nrst(nrst),
        .data_in_mem(uart_din[7:0]),
        .wr(uart_con[0]),
        .baudcontrol(uart_con[31:8]),
        .parity(uart_con[1]),
        .last_byte(uart_con[2]),
        .data_out(uart_enc),
        .u_rco(uart_rco[5:0])
	);

	Decoder DECODER(
		.clk(CLK),
   		.nrst(nrst),
   		.data_in(uart_dec),
   		.baudcontrol(uart_con[31:8]),
   		.parity(uart_con[1]),
   		.done(uart_rco[6]),
   		.data_out(uart_dat)
	);

	always #10 CLK = ~CLK;		// 50MHz clock

	// Initialization
	initial begin
		CLK = 0;
		nrst = 0;
		uart_din = 0;
		uart_con = 0;
		uart_dec = 1;

		#100 nrst = 1;
	end

	// Display baudrate in waveforms (based on given baudcontrol value)
	integer baudrate;
	always@(posedge CLK)
		baudrate <= (50000000)/(uart_con[31:8] + 24'b1);
	// initial $display("Baudrate: %0d", baudrate);

	// Clock counter
	integer clock_counter = 0;
	always@(posedge CLK) begin
		if(!nrst) clock_counter <= 0;
		else clock_counter <= clock_counter + 1;
	end

	// Stimulus
	always@(posedge CLK)
		if(!nrst) begin
			uart_din <= 0;
			uart_con <= 0;
			uart_dec <= 1;			
		end
	
	always@(posedge CLK) begin
		if(clock_counter == 10) begin
			uart_din <= 32'hade1b055;	// Set data
			uart_con[31:8] <= 24'd434;	// 115200 bps baud rate
			uart_con[1] <= 1;			// parity bit
			uart_con[0] <= 1;			// Enable
		end

		if(clock_counter == 11) begin
			uart_din <= uart_din >> 8;
			uart_con[0] <= 1;			// Enable
		end

		if(clock_counter == 12) begin
			uart_din <= uart_din >> 8;
			uart_con[0] <= 1;			// Enable
		end

		if(clock_counter == 13) begin
			uart_din <= uart_din >> 8;
			uart_con[0] <= 1;			// Enable
			uart_con[2] <= 1;			// Last byte
		end

		// if(clock_counter == 14) begin
		// 	uart_con[0] <= 0;			// Enable
		// 	uart_con[2] <= 0;			// Last byte
		// end

		if(clock_counter == 20000) $finish;	// Finish sending 4 bytes @ 115200 bps
	end
endmodule