`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/24/2020 06:22:42 PM
// Design Name: 
// Module Name: tb_i2c
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


module tb_i2c;

	// Inputs
    reg clk;
    reg nrst;
    reg [31:0] mem_data;
    reg [31:0] mem_control;

    //Inouts
    wire i2c_sda;
    wire i2c_scl;

    //Outputs
    //  wire [31:0] out_cnt;
    // wire [31:0] out_data;
    wire i2c_scl_i;
    wire i2c_sda_i;
    wire i2c_sda_t;
    wire i2c_sda_o;
    wire i2c_scl_t;
    wire i2c_scl_o;
    wire i2c_slave_sda_o;
    wire [31:0] i_data;
    wire [31:0] con_out;
    
    
    /*top uut(
        .clk(clk),
        .nrst(nrst),
        .mem_data(mem_data),
        .mem_control(mem_control),
        .i2c_outcontrol(out_cnt),
        .i2c_outdata(out_data),
        .i2c_sda(sda),
        .i2c_scl(scl)
    );*/

    i2c uut(
        // Inputs
        .clk(clk),
        .nrst(nrst),
        .memory_data(mem_data),
        .memory_control(mem_control),
        
        // Tri-state I2C Pins
        // inout i2c_scl_pin,
        // inout i2c_sda_pin
        .i2c_scl_i(i2c_scl_i),
        .i2c_scl_o(i2c_scl_o),
        .i2c_scl_t(i2c_scl_t),
        .i2c_sda_i(i2c_sda_i),
        .i2c_sda_o(i2c_sda_o),
        .i2c_sda_t(i2c_sda_t),
        .i2c_slave_sda_o(i2c_slave_sda_o),
        
        .i_dat(i_data),
        .con_out(con_out)
    );

    always begin
        #10 clk=~clk;
        // #10 scl=~scl;
    end

    assign i2c_scl = i2c_scl_t ? 1'bz : i2c_scl_o;	//tri state buffer -> for i2c, SDA and SCL can never be active high
    assign i2c_scl_i = i2c_scl;
        
    assign i2c_sda = (i2c_sda_t & i2c_slave_sda_o) ? 1'bz : 0;	//tri-state buffer -> for i2c, SDA and SCL can never be active high
    assign i2c_sda_i = i2c_sda;

    //assign sda = (wr==1) ? in : 1'bz;
    //assign scl = (wr==1) ? in : 1'bz;
        
    initial begin
        clk=0;
        nrst=0;
        
        #130 nrst=1;
        mem_data = 32'h11;
        mem_control = {16'd0,16'b0000000000000};
        
        #60
        mem_control = {16'd29, 16'h9};   //set prescale
        
        #60 
        mem_data = 32'h14;
        //mem_control = 32'h29CA;
        mem_control = {17'd0, 4'd1, 7'd1, 4'b0101};   //write 5 bit data to slave address 7'd1
        
        #1780
        mem_control = {17'd0, 4'd1, 7'd1, 4'b0011};   //read 5 bit data from slave address 7'd1
        
        //#30
        //mem_control = 32'h0;
    end
            
    
endmodule
