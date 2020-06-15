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
	assign uart_rco[31:10] = 25'd0;

	// RX/TX pins
	wire uart_enc;		// TX
	reg uart_dec;		// RX

	// always@(*) uart_dec = uart_enc;
	reg [23:0] dec_baudcontrol =  24'd434;	// 115200bps
	reg [1:0] dec_parity = 2'b01;			// even parity
	reg dec_stop_sel = 0;					// 1 stopbit

	Encoder ENCODER(
		.clk(CLK),
        .nrst(nrst),

        .data_in(uart_din[7:0]),
        .en(uart_con[0]),
        .parity(uart_con[2:1]),
        .stop_sel(uart_con[3]),
        .baudcontrol(uart_con[31:8]),

        .uart_enc(uart_enc),
        .uart_rco(uart_rco[7:0])
	);

	Decoder DECODER(
		.clk(CLK),
   		.nrst(nrst),

   		.uart_dec(uart_dec),        
   		.baudcontrol(/* uart_con[31:8] */dec_baudcontrol),    
   		.parity(/* uart_con[2:1] */dec_parity),
		.stop_sel(/* uart_con[3] */dec_stop_sel),
		
   		.rddone(uart_rco[8]),
		.perr(uart_rco[9]),
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

	// Task for generating stimulus
	task encoder_stimulus();
		input [31:0] data_in;
		input [23:0] baudcontrol;
		input [1:0] parity;
		input stop_sel;
		integer clk_cnt;
		
		begin
			clk_cnt = clock_counter;
			uart_din = data_in;
			uart_con[31:8] = baudcontrol;
			uart_con[2:1] = parity;
			uart_con[3] = stop_sel;

			uart_con[0] = 1;	// enable

			while(clock_counter != (clk_cnt + 2)) #1;
			uart_din = uart_din >> 8;
			
			while(clock_counter != (clk_cnt + 3)) #1;
			uart_din = uart_din >> 8;

			while(clock_counter != (clk_cnt + 4)) #1;
			uart_din = uart_din >> 8;

			while(clock_counter != (clk_cnt + 5)) #1;
			uart_con[0] = 0;	// enable = 0
		end
	endtask

	// Stop simulation after 100 cycles of IDLE
	integer check = 0, done = 0;
	always@(posedge CLK) begin
		if(!nrst) begin
			check <= 0;
			done = 0;
		end
	end

	always@(posedge CLK) begin
		if(ENCODER.state == ENCODER.s_idle)
			check <= check + 1;
		else begin
			check = 0;
		end
	end

	always@(posedge CLK) begin
		if(check == 100) done = 1;
	end

	integer data_sent = 0;		// Determines how much data has been sent

	// Stimulus for encoder
	always@(posedge CLK)
		if(!nrst) begin
			uart_din <= 0;
			uart_con <= 0;
			uart_dec <= 1;			
		end
	
	always@(posedge CLK) begin
		// Send 0xade1b055
		if(clock_counter == 10) begin
			encoder_stimulus(32'hade1b055, 24'd434, 2'b01, 1'b0);	// even parity, 1 stop bit, 115200bps
			data_sent <= data_sent + 1;
		end

		// Send 0xabcdef97
		if(clock_counter == 20) begin
			encoder_stimulus(32'habcdef97, 24'd434, 2'b01, 1'b0);	// even parity, 1 stop bit, 115200 bps
			data_sent <= data_sent + 1;
		end

		// Send 0xc0b1d190
		if(uart_rco[7] && ENCODER.state == ENCODER.s_idle && data_sent == 2) begin
			encoder_stimulus(32'hc0b1d190, 24'd434, 2'b10, 1'b1);	// odd parity, 2 stop bits, 115200 bps
			data_sent <= data_sent + 1;
		end

		// Send 0xcafec0c0
		if(uart_rco[7] && ENCODER.state == ENCODER.s_idle && data_sent == 3) begin
			encoder_stimulus(32'hcafec0c0, 24'd5207, 2'b11, 1'b1);	// no parity, 2 stop bits, 9600 bps
			data_sent <= data_sent + 1;
		end

		// Send 0xdeadbeef
		if(uart_rco[7] && ENCODER.state == ENCODER.s_idle && data_sent == 4) begin
			encoder_stimulus(32'hdeadbeef, 24'd5207, 2'b11, 1'b0);	// no parity, 1 stop bit, 9600 bps
			data_sent <= data_sent + 1;
		end

		if(done) $finish;	// Finish sending
	end

	// Stimulus for the decoder
	reg dec_CLK = 0;						// baud rate clock for decoder input
	integer dec_counter = 0;				// counter for decoder
	always #4340.2778 dec_CLK = ~dec_CLK;	// 115.2kHz clock
	
	always@(posedge dec_CLK) begin
		if(!nrst) dec_counter <= 0;
		else dec_counter <= dec_counter + 1;
	end

	always@(posedge dec_CLK) begin
		if(nrst) begin						// send only when nrst not pulled down
			// Send 0xe1dadefa (even parity, 1 stop bit)
			if(dec_counter==0) uart_dec <= 0;					// START bit

			if(dec_counter==1) uart_dec <= 0;			// 0xA
			if(dec_counter==2) uart_dec <= 1;			// 0xA
			if(dec_counter==3) uart_dec <= 0;			// 0xA
			if(dec_counter==4) uart_dec <= 1;			// 0xA

			if(dec_counter==5) uart_dec <= 1;			// 0xF
			if(dec_counter==6) uart_dec <= 1;			// 0xF
			if(dec_counter==7) uart_dec <= 1;			// 0xF
			if(dec_counter==8) uart_dec <= 1;			// 0xF

			if(dec_counter==9) uart_dec <= 0;			// Parity bit
			if(dec_counter==10) uart_dec <= 1;		// Stop bit
			// ===========================================================
			if(dec_counter==11) uart_dec <= 0;		// Start bit

			if(dec_counter==12) uart_dec <= 0;		// 0xE
			if(dec_counter==13) uart_dec <= 1;		// 0xE
			if(dec_counter==14) uart_dec <= 1;		// 0xE
			if(dec_counter==15) uart_dec <= 1;		// 0xE

			if(dec_counter==16) uart_dec <= 1;		// 0xD
			if(dec_counter==17) uart_dec <= 0;		// 0xD
			if(dec_counter==18) uart_dec <= 1;		// 0xD
			if(dec_counter==19) uart_dec <= 1;		// 0xD

			if(dec_counter==20) uart_dec <= 0;		// Parity bit
			if(dec_counter==21) uart_dec <= 1;		// Stop bit
			// ===========================================================
			if(dec_counter==22) uart_dec <= 0;		// Start bit

			if(dec_counter==23) uart_dec <= 0;		// 0xA
			if(dec_counter==24) uart_dec <= 1;		// 0xA
			if(dec_counter==25) uart_dec <= 0;		// 0xA
			if(dec_counter==26) uart_dec <= 1;		// 0xA

			if(dec_counter==27) uart_dec <= 1;		// 0xD
			if(dec_counter==28) uart_dec <= 0;		// 0xD
			if(dec_counter==29) uart_dec <= 1;		// 0xD
			if(dec_counter==30) uart_dec <= 1;		// 0xD

			if(dec_counter==31) uart_dec <= 0;		// Parity bit (wrong parity bit)
			if(dec_counter==32) uart_dec <= 1;		// Stop bit
			// ===========================================================
			if(dec_counter==33) uart_dec <= 0;		// Start bit

			if(dec_counter==34) uart_dec <= 1;		// 0x1
			if(dec_counter==35) uart_dec <= 0;		// 0x1
			if(dec_counter==36) uart_dec <= 0;		// 0x1
			if(dec_counter==37) uart_dec <= 0;		// 0x1

			if(dec_counter==38) uart_dec <= 0;		// 0xE
			if(dec_counter==39) uart_dec <= 1;		// 0xE
			if(dec_counter==40) uart_dec <= 1;		// 0xE
			if(dec_counter==41) uart_dec <= 1;		// 0xE

			if(dec_counter==42) uart_dec <= 1;		// Parity bit (wrong parity bit)
			if(dec_counter==43) uart_dec <= 1;		// Stop bit
		end
	end
endmodule