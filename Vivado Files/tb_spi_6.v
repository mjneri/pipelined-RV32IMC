timescale 1ns / 1ps

module tb_spi();
        reg clk;
	
	reg turnon;
	reg enable;
	
	reg mb;
	
	reg [23:0] prescale;
	
	reg [31:0] in;
	reg [1:0] select;
	
	reg cpol;
	reg cpha;
	reg order;
	
	reg miso;
	wire sck;
	wire mosi;
	
	wire ss0;
	wire ss1;
	wire ss2;
	wire ss3;
	
	wire [31:0] rco;
	wire [31:0] dat;


        spi SPI1(
                .clk(clk),
                .turnon(turnon),
                .enable(enable),
                .mb(mb),
                .prescale(prescale),
                .in(in),
                .select(select),
                .cpol(cpol),
                .cpha(cpha),
                .order(order),
                .miso(miso),

                .sck(sck),
                .mosi(mosi),
                .ss0(ss0),
                .ss1(ss1),
                .ss2(ss2),
                .ss3(ss3),
                .rco(rco),
                .dat(dat)
        );

        always
                #10 clk = ~clk;

        



        );


endmodule