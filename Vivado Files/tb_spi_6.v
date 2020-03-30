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

        task test_spi();
                // inputs 
	        input TURNON;
	        input EN;
	        input MB;
	        input [23:0] PRESCALE;
	        input [31:0] DIN;
	        input [1:0] SEL;
	        input CPOL;
	        input CPHA;
	        input ORDER;
	        input MISO;

                begin
                        TURNON = turnon;
                        EN = enable;
                        MB = mb;
                        PRESCALE = prescale;
                        DIN = in;
                        SEL = select;
                        CPOL = cpol;
                        CPHA = cpha;
                        ORDER = order;
                        MISO = miso;  

                end


        endtask

        always
                #10 clk = ~clk;

        initial begin
        /*
	        input TURNON;
	        input EN;
	        input MB;
	        input [23:0] PRESCALE; // 4 bits onli
	        input [31:0] DIN;
	        input [1:0] SEL;
	        input CPOL;
	        input CPHA;
	        input ORDER;
	        input MISO;

        
        */

                clk = 0;

                #40 
                #20 test_spi(0, 0, 0, {20'd0, $random%4}, $random%32, $random%2, 0, 0, 0, 0);
                #20 test_spi(0, 0, 0, {20'd0, $random%4}, $random%32, $random%2, 0, 0, 0, 0);
                #20 test_spi(0, 0, 0, {20'd0, $random%4}, $random%32, $random%2, 0, 1, 0, 1);
                #20 test_spi(0, 0, 0, {20'd0, $random%4}, $random%32, $random%2, 0, 0, 1, 1);
                #20 test_spi(1, 0, 0, {20'd0, $random%4}, $random%32, $random%2, 1, 0, 1, 1);
                
                #300 test_spi(1, 0, 1, {20'd0, $random%4}, $random%32, $random%2, 1, 0, 1, 1);
         
                #50 test_spi(1, 1, 1, {20'd0, $random%4}, $random%32, $random%2, 1, 0, 0, 0);
                #20 test_spi(1, 1, 1, {20'd0, $random%4}, $random%32, $random%2, 1, 1, 0, 0);
                #20 test_spi(1, 1, 1, {20'd0, $random%4}, $random%32, $random%2, 1, 0, 0, 0);
                #20 test_spi(1, 1, 1, {20'd0, $random%4}, $random%32, $random%2, 0, 1, 0, 1);

                #300 test_spi(1, 0, 1, {20'd0, $random%4}, $random%32, $random%2, 1, 0, 1, 1);
         
                #50 test_spi(1, 1, 1, {20'd0, $random%4}, $random%32, $random%2, 1, 0, 0, 0);
                #20 test_spi(1, 1, 1, {20'd0, $random%4}, $random%32, $random%2, 1, 1, 0, 0);
                #50 test_spi(1, 1, 1, {20'd0, $random%4}, $random%32, $random%2, 1, 1, 0, 1);

                #200 test_spi(1, 1, 1, {20'd0, $random%4}, $random%32, $random%2, 1, 1, 1, 1);

                #20 test_spi(1, 1, 1, {20'd0, $random%4}, $random%32, $random%2, 1, 1, 1, 0);

                #600 test_spi(1, 1, 1, {20'd0, $random%4}, $random%32, $random%2, 0, 1, 1, 0);
                #60 test_spi(1, 1, 1, {20'd0, $random%4}, $random%32, $random%2, 0, 1, 0, 1);

                #700 test_spi(1, 1, 1, {20'd0, $random%4}, $random%32, $random%2, 0, 0, 1, 1);



                #500 $finish;          


        end
        




endmodule