`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/09/2020 11:27:17 PM
// Design Name: 
// Module Name: tb_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_top();

	reg CLK100MHZ, nrst;
	// reg [3:0] BTN;
	// reg [2:0] SW;
	// wire [3:0] LED;
	// wire UART_TX;
	wire ck_io0;
	reg  ck_io1;
	wire ck_io2;
	wire ck_io3;
	wire ck_io4;
	wire ck_io5;
	wire ck_io6;
	wire ck_io7;
	reg  ck_io8;
	wire ck_io38;
	wire ck_io39;

	top TOP(
		.CLK100MHZ(CLK100MHZ),
		.nrst(nrst),

		// .BTN(BTN),
		// .SW(SW),
		// .LED(LED),

		// .UART_TX(UART_TX)
		.ck_io0(ck_io0),
		.ck_io1(ck_io1),
		.ck_io2(ck_io2),
		.ck_io3(ck_io3),
		.ck_io4(ck_io4),
		.ck_io5(ck_io5),
		.ck_io6(ck_io6),
		.ck_io7(ck_io7),
		.ck_io8(ck_io8),
		.ck_io38(ck_io38),
		.ck_io39(ck_io39)
	);

	always
		#5 CLK100MHZ = ~CLK100MHZ;

	initial begin
		CLK100MHZ = 0;
		nrst = 0;
		// BTN = 0;
		// SW = 0;
		ck_io1 = 1;
		ck_io8 = 1;
		// ck_io38 = 0;
		// ck_io39 = 0;

		#100 nrst = 1;
		// #100 BTN[1] = 1;
		// #100000 nrst = 0;
		// #10000 nrst = 1;
	end
	
	// reg [11:0] mem_PC, wb_PC;
	// always@(posedge TOP.CLKIP_OUT) begin
	// 	if(!nrst) begin
	// 		mem_PC <= 0;
	// 		wb_PC <= 0;
	// 	end else begin
	// 		mem_PC <= {TOP.RISCVCORE.exe_PC, 1'b0};
	// 		wb_PC <= mem_PC;
	// 	end
	// end

	// Stimulus for the UART decoder
	reg [7:0] enc_din = 0;
	reg enc_en = 0;
	reg [1:0] enc_parity = 0;
	reg enc_stopsel = 0;
	reg [23:0] enc_baud = 24'd433;
	wire enc_tx;
	integer enc_counter = 0;

	reg CLK50MHZ = 0;
	always #10 CLK50MHZ = ~CLK50MHZ;

	Encoder ENCODER(
		.clk(CLK50MHZ),
        .nrst(nrst),

        .data_in(enc_din),
        .en(enc_en),
        .parity(enc_parity),
        .stop_sel(enc_stopsel),
        .baudcontrol(enc_baud),

        .uart_enc(enc_tx),
        .uart_rco()
	);

	always@(*) ck_io8 = enc_tx;

	// Task for encoder stimulus
	task enc_stimulus();
		input [7:0] din;
		begin
			enc_din = din;
			#5 enc_en = 1'b1;
			#20 enc_en = 1'b0;
		end
	endtask

	always@(posedge CLK50MHZ) begin
		if(nrst /* & TOP.locked */) begin						// send only when nrst not pulled down
			enc_counter <= enc_counter + 1;
			if(enc_counter == 3000) enc_stimulus("T");
			if(enc_counter == 3010) enc_stimulus("h");
			if(enc_counter == 3020) enc_stimulus("e");
			if(enc_counter == 3030) enc_stimulus(" ");
			if(enc_counter == 3040) enc_stimulus("D");
			if(enc_counter == 3050) enc_stimulus("e");
			if(enc_counter == 3060) enc_stimulus("l");
			if(enc_counter == 3070) enc_stimulus("i");
			if(enc_counter == 3080) enc_stimulus("\n");
			if(enc_counter == 3090) enc_stimulus("5");
			if(enc_counter == 3100) enc_stimulus(":");
			if(enc_counter == 3110) enc_stimulus("3");
			if(enc_counter == 3120) enc_stimulus("2");
			if(enc_counter == 3130) enc_stimulus("p");
			if(enc_counter == 3140) enc_stimulus("m");
			if(enc_counter == 3150) enc_stimulus("\r");
			if(enc_counter == 3250) enc_stimulus("\n");
			
			if(enc_counter == 223000) enc_stimulus("C");
			if(enc_counter == 223010) enc_stimulus("h");
			if(enc_counter == 223020) enc_stimulus("o");
			if(enc_counter == 223030) enc_stimulus("n");
			if(enc_counter == 223040) enc_stimulus("\n");
			if(enc_counter == 223050) enc_stimulus("R");
			if(enc_counter == 223060) enc_stimulus("o");
			if(enc_counter == 223070) enc_stimulus("s");
			if(enc_counter == 223080) enc_stimulus("e");
			if(enc_counter == 223090) enc_stimulus("w");
			if(enc_counter == 223100) enc_stimulus("o");
			if(enc_counter == 223110) enc_stimulus("o");
			if(enc_counter == 223120) enc_stimulus("d");
			if(enc_counter == 223130) enc_stimulus("\r");
			if(enc_counter == 223140) enc_stimulus("\n");

			if(enc_counter == 423010) enc_stimulus("h");
			if(enc_counter == 423000) enc_stimulus("C");
			if(enc_counter == 423020) enc_stimulus("o");
			if(enc_counter == 423030) enc_stimulus("n");
			if(enc_counter == 423040) enc_stimulus("\n");
			if(enc_counter == 423050) enc_stimulus("R");
			if(enc_counter == 423060) enc_stimulus("o");
			if(enc_counter == 423070) enc_stimulus("s");
			if(enc_counter == 423080) enc_stimulus("e");
			if(enc_counter == 423090) enc_stimulus("w");
			if(enc_counter == 423100) enc_stimulus("o");
			if(enc_counter == 423110) enc_stimulus("o");
			if(enc_counter == 423120) enc_stimulus("d");
			if(enc_counter == 423130) enc_stimulus("\r");
			if(enc_counter == 423140) enc_stimulus("\n");
		end
	end

	// For checking UART_TX output of top-level design
	// settings: 115200bps, no parity, 1 stop bit
	reg [7:0] uart_shiftreg = 0;
	reg [7:0] uart_recvd = 0;
	integer uart_counter = 0;
	reg uart_clk = 0;

	// for generating 115.2kHz clock w/ delayed start
	initial begin
		while(ck_io7 == 1) #5;
		// #2655 uart_clk = 1;
		forever begin
			#4350 uart_clk = ~uart_clk;
		end
	end

	// Just manually change uart_counter 'threshold' depending on expected
	// transmission length.
	// SETTINGS: 1 stop bit, even parity -> 11 bits per transaction (start, 8bit data, parity, stop)
	always@(posedge uart_clk) begin
		if(!nrst) uart_counter <= 0;
		else if(uart_counter == 11) uart_counter <= 1;
		else uart_counter <= uart_counter + 1;
	end

	always@(posedge uart_clk) begin
		if(nrst) begin
			if(uart_counter == 11) uart_shiftreg <= 0;
			else begin
				uart_shiftreg[0] <= uart_shiftreg[1];
				uart_shiftreg[1] <= uart_shiftreg[2];
				uart_shiftreg[2] <= uart_shiftreg[3];
				uart_shiftreg[3] <= uart_shiftreg[4];
				uart_shiftreg[4] <= uart_shiftreg[5];
				uart_shiftreg[5] <= uart_shiftreg[6];
				uart_shiftreg[6] <= uart_shiftreg[7];
				uart_shiftreg[7] <= ck_io7;
			end
		end
	end

	always@(posedge uart_clk) begin
		if(nrst) begin
			if(uart_counter == 9) uart_recvd <= uart_shiftreg;
		end
	end

	// For checking MOSI output of top-level design
	// NOTE: just manually change sampling edge (if posedge or negedge)
	// depending on CPHA & CPOL settings. This snippet just helps confirm MOSI.
	// Also, you need to manually change order of the shift register depending on ORD setting.
	reg [15:0] spi_shiftreg = 0;
	integer i = 0;
	always@(posedge ck_io0) begin
		for(i = 15; i > 0; i = i-1)
			spi_shiftreg[i] <= spi_shiftreg[i-1];
		spi_shiftreg[0] <= ck_io2;
	end

	integer spi_counter = 0;
	always@(posedge ck_io0) begin
		if(!nrst) spi_counter <= 0;
		else begin
			if(spi_counter == 16) spi_counter <= 1;
			else spi_counter <= spi_counter + 1;
		end
	end
	always@(*) ck_io1 = ~spi_counter[0];

	// For checking I2C outputs of top-level design
	// NOTE: Data is sent MSB first. Every 9th bit is reserved for slave ACKs.
	reg SCL = 1'b1;
	reg SDA = 1'b1;
	
	always@(posedge ck_io38) SCL <= 1;
	always@(negedge ck_io38) SCL <= 0;

	always@(posedge ck_io39) SDA <= 1;
	always@(negedge ck_io39) SDA <= 0;

	reg [31:0] i2c_shiftreg = 0;
	integer i2c_counter = 0;

	// Detect start & stop bits
	reg sda_reg = 0;
	reg last_sda_reg = 0;
	reg scl_reg = 0;
	reg last_scl_reg = 0;
	wire sda_posedge = sda_reg & ~last_sda_reg;
	wire sda_negedge = ~sda_reg & last_sda_reg;
	wire scl_posedge = scl_reg & ~last_scl_reg;
	wire scl_negedge = ~scl_reg & last_scl_reg;
	wire start_bit = sda_negedge & scl_reg;
	wire stop_bit = sda_posedge & scl_reg;

	always@(posedge CLK50MHZ) begin
		sda_reg <= ck_io39;
		scl_reg <= ck_io38;
		last_sda_reg <= sda_reg;
		last_scl_reg <= scl_reg;
	end

	always@(posedge SCL or posedge stop_bit) begin
		if(!nrst) i2c_counter <= 0;
		else if(i2c_counter == 9) i2c_counter <= 1;
		else if(stop_bit) i2c_counter <= 0;
		else i2c_counter <= i2c_counter + 1;
	end

	// Sample the data bits only. Skip ACK bits
	always@(posedge SCL) begin
		if(nrst) begin
			if(i2c_counter != 8) begin
				for(i = 31; i > 0; i = i-1)
					i2c_shiftreg[i] <= i2c_shiftreg[i-1];
				i2c_shiftreg[0] <= SDA;
			end
		end
	end

	// Drive inout ports of the module
	assign ck_io39 = (TOP.i2c_sda_t && i2c_counter == 9)? 1'b0 : (TOP.i2c_sda_t && i2c_counter == 8)? 0 : (TOP.i2c_sda_t)? 1'b1 : 1'bZ;
	assign ck_io38 = (TOP.i2c_scl_t)? 1'b1 : 1'bZ;
endmodule