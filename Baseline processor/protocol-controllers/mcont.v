`timescale 1ns/1ps

module mcont(
	input				clk,
	input				nrst,
	
	input		[31:0]	mem_in,			// Data from Core Datamem
	output reg	[10:0]	mem_addr,		// Word-aligned address
	output reg	[31:0]	mem_out,		// Output data to datamem
	output reg	[3:0]	mem_wr,
	
	// SPI
	output				sck,
	input				miso,
	output				mosi,
	output				ss0,
	output				ss1,
	output				ss2,
	output				ss3,
	
	// UART
	output				uart_enc,
	input               uart_dec,
	
	//I2C
	input 	wire 		i2c_scl_i,
	input 	wire 		i2c_sda_i,
	output 	wire 		i2c_scl_o,
	output 	wire 		i2c_scl_t,
	output 	wire 		i2c_sda_o,
	output 	wire		i2c_sda_t,
	output 	wire 		i2c_slave_sda_o,

	// Interrupt signal
	output int_sig
);
	
	wire		[31:0]	spi_rco_t;
	wire		[31:0]	spi_dat_t;
	
	reg			[6:0]	ctr;
	
	reg			[31:0]	spi_din;		// SPI		-	Data Input
	reg			[31:0]	spi_con;		// SPI		-	Input Control Signals
	
	reg			[31:0]	uart_din;		// UART		-	Data Input
	reg			[31:0]	uart_con;		// UART		-	Input Control Signals
	wire		[31:0]	uart_rco;		// UART		-	Output Control Signals
	wire		[31:0]	uart_dat;		// UART		-	Data Out (to memory)
	
	reg			[31:0]	i2c_din;		// I2C		-	Data Input
	reg			[31:0]	i2c_con;		// I2C		-	Input Control Signals
	wire		[31:0]	i2c_rco;		// I2C		-	Output Control Signals
	wire		[31:0]	i2c_dat;		// I2C		-	Data Out (to memory)
	
	wire		[5:0]	cnt;
	assign	cnt	=	ctr[6:1];
	wire mb;
	assign uart_rco[31:7] = 25'd0;

	spi SPI1(
		.clk(clk),

		.turnon(spi_con[1]),
		.enable(spi_con[0]),

		.mb(spi_con[7]),

		.prescale(spi_con[31:8]),

		.din(spi_din[31:0]),
		.select(spi_con[6:5]),

		.cpol(spi_con[2]),
		.cpha(spi_con[3]),
		.order(spi_con[4]),

		.miso(miso),
		.sck(sck),
		.mosi(mosi),

		.ss0(ss0),
		.ss1(ss1),
		.ss2(ss2),
		.ss3(ss3),

		.rco(spi_rco_t),
		.dat(spi_dat_t)
	);
	
	Encoder UART1(
		.clk(clk),
        .nrst(nrst),
        .data_in_mem(uart_din[7:0]),
        .wr(uart_con[0]),
        .baudcontrol(uart_con[31:8]),
        .parity(uart_con[1]),
        .last_byte(uart_con[2]),
        .data_out(uart_enc),
        .u_rco(uart_rco[5:0])
    );
        
    Decoder UART2(
   		.clk(clk),
   		.nrst(nrst),
   		.data_in(uart_dec),        
   		.baudcontrol(uart_con[31:8]),    
   		.parity(uart_con[1]),        
   		.done(uart_rco[6]),        
   		.data_out(uart_dat)            
    );
    
	i2c I2C1(
		.clk(clk),
		.nrst(nrst),
		.memory_data(i2c_din[31:0]),
		.memory_control(i2c_con[31:0]),
		
		.i2c_scl_i(i2c_scl_i),
		.i2c_scl_o(i2c_scl_o),
		.i2c_scl_t(i2c_scl_t),
		.i2c_sda_i(i2c_sda_i),
		.i2c_sda_o(i2c_sda_o),
		.i2c_sda_t(i2c_sda_t),
		.i2c_slave_sda_o(i2c_slave_sda_o),
		
		.i_dat(i2c_dat),
		.con_out(i2c_rco)
	);

	// Initializing registers
	initial begin
		ctr			=	7'h0;
		mem_addr	=	11'h0;
		mem_out		=	32'h0;
		mem_wr		=	0;
		
		spi_din		=	32'h0;
		spi_con		=	32'h0;
		
		uart_din	=	32'h0;
		uart_con	=	32'h0;
		
		i2c_din		=	32'h0;
		i2c_con		=	32'h0;
	end
	
	always@(posedge clk) begin
		if(!nrst) begin
			ctr			<=	7'h0;
			mem_addr	<=	11'h0;
			mem_out		<=	32'h0;
			mem_wr		<=	0;
			
			spi_din		<=	32'h0;
			spi_con		<=	32'h0;
			
			uart_din	<=	32'h0;
			uart_con	<=	32'h0;
			
			i2c_din		<=	32'h0;
			i2c_con		<=	32'h0;
			
		end
		else begin
			// the counter cycles through the data memory addresses
			ctr		<=	ctr == 7'h17	?	7'h0	:	ctr + 7'h1;
			case(ctr) 
				7'h0: begin
					mem_addr	<=	11'h001;	// Read from address 0x001 (SPI Data In)
					mem_out		<=	32'h0;
					mem_wr		<=	4'h0;
				end
				7'h2: begin
					mem_addr	<=	11'h002;	// Read from address 0x002 (SPI Input Control 1)
					mem_out		<=	32'h0;
					mem_wr		<=	4'h0;
					spi_din		<=	mem_in;
				end
				7'h4: begin
					mem_addr	<=	11'h401;	// Write to address 0x401 (SPI Output Control 1)
					mem_out		<=	spi_rco_t;
					mem_wr		<=	4'hf;
					spi_con		<=	mem_in;
				end
				7'h6: begin
					mem_addr	<=	11'h402;	// Write to address 0x402 (SPI Data Out)
					mem_out		<=	spi_dat_t;
					mem_wr		<=	4'hf;
				end
				7'h8: begin
					mem_addr	<=	11'h003;	// Read from address 0x003 (UART Data In)
					mem_out		<=	32'h0;
					mem_wr		<=	4'h0;
				end
				7'ha: begin
					mem_addr	<=	11'h004;	// Read from address 0x004 (UART Input Control 1)
					mem_out		<=	32'h0;
					mem_wr		<=	4'h0;
					uart_din	<=	mem_in;
				end
				7'hc: begin
					mem_addr	<=	11'h403;	// Write to address 0x403 (UART Output Control 1)
					mem_out		<=	uart_rco;	// write only when DONE2 = 1
					mem_wr		<=	4'hF;
					uart_con	<=	mem_in;
				end
				7'he: begin
					mem_addr	<=	11'h404;	// Write to address 0x404 (UART Data Out)
					mem_out		<=	uart_dat;
					mem_wr		<=	4'hF;
				end
				7'h10: begin
					mem_addr	<=	11'h005;	// Read from address 0x005 (I2C Data in)
					mem_out		<=	32'h0;
					mem_wr		<=	4'h0;
				end
				7'h12: begin
					mem_addr	<=	11'h006;	// Read from address 0x006 (I2C Input Control 1)
					mem_out		<=	32'h0;
					mem_wr		<=	4'h0;
					i2c_din		<=	mem_in;
				end
				7'h14: begin
					mem_addr	<=	11'h406;	// Write to address 0x406 (I2C Output control 1)
					mem_out		<=	i2c_rco;
					mem_wr		<=	4'hF;
					i2c_con		<=	mem_in;
				end
				7'h16: begin
					mem_addr	<=	11'h405;	// Write to address 0x405 (I2C Data out)
					mem_out		<=	i2c_dat;
					mem_wr		<=	4'hF;
				end
				// default: begin
				// 	mem_addr	<=	11'h000;
				// 	mem_out		<=	32'h0;
				// 	mem_wr		<=	4'h0;
				// end
			endcase
		end
	end

	// Interrupt only on the following conditions:
	// SPI: when DONE = 1 (spi_rco_t[0])
	// UART: when DONE2 = 1 (uart_rco[6])
	// I2C: when DONE = 1 (i2c_rco[1])
	assign int_sig = (spi_rco_t[1] == 1'b1) | (uart_rco[6] == 1'b1) | (i2c_rco[1] == 1'b1);
	
endmodule