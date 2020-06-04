// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Mon May 11 20:12:41 2020
// Host        : Kouzui running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               C:/Users/MJ/Documents/Vivado/pipelined-RV32IMC/pipelined-RV32IMC.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_stub.v
// Design      : clk_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35ticsg324-1L
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_0(clkfb_in, clk_out1, clkfb_out, locked, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clkfb_in,clk_out1,clkfb_out,locked,clk_in1" */;
  input clkfb_in;
  output clk_out1;
  output clkfb_out;
  output locked;
  input clk_in1;
endmodule
