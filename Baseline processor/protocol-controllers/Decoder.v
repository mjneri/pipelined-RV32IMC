`timescale 1ns / 1ps

module Decoder(
  input clk,
  input nrst,
  input data_in,
  input wire [23:0] baud,
  input wire parity,
  output reg done,
  output reg [31:0] data_out
);

  parameter data_width = 3'd7;

  wire [31:0] clk_per_bit;
  assign clk_per_bit = 32'd12500000 / baud;
  
  parameter s_idle = 3'd0;
  parameter s_start = 3'd1;
  parameter s_data = 3'd2;
  parameter s_parity = 3'd3;
  parameter s_stop = 3'd4;
  
  
  reg r_data = 1'b1;

  reg [2:0] state;
  reg [31:0] clk_count;
  reg [7:0] bit_index;
  reg [31:0] width_add;
  reg parity_bit;

  always@(*)
    begin
      r_data <= data_in;
      case(state)
          s_stop:
              done <= 1;
          default: 
              done <= 0;
      endcase
    end

  always@(posedge clk)
    begin
      if(!nrst)
        begin
          state <= s_idle;
          clk_count <= 0;
          bit_index <= 0;
          data_out <= 0;
          width_add <= 0;
        end
      else
        begin
          case(state)
            s_idle:
              begin
                if (r_data == 1'b0)      
                  state <= s_start;
                else
                  state <= s_idle;
              end
            s_start:
              begin
                if (clk_count == (clk_per_bit-1)/2)
                  begin
                    if (r_data == 1'b0)
                      begin
                        clk_count <= 0;  
                        state <= s_data;
                        if(bit_index >= 8'd7)
                          begin
                            bit_index = bit_index + 1;
                            width_add = width_add + 1;
                          end
                      end
                    else
                      state <= s_idle;
                  end
                else
                  begin
                    clk_count <= clk_count + 1;
                    state <= s_start;
                  end
              end   
            s_data:
              begin
                if (clk_count < clk_per_bit-1)
                  begin
                    clk_count <= clk_count + 1;
                    state <= s_data;
                  end
                else
                  begin
                    clk_count <= 0;
                    if (bit_index < data_width+width_add)
                      begin
                        bit_index <= bit_index + 1;
                        data_out[bit_index] <= r_data;
                        state <= s_data;
                      end
                    else
                      begin
                        width_add <= width_add + 32'd7;
                        data_out[bit_index] <= r_data;
						if(parity) state <= s_parity;
                        state <= s_stop;
                      end
                  end
              end
            s_parity:
              begin
                if(clk_count < clk_per_bit-1) 
                  begin
                      clk_count <= clk_count+1;
                      state <= s_parity;
                  end
                else 
                  begin
                      clk_count <= 0;
                      parity_bit <= data_out[7] ^ data_out[6] ^ data_out[5] ^ data_out[4] ^ data_out[3] ^ data_out[2] ^ data_out[1] ^ data_out[0];
                      state <= s_stop;
                  end
              end
            s_stop:
              begin
                if (clk_count < clk_per_bit-1)
                  begin
                    clk_count <= clk_count + 1;
                    state <= s_stop;
                  end
                else
                  begin
                    clk_count <= 0;
                    state <= s_idle;
                  end
              end
            default:
              state <= s_idle;
          endcase
        end
    end
endmodule