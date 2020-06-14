`timescale 1ns / 1ps
// Adjusted delays for 50 MHz clock
module tb_spi();
        reg clk;
	
	reg turnon;
	reg enable;
	
	reg [23:0] prescale;
	
	reg [31:0] din;
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
                .prescale(prescale),
                .din(din),
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

        // task test_spi();
        //         // inputs 
	    //     input TURNON;
	    //     input EN;
	    //     input MB;
	    //     input [23:0] PRESCALE;
	    //     input [31:0] DIN;
	    //     input [1:0] SEL;
	    //     input CPOL;
	    //     input CPHA;
	    //     input ORDER;
	    //     input MISO;

        //         begin
        //                 turnon = TURNON;
        //                 enable = EN;
        //                 mb = MB;
        //                 prescale = PRESCALE;
        //                 din = DIN;
        //                 select = SEL;
        //                 cpol = CPOL;
        //                 cpha = CPHA;
        //                 order = ORDER;
        //                 miso = MISO;  

        //         end
        // endtask

        always
            #10 clk = ~clk;

        initial begin

			clk = 0;
			turnon = 0;
			enable = 0;
			prescale = 0;
			din = 0;
			select = 0;
			order = 0;
			cpha = 0;
			cpol = 0;
			miso = 0;

			#100 prescale = 24'd124;
			#100 cpol = 1;
					cpha = 1;
					order = 0;
			#100 enable = 1;
			#100 din = 32'hade1b055;
			#100 select = 2'h2;
			#100 turnon = 1;


			// #100 
			// #200 test_spi(0, 0, 0, {20'd0, $random%4}, $random%32, $random%2, 0, 0, 0, 0);
			// #200 test_spi(0, 0, 0, {20'd0, $random%4}, $random%32, $random%2, 0, 0, 0, 0);
			// #200 test_spi(0, 0, 0, {20'd0, $random%4}, $random%32, $random%2, 0, 1, 0, 1);
			// // Enable
			// #200 test_spi(0, 1, 0, {20'd0, $random%4}, $random%32, $random%2, 0, 0, 1, 1);
			// // Turn on
			// #2000 test_spi(1, 1, 0, {20'd0, $random%4}, $random%32, $random%2, 1, 0, 1, 1);
			// // Turn on, disable, mb
			// #3000 test_spi(1, 0, 1, {20'd0, $random%4}, $random%32, $random%2, 1, 0, 1, 1);
		
			// #500 test_spi(0, 1, 1, {20'd0, $random%4}, $random%32, $random%2, 1, 0, 0, 0);
			// #2000 test_spi(1, 1, 1, {20'd0, $random%4}, $random%32, $random%2, 1, 1, 0, 0);
			// #2000 test_spi(1, 1, 1, {20'd0, $random%4}, $random%32, $random%2, 1, 0, 0, 0);
			// #200 test_spi(1, 1, 1, {20'd0, $random%4}, $random%32, $random%2, 0, 1, 0, 1);

			// #300 test_spi(0, 0, 1, {20'd0, $random%4}, $random%32, $random%2, 1, 0, 1, 1);
		
			// #250 test_spi(1, 0, 1, {20'd0, $random%4}, $random%32, $random%2, 1, 0, 0, 0);
			// #200 test_spi(1, 1, 1, {20'd0, $random%4}, $random%32, $random%2, 1, 1, 0, 0);
			// #500 test_spi(1, 1, 1, {20'd0, $random%4}, $random%32, $random%2, 1, 1, 0, 1);

			// #2000 test_spi(1, 1, 1, {20'd0, $random%4}, $random%32, $random%2, 1, 1, 1, 1);

			// #200 test_spi(0, 1, 1, {20'd0, $random%4}, $random%32, $random%2, 1, 1, 1, 0);

			// #6000 test_spi(1, 0, 1, {20'd0, $random%4}, $random%32, $random%2, 0, 1, 1, 0);
			// #600 test_spi(1, 1, 1, {20'd0, $random%4}, $random%32, $random%2, 0, 1, 0, 1);

			// #7000 test_spi(1, 1, 1, {20'd0, $random%4}, $random%32, $random%2, 0, 0, 1, 1);



			// #500 $finish;          


        end
        




endmodule