// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Sat Mar 14 15:52:02 2020
// Host        : Kouzui running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/MJ/Documents/Vivado/pipelined-RV32IMC/pipelined-RV32IMC.srcs/sources_1/ip/vio_core/vio_core_stub.v
// Design      : vio_core
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35ticsg324-1L
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "vio,Vivado 2019.2" *)
module vio_core(clk, probe_in0, probe_in1, probe_in2, probe_in3, 
  probe_in4, probe_in5, probe_in6, probe_in7, probe_in8, probe_in9, probe_in10, probe_in11, 
  probe_in12, probe_in13, probe_in14, probe_in15, probe_in16, probe_in17, probe_in18, probe_out0)
/* synthesis syn_black_box black_box_pad_pin="clk,probe_in0[11:0],probe_in1[11:0],probe_in2[11:0],probe_in3[11:0],probe_in4[11:0],probe_in5[31:0],probe_in6[0:0],probe_in7[0:0],probe_in8[0:0],probe_in9[0:0],probe_in10[11:0],probe_in11[0:0],probe_in12[0:0],probe_in13[0:0],probe_in14[3:0],probe_in15[31:0],probe_in16[2:0],probe_in17[31:0],probe_in18[0:0],probe_out0[0:0]" */;
  input clk;
  input [11:0]probe_in0;
  input [11:0]probe_in1;
  input [11:0]probe_in2;
  input [11:0]probe_in3;
  input [11:0]probe_in4;
  input [31:0]probe_in5;
  input [0:0]probe_in6;
  input [0:0]probe_in7;
  input [0:0]probe_in8;
  input [0:0]probe_in9;
  input [11:0]probe_in10;
  input [0:0]probe_in11;
  input [0:0]probe_in12;
  input [0:0]probe_in13;
  input [3:0]probe_in14;
  input [31:0]probe_in15;
  input [2:0]probe_in16;
  input [31:0]probe_in17;
  input [0:0]probe_in18;
  output [0:0]probe_out0;
endmodule
