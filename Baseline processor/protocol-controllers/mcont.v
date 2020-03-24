`timescale 1ns/1ps

module mcont(
	input				clk,
	input				nrst,
	
	input		[31:0]	mem_in,
	output reg	[10:0]	mem_addr,		// Word-aligned address
	output reg	[31:0]	mem_out,
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
	output 	wire 		i2c_slave_sda_o
);
	
	wire		[31:0]	s_rco_t;
	wire		[31:0]	s_dat_t;
	
	reg			[6:0]	ctr;
	
	reg			[31:0]	s_din;		// SPI		-	Data Input
	reg			[31:0]	s_con;		// SPI		-	Input Control Signals
	
	reg			[31:0]	u_din;		// UART		-	Data Input
	reg			[31:0]	u_con;		// UART		-	Input Control Signals
	wire		[31:0]	u_rco;		// UART		-	Output Control Signals
	wire		[31:0]	u_dat;		// UART		-	Data Out (to memory)
	
	reg			[31:0]	i_din;		// I2C		-	Data Input
	reg			[31:0]	i_con;		// I2C		-	Input Control Signals
	wire		[31:0]	i_rco;		// I2C		-	Output Control Signals
	wire		[31:0]	i_dat;		// I2C		-	Data Out (to memory)
	
	wire		[5:0]	cnt;
	assign	cnt	=	ctr[6:1];
	wire mb;
	assign u_rco[31:7] = 25'd0;

	spi SPI1(
		.clk(clk),

		.turnon(s_con[1]),
		.enable(s_con[0]),

		.mb(s_con[7]),

		.prescale(s_con[31:8]),

		.din(s_din[31:0]),
		.select(s_con[6:5]),

		.cpol(s_con[2]),
		.cpha(s_con[3]),
		.order(s_con[4]),

		.miso(miso),
		.sck(sck),
		.mosi(mosi),

		.ss0(ss0),
		.ss1(ss1),
		.ss2(ss2),
		.ss3(ss3),

		.rco(s_rco_t),
		.dat(s_dat_t)
	);
	
	Encoder UART1(
		.clk(clk),
        .nrst(nrst),
        .data_in_mem(u_din[7:0]),
        .wr(u_con[0]),
        .baud(u_con[31:8]),
        .parity(u_con[1]),
        .last_byte(u_con[2]),
        .data_out(uart_enc),
        .u_rco(u_rco[5:0])
    );
        
    Decoder UART2(
   		.clk(clk),
   		.nrst(nrst),
   		.data_in(uart_dec),        
   		.baud(u_con[31:8]),    
   		.parity(u_con[1]),        
   		.done(u_rco[6]),        
   		.data_out(u_dat)            
    );
    
	i2c I2C1(
		.clk(clk),
		.nrst(nrst),
		.memory_data(i_din[31:0]),
		.memory_control(i_con[31:0]),
		
		.i2c_scl_i(i2c_scl_i),
		.i2c_scl_o(i2c_scl_o),
		.i2c_scl_t(i2c_scl_t),
		.i2c_sda_i(i2c_sda_i),
		.i2c_sda_o(i2c_sda_o),
		.i2c_sda_t(i2c_sda_t),
		.i2c_slave_sda_o(i2c_slave_sda_o),
		
		.i_dat(i_dat),
		.con_out(i_rco)
	);
	
	always@(posedge clk) begin
		if(!nrst) begin
			ctr			<=	7'h0;
			mem_addr	<=	11'h0;
			mem_out		<=	32'h0;
			mem_wr		<=	0;
			
			s_din		<=	32'h0;
			s_con		<=	32'h0;
			
			u_din		<=	32'h0;
			u_con		<=	32'h0;
			
			i_din		<=	32'h0;
			i_con		<=	32'h0;
			
		end
		else begin
			// the counter cycles through the data memory addresses
			ctr		<=	ctr == 7'hB	?	7'h0	:	ctr + 7'h1;
			case(ctr) 
				7'h0: begin
					mem_addr	<=	11'h001;	// Read from address 0x001 (SPI Data In)
					mem_out		<=	32'h0;
					mem_wr		<=	4'h0;
				end
				7'h1: begin
					mem_addr	<=	11'h002;	// Read from address 0x002 (SPI Input Control 1)
					mem_out		<=	32'h0;
					mem_wr		<=	4'h0;
					s_din		<=	mem_in;
				end
				7'h2: begin
					mem_addr	<=	11'h401;	// Write to address 0x401 (SPI Output Control 1)
					mem_out		<=	s_dat_t;
					mem_wr		<=	4'hf;
					s_con		<=	mem_in;
				end
				7'h3: begin
					mem_addr	<=	11'h402;	// Write to address 0x402 (SPI Data Out)
					mem_out		<=	s_rco_t;
					mem_wr		<=	4'hF;
				end
				7'h4: begin
					mem_addr	<=	11'h003;	// Read from address 0x003 (UART Data In)
					mem_out		<=	32'h0;
					mem_wr		<=	4'h0;
				end
				7'h5: begin
					mem_addr	<=	11'h004;	// Read from address 0x004 (UART Input Control 1)
					mem_out		<=	32'h0;
					mem_wr		<=	4'h0;
					u_din		<=	mem_in;
				end
				7'h6: begin
					mem_addr	<=	11'h403;	// Write to address 0x403 (UART Output Control 1)
					mem_out		<=	u_rco;
					mem_wr		<=	4'hF;
					u_con		<=	mem_in;
				end
				7'h7: begin
					mem_addr	<=	11'h404;	// Write to address 0x404 (UART Data Out)
					mem_out		<=	u_dat;
					mem_wr		<=	4'hF;
				end
				7'h8: begin
					mem_addr	<=	11'h005;	// Read from address 0x005 (I2C Data in)
					mem_out		<=	32'h0;
					mem_wr		<=	4'h0;
				end
				7'h9: begin
					mem_addr	<=	11'h006;	// Read from address 0x006 (I2C Input Control 1)
					mem_out		<=	32'h0;
					mem_wr		<=	4'h0;
					i_din		<=	mem_in;
				end
				7'hA: begin
					mem_addr	<=	11'h406;	// Write to address 0x406 (I2C Output control 1)
					mem_out		<=	i_rco;
					mem_wr		<=	4'hF;
					i_con		<=	mem_in;
				end
				7'hB: begin
					mem_addr	<=	11'h405;	// Write to address 0x405 (I2C Data out)
					mem_out		<=	i_dat;
					mem_wr		<=	4'hF;
				end
				default: begin
					mem_addr	<=	11'h000;
					mem_out		<=	32'h0;
					mem_wr		<=	4'h0;
				end
			endcase
		end
	end
	
endmodule