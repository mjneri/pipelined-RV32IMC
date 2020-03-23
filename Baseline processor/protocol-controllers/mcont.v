`timescale 1ns/1ps

module mcont(
	input				clk,
	input				nrst,
	
	input		[31:0]	mem_in,
	output reg	[6:0]	mem_addr,
	output reg	[31:0]	mem_out,
	output reg			mem_wr,
	output reg	[2:0]	mem_load,
	output reg	[1:0]	mem_store,
	
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
		clk,
		s_con[1],
		s_con[0],
		s_con[7],
		s_con[31:8],
		s_din[31:0],
		s_con[6:5],
		s_con[2],
		s_con[3],
		s_con[4],
		miso,
		sck,
		mosi,
		ss0,
		ss1,
		ss2,
		ss3,
		s_rco_t,
		s_dat_t
	);
	
	Encoder UART1(
        clk,
        nrst,
        u_din[7:0], 
        u_con[0],
        u_con[31:8],
        u_con[1],
        u_con[2],
        uart_enc,
        u_rco[5:0]
        );
        
    Decoder UART2(
    clk,
    nrst,
    uart_dec,        
    u_con[31:8],    
    u_con[1],        
    u_rco[6],        
    u_dat            
    );
    
	i2c I2C1(
		clk,
		nrst,
		i_din[31:0],
		i_con[31:0],
		i2c_scl_i,
		i2c_scl_o,
		i2c_scl_t,
		i2c_sda_i,
		i2c_sda_o,
		i2c_sda_t,
		i2c_slave_sda_o,
		i_dat,
		i_rco
	);
	
	always@(posedge clk or negedge nrst) begin
		if(!nrst) begin
			ctr			<=	7'h0;
			mem_addr	<=	7'h0;
			mem_out		<=	32'h0;
			mem_wr		<=	0;
			mem_load	<=	3'h0;
			mem_store	<=	2'h0;
			
			s_din		<=	32'h0;
			s_con		<=	32'h0;
			
			u_din		<=	32'h0;
			u_con		<=	32'h0;
			
			i_din		<=	32'h0;
			i_con		<=	32'h0;
			
		end
		else begin
			ctr		<=	ctr == 7'hB	?	7'h0	:	ctr + 7'h1;
			case(ctr) 
				7'h0: begin
					mem_addr	<=	7'h04;
					mem_out		<=	32'h0;
					mem_wr		<=	0;
				end
				7'h1: begin
					mem_addr	<=	7'h08;
					mem_out		<=	32'h0;
					mem_wr		<=	0;
					s_din		<=	mem_in;
				end
				7'h2: begin
					mem_addr	<=	7'h44;
					mem_out		<=	s_dat_t;
					mem_wr		<=	1;
					s_con		<=	mem_in;
				end
				7'h3: begin
					mem_addr	<=	7'h40;
					mem_out		<=	s_rco_t;
					mem_wr		<=	1;
				end
				7'h4: begin
					mem_addr	<=	7'h0C;
					mem_out		<=	32'h0;
					mem_wr		<=	0;
				end
				7'h5: begin
					mem_addr	<=	7'h10;
					mem_out		<=	32'h0;
					mem_wr		<=	0;
					u_din		<=	mem_in;
				end
				7'h6: begin
					mem_addr	<=	7'h4C;
					mem_out		<=	u_rco;
					mem_wr		<=	1;
					u_con		<=	mem_in;
				end
				7'h7: begin
					mem_addr	<=	7'h50;
					mem_out		<=	u_dat;
					mem_wr		<=	1;
				end
				7'h8: begin
					mem_addr	<=	7'h14;
					mem_out		<=	32'h0;
					mem_wr		<=	0;
				end
				7'h9: begin
					mem_addr	<=	7'h18;
					mem_out		<=	32'h0;
					mem_wr		<=	0;
					i_din		<=	mem_in;
				end
				7'hA: begin
					mem_addr	<=	7'h58;
					mem_out		<=	i_rco;
					mem_wr		<=	1;
					i_con		<=	mem_in;
				end
				7'hB: begin
					mem_addr	<=	7'h54;
					mem_out		<=	i_dat;
					mem_wr		<=	1;
				end
				default: begin
					mem_addr	<=	7'h000;
					mem_out		<=	32'h0;
					mem_wr		<=	0;
				end
			endcase
		end
	end
	
endmodule