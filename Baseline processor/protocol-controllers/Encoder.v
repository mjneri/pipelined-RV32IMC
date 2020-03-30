`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.03.2019 18:39:51
// Design Name: 
// Module Name: Encoder
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


module Encoder(
    input clk,
    input nrst,
    input [7:0] data_in_mem,
    input wr,
    input [23:0] baudcontrol,
    input parity,
    input last_byte,
    output reg data_out,
    output reg [31:0] u_rco
);
    
    // CLKS_PER_BIT = (Frequency of i_Clock)/(Frequency of UART)
    // Example: 10 MHz Clock, 115200 baud UART
    // (10000000)/(115200) = 87
    //parameter baud = 2'd1;
    //parameter data_in = 72'hEFE90100001106FF7E;
    
    wire [31:0] clk_per_bit = baudcontrol;
    parameter data_width = 3'd7;
    
	parameter [7*8:0] s_idle = "___IDLE",
					  s_start = "__START",
					  s_data = "___DATA",
					  s_stop = "___STOP",
					  s_parity = "_PARITY";
	// parameter s_idle = 3'd0;
	// parameter s_start = 3'd1;
	// parameter s_data = 3'd2;
	// parameter s_stop = 3'd3;
	// parameter s_parity = 3'd4;
    
    reg [2:0] state;
    reg [31:0] clk_count;
    reg [7:0] bit_index;
    reg [7:0] data;
    reg [31:0] width_add;
    reg parity_bit;
    reg en;
    
    //wire     rd;
    
    //reg     [7:0] data_in_mem;  
    // 6. DUT Output wires  
    wire     [7:0] data_out_mem;  
    wire     fifo_empty;  
    wire     fifo_full;  
    wire     fifo_threshold;  
    wire     fifo_overflow;  
    wire     fifo_underflow;  
    wire     [4:0] wptr;
    
    // Initializing registers
    initial begin
        state <= s_idle;
        clk_count <= 0;
        bit_index <= 0;
        data <= 0;
        width_add <= 0;
        en <= 0;
    end

    // 7. DUT Instantiation
   // fpga4student.com: FPga projects, Verilog projects, VHDL projects  
    fifo_mem FIFO (
		// Inputs
		.clk(clk),
		.nrst(nrst),
		.wr(!wr & en),
		.fifo_clr(u_rco[0] & fifo_empty),
		.rd((bit_index == 8'd7) & (clk_count == 32'd0)),
		.data_in(data_in_mem),

		// Outputs
		.data_out(data_out_mem),
		.fifo_full(fifo_full),
		.fifo_empty(fifo_empty),
		.fifo_threshold(fifo_threshold),
		.fifo_overflow(fifo_overflow),
		.fifo_underflow(fifo_underflow),
		.wptr(wptr)
	); 

    always@(posedge clk) begin
        if(!nrst) begin
            state <= s_idle;
            clk_count <= 0;
            bit_index <= 0;
            data <= 0;
            width_add <= 0;
            en <= 0;
        end
        else begin
            case(state)
                s_idle: begin
                    if((last_byte|u_rco[0])&!fifo_empty) begin
                        state <= s_start;
                        data <= data_out_mem;
                        parity_bit <= data_out_mem[7] ^ data_out_mem[6] ^ data_out_mem[5] ^ data_out_mem[4] ^ data_out_mem[3] ^ data_out_mem[2] ^ data_out_mem[1] ^ data_out_mem[0];
                    end
                    else state <= s_idle;
                    en <= wr;
                    end
                s_start:
                    if(clk_count < clk_per_bit-1) begin
                        clk_count <= clk_count+1;
                        state <= s_start;
                    end
                    else begin
                        clk_count <= 0;
                        state <= s_data;
                    end
                s_data:
                    if(clk_count < clk_per_bit-1) begin
                        clk_count <= clk_count+1;
                        state <= s_data;
                    end
                    else begin
                        clk_count <= 0;
                        if(bit_index < data_width) begin
                            bit_index <= bit_index + 32'd1;
                            data <= {1'd0,data[7:1]};
                            state <= s_data;
                         end
                         else begin
                            bit_index <= 0;
                            data <= {1'd0,data[7:1]};
                            if(parity) state <= s_parity;
                            state <= s_stop;
                         end
                    end
                s_parity:
                    if(clk_count < clk_per_bit-1) begin
                        clk_count <= clk_count+1;
                        state <= s_parity;
                    end
                    else begin
                        clk_count <= 0;
                        state <= s_stop;
                    end
                s_stop:
                    if(clk_count < clk_per_bit-1) begin
                        clk_count <= clk_count+1;
                        state <= s_stop;
                    end
                    else begin
                        clk_count <= 0;
                        if((last_byte|u_rco[0])&!fifo_empty) begin
                            state <= s_start;
                            data <= data_out_mem;
                            parity_bit <= data_out_mem[7] ^ data_out_mem[6] ^ data_out_mem[5] ^ data_out_mem[4] ^ data_out_mem[3] ^ data_out_mem[2] ^ data_out_mem[1] ^ data_out_mem[0];
                        end
                        else state <= s_idle;
                    end
                default:
                    state <= s_idle;
            endcase
        end
    end

    always@(*) begin
        case(state)
            s_idle: begin
                data_out <= 1;
                u_rco[0] <= 0;
                u_rco[5:1] <= wptr[4:0];
                end
            s_start: begin
                data_out <= 0;
                u_rco <= 0;
                end
            s_data: begin
                data_out <= data[0];
                u_rco[0] <= 0;
                end
            s_stop: begin
                data_out <= 1;
                u_rco[0] <= 1;
                end
            s_parity: begin
                data_out <= parity_bit;
                u_rco <= 0;
                end
            default: begin
                data_out <= 1;
                u_rco <= 0;
                end
        endcase
    end
endmodule