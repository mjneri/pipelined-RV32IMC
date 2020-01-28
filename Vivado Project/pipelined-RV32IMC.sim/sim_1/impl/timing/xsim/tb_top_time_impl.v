// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Sun Jan 26 21:38:02 2020
// Host        : Kouzui running 64-bit major release  (build 9200)
// Command     : write_verilog -mode timesim -nolib -sdf_anno true -force -file
//               C:/Users/MJ/Documents/Vivado/pipelined-RV32IMC/pipelined-RV32IMC.sim/sim_1/impl/timing/xsim/tb_top_time_impl.v
// Design      : top
// Purpose     : This verilog netlist is a timing simulation representation of the design and should not be modified or
//               synthesized. Please ensure that this netlist is used with the corresponding SDF file.
// Device      : xc7a35ticsg324-1L
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps
`define XIL_TIMING

module pc
   (O7,
    p_0_in,
    CLK,
    nrst_IBUF);
  output [9:0]O7;
  output p_0_in;
  input CLK;
  input nrst_IBUF;

  wire CLK;
  wire [9:0]O7;
  wire \inst_addr[2]_i_2_n_0 ;
  wire \inst_addr_reg[10]_i_1_n_6 ;
  wire \inst_addr_reg[10]_i_1_n_7 ;
  wire \inst_addr_reg[2]_i_1_n_0 ;
  wire \inst_addr_reg[2]_i_1_n_4 ;
  wire \inst_addr_reg[2]_i_1_n_5 ;
  wire \inst_addr_reg[2]_i_1_n_6 ;
  wire \inst_addr_reg[2]_i_1_n_7 ;
  wire \inst_addr_reg[6]_i_1_n_0 ;
  wire \inst_addr_reg[6]_i_1_n_4 ;
  wire \inst_addr_reg[6]_i_1_n_5 ;
  wire \inst_addr_reg[6]_i_1_n_6 ;
  wire \inst_addr_reg[6]_i_1_n_7 ;
  wire nrst_IBUF;
  wire p_0_in;
  wire [3:0]\NLW_inst_addr_reg[10]_i_1_CO_UNCONNECTED ;
  wire [3:2]\NLW_inst_addr_reg[10]_i_1_O_UNCONNECTED ;
  wire [2:0]\NLW_inst_addr_reg[2]_i_1_CO_UNCONNECTED ;
  wire [2:0]\NLW_inst_addr_reg[6]_i_1_CO_UNCONNECTED ;

  LUT1 #(
    .INIT(2'h1)) 
    \id_PC[11]_i_1 
       (.I0(nrst_IBUF),
        .O(p_0_in));
  LUT1 #(
    .INIT(2'h1)) 
    \inst_addr[2]_i_2 
       (.I0(O7[0]),
        .O(\inst_addr[2]_i_2_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \inst_addr_reg[10] 
       (.C(CLK),
        .CE(1'b1),
        .D(\inst_addr_reg[10]_i_1_n_7 ),
        .Q(O7[8]),
        .R(p_0_in));
  (* OPT_MODIFIED = "SWEEP" *) 
  CARRY4 \inst_addr_reg[10]_i_1 
       (.CI(\inst_addr_reg[6]_i_1_n_0 ),
        .CO(\NLW_inst_addr_reg[10]_i_1_CO_UNCONNECTED [3:0]),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\NLW_inst_addr_reg[10]_i_1_O_UNCONNECTED [3:2],\inst_addr_reg[10]_i_1_n_6 ,\inst_addr_reg[10]_i_1_n_7 }),
        .S({1'b0,1'b0,O7[9:8]}));
  FDRE #(
    .INIT(1'b0)) 
    \inst_addr_reg[11] 
       (.C(CLK),
        .CE(1'b1),
        .D(\inst_addr_reg[10]_i_1_n_6 ),
        .Q(O7[9]),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \inst_addr_reg[2] 
       (.C(CLK),
        .CE(1'b1),
        .D(\inst_addr_reg[2]_i_1_n_7 ),
        .Q(O7[0]),
        .R(p_0_in));
  (* OPT_MODIFIED = "SWEEP" *) 
  CARRY4 \inst_addr_reg[2]_i_1 
       (.CI(1'b0),
        .CO({\inst_addr_reg[2]_i_1_n_0 ,\NLW_inst_addr_reg[2]_i_1_CO_UNCONNECTED [2:0]}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b1}),
        .O({\inst_addr_reg[2]_i_1_n_4 ,\inst_addr_reg[2]_i_1_n_5 ,\inst_addr_reg[2]_i_1_n_6 ,\inst_addr_reg[2]_i_1_n_7 }),
        .S({O7[3:1],\inst_addr[2]_i_2_n_0 }));
  FDRE #(
    .INIT(1'b0)) 
    \inst_addr_reg[3] 
       (.C(CLK),
        .CE(1'b1),
        .D(\inst_addr_reg[2]_i_1_n_6 ),
        .Q(O7[1]),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \inst_addr_reg[4] 
       (.C(CLK),
        .CE(1'b1),
        .D(\inst_addr_reg[2]_i_1_n_5 ),
        .Q(O7[2]),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \inst_addr_reg[5] 
       (.C(CLK),
        .CE(1'b1),
        .D(\inst_addr_reg[2]_i_1_n_4 ),
        .Q(O7[3]),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \inst_addr_reg[6] 
       (.C(CLK),
        .CE(1'b1),
        .D(\inst_addr_reg[6]_i_1_n_7 ),
        .Q(O7[4]),
        .R(p_0_in));
  (* OPT_MODIFIED = "SWEEP" *) 
  CARRY4 \inst_addr_reg[6]_i_1 
       (.CI(\inst_addr_reg[2]_i_1_n_0 ),
        .CO({\inst_addr_reg[6]_i_1_n_0 ,\NLW_inst_addr_reg[6]_i_1_CO_UNCONNECTED [2:0]}),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\inst_addr_reg[6]_i_1_n_4 ,\inst_addr_reg[6]_i_1_n_5 ,\inst_addr_reg[6]_i_1_n_6 ,\inst_addr_reg[6]_i_1_n_7 }),
        .S(O7[7:4]));
  FDRE #(
    .INIT(1'b0)) 
    \inst_addr_reg[7] 
       (.C(CLK),
        .CE(1'b1),
        .D(\inst_addr_reg[6]_i_1_n_6 ),
        .Q(O7[5]),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \inst_addr_reg[8] 
       (.C(CLK),
        .CE(1'b1),
        .D(\inst_addr_reg[6]_i_1_n_5 ),
        .Q(O7[6]),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \inst_addr_reg[9] 
       (.C(CLK),
        .CE(1'b1),
        .D(\inst_addr_reg[6]_i_1_n_4 ),
        .Q(O7[7]),
        .R(p_0_in));
endmodule

module pipereg_exe_mem
   (Q,
    p_0_in,
    O2,
    CLK,
    lopt,
    lopt_1,
    lopt_2,
    lopt_3,
    lopt_4,
    lopt_5,
    lopt_6,
    lopt_7,
    lopt_8,
    lopt_9);
  output [9:0]Q;
  input p_0_in;
  input [9:0]O2;
  input CLK;
  output lopt;
  output lopt_1;
  output lopt_2;
  output lopt_3;
  output lopt_4;
  output lopt_5;
  output lopt_6;
  output lopt_7;
  output lopt_8;
  output lopt_9;

  wire CLK;
  wire [9:0]O2;
  wire [9:0]Q;
  wire \mem_PC_reg[10]_lopt_replica_1 ;
  wire \mem_PC_reg[11]_lopt_replica_1 ;
  wire \mem_PC_reg[2]_lopt_replica_1 ;
  wire \mem_PC_reg[3]_lopt_replica_1 ;
  wire \mem_PC_reg[4]_lopt_replica_1 ;
  wire \mem_PC_reg[5]_lopt_replica_1 ;
  wire \mem_PC_reg[6]_lopt_replica_1 ;
  wire \mem_PC_reg[7]_lopt_replica_1 ;
  wire \mem_PC_reg[8]_lopt_replica_1 ;
  wire \mem_PC_reg[9]_lopt_replica_1 ;
  wire p_0_in;

  assign lopt = \mem_PC_reg[10]_lopt_replica_1 ;
  assign lopt_1 = \mem_PC_reg[11]_lopt_replica_1 ;
  assign lopt_2 = \mem_PC_reg[2]_lopt_replica_1 ;
  assign lopt_3 = \mem_PC_reg[3]_lopt_replica_1 ;
  assign lopt_4 = \mem_PC_reg[4]_lopt_replica_1 ;
  assign lopt_5 = \mem_PC_reg[5]_lopt_replica_1 ;
  assign lopt_6 = \mem_PC_reg[6]_lopt_replica_1 ;
  assign lopt_7 = \mem_PC_reg[7]_lopt_replica_1 ;
  assign lopt_8 = \mem_PC_reg[8]_lopt_replica_1 ;
  assign lopt_9 = \mem_PC_reg[9]_lopt_replica_1 ;
  FDRE #(
    .INIT(1'b0)) 
    \mem_PC_reg[10] 
       (.C(CLK),
        .CE(1'b1),
        .D(O2[8]),
        .Q(Q[8]),
        .R(p_0_in));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDRE #(
    .INIT(1'b0)) 
    \mem_PC_reg[10]_lopt_replica 
       (.C(CLK),
        .CE(1'b1),
        .D(O2[8]),
        .Q(\mem_PC_reg[10]_lopt_replica_1 ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \mem_PC_reg[11] 
       (.C(CLK),
        .CE(1'b1),
        .D(O2[9]),
        .Q(Q[9]),
        .R(p_0_in));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDRE #(
    .INIT(1'b0)) 
    \mem_PC_reg[11]_lopt_replica 
       (.C(CLK),
        .CE(1'b1),
        .D(O2[9]),
        .Q(\mem_PC_reg[11]_lopt_replica_1 ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \mem_PC_reg[2] 
       (.C(CLK),
        .CE(1'b1),
        .D(O2[0]),
        .Q(Q[0]),
        .R(p_0_in));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDRE #(
    .INIT(1'b0)) 
    \mem_PC_reg[2]_lopt_replica 
       (.C(CLK),
        .CE(1'b1),
        .D(O2[0]),
        .Q(\mem_PC_reg[2]_lopt_replica_1 ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \mem_PC_reg[3] 
       (.C(CLK),
        .CE(1'b1),
        .D(O2[1]),
        .Q(Q[1]),
        .R(p_0_in));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDRE #(
    .INIT(1'b0)) 
    \mem_PC_reg[3]_lopt_replica 
       (.C(CLK),
        .CE(1'b1),
        .D(O2[1]),
        .Q(\mem_PC_reg[3]_lopt_replica_1 ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \mem_PC_reg[4] 
       (.C(CLK),
        .CE(1'b1),
        .D(O2[2]),
        .Q(Q[2]),
        .R(p_0_in));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDRE #(
    .INIT(1'b0)) 
    \mem_PC_reg[4]_lopt_replica 
       (.C(CLK),
        .CE(1'b1),
        .D(O2[2]),
        .Q(\mem_PC_reg[4]_lopt_replica_1 ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \mem_PC_reg[5] 
       (.C(CLK),
        .CE(1'b1),
        .D(O2[3]),
        .Q(Q[3]),
        .R(p_0_in));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDRE #(
    .INIT(1'b0)) 
    \mem_PC_reg[5]_lopt_replica 
       (.C(CLK),
        .CE(1'b1),
        .D(O2[3]),
        .Q(\mem_PC_reg[5]_lopt_replica_1 ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \mem_PC_reg[6] 
       (.C(CLK),
        .CE(1'b1),
        .D(O2[4]),
        .Q(Q[4]),
        .R(p_0_in));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDRE #(
    .INIT(1'b0)) 
    \mem_PC_reg[6]_lopt_replica 
       (.C(CLK),
        .CE(1'b1),
        .D(O2[4]),
        .Q(\mem_PC_reg[6]_lopt_replica_1 ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \mem_PC_reg[7] 
       (.C(CLK),
        .CE(1'b1),
        .D(O2[5]),
        .Q(Q[5]),
        .R(p_0_in));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDRE #(
    .INIT(1'b0)) 
    \mem_PC_reg[7]_lopt_replica 
       (.C(CLK),
        .CE(1'b1),
        .D(O2[5]),
        .Q(\mem_PC_reg[7]_lopt_replica_1 ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \mem_PC_reg[8] 
       (.C(CLK),
        .CE(1'b1),
        .D(O2[6]),
        .Q(Q[6]),
        .R(p_0_in));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDRE #(
    .INIT(1'b0)) 
    \mem_PC_reg[8]_lopt_replica 
       (.C(CLK),
        .CE(1'b1),
        .D(O2[6]),
        .Q(\mem_PC_reg[8]_lopt_replica_1 ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \mem_PC_reg[9] 
       (.C(CLK),
        .CE(1'b1),
        .D(O2[7]),
        .Q(Q[7]),
        .R(p_0_in));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDRE #(
    .INIT(1'b0)) 
    \mem_PC_reg[9]_lopt_replica 
       (.C(CLK),
        .CE(1'b1),
        .D(O2[7]),
        .Q(\mem_PC_reg[9]_lopt_replica_1 ),
        .R(p_0_in));
endmodule

module pipereg_id_exe
   (Q,
    p_0_in,
    O3,
    CLK,
    lopt,
    lopt_1,
    lopt_2,
    lopt_3,
    lopt_4,
    lopt_5,
    lopt_6,
    lopt_7,
    lopt_8,
    lopt_9);
  output [9:0]Q;
  input p_0_in;
  input [9:0]O3;
  input CLK;
  output lopt;
  output lopt_1;
  output lopt_2;
  output lopt_3;
  output lopt_4;
  output lopt_5;
  output lopt_6;
  output lopt_7;
  output lopt_8;
  output lopt_9;

  wire CLK;
  wire [9:0]O3;
  wire [9:0]Q;
  wire \exe_PC_reg[10]_lopt_replica_1 ;
  wire \exe_PC_reg[11]_lopt_replica_1 ;
  wire \exe_PC_reg[2]_lopt_replica_1 ;
  wire \exe_PC_reg[3]_lopt_replica_1 ;
  wire \exe_PC_reg[4]_lopt_replica_1 ;
  wire \exe_PC_reg[5]_lopt_replica_1 ;
  wire \exe_PC_reg[6]_lopt_replica_1 ;
  wire \exe_PC_reg[7]_lopt_replica_1 ;
  wire \exe_PC_reg[8]_lopt_replica_1 ;
  wire \exe_PC_reg[9]_lopt_replica_1 ;
  wire p_0_in;

  assign lopt = \exe_PC_reg[10]_lopt_replica_1 ;
  assign lopt_1 = \exe_PC_reg[11]_lopt_replica_1 ;
  assign lopt_2 = \exe_PC_reg[2]_lopt_replica_1 ;
  assign lopt_3 = \exe_PC_reg[3]_lopt_replica_1 ;
  assign lopt_4 = \exe_PC_reg[4]_lopt_replica_1 ;
  assign lopt_5 = \exe_PC_reg[5]_lopt_replica_1 ;
  assign lopt_6 = \exe_PC_reg[6]_lopt_replica_1 ;
  assign lopt_7 = \exe_PC_reg[7]_lopt_replica_1 ;
  assign lopt_8 = \exe_PC_reg[8]_lopt_replica_1 ;
  assign lopt_9 = \exe_PC_reg[9]_lopt_replica_1 ;
  FDRE #(
    .INIT(1'b0)) 
    \exe_PC_reg[10] 
       (.C(CLK),
        .CE(1'b1),
        .D(O3[8]),
        .Q(Q[8]),
        .R(p_0_in));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDRE #(
    .INIT(1'b0)) 
    \exe_PC_reg[10]_lopt_replica 
       (.C(CLK),
        .CE(1'b1),
        .D(O3[8]),
        .Q(\exe_PC_reg[10]_lopt_replica_1 ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \exe_PC_reg[11] 
       (.C(CLK),
        .CE(1'b1),
        .D(O3[9]),
        .Q(Q[9]),
        .R(p_0_in));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDRE #(
    .INIT(1'b0)) 
    \exe_PC_reg[11]_lopt_replica 
       (.C(CLK),
        .CE(1'b1),
        .D(O3[9]),
        .Q(\exe_PC_reg[11]_lopt_replica_1 ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \exe_PC_reg[2] 
       (.C(CLK),
        .CE(1'b1),
        .D(O3[0]),
        .Q(Q[0]),
        .R(p_0_in));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDRE #(
    .INIT(1'b0)) 
    \exe_PC_reg[2]_lopt_replica 
       (.C(CLK),
        .CE(1'b1),
        .D(O3[0]),
        .Q(\exe_PC_reg[2]_lopt_replica_1 ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \exe_PC_reg[3] 
       (.C(CLK),
        .CE(1'b1),
        .D(O3[1]),
        .Q(Q[1]),
        .R(p_0_in));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDRE #(
    .INIT(1'b0)) 
    \exe_PC_reg[3]_lopt_replica 
       (.C(CLK),
        .CE(1'b1),
        .D(O3[1]),
        .Q(\exe_PC_reg[3]_lopt_replica_1 ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \exe_PC_reg[4] 
       (.C(CLK),
        .CE(1'b1),
        .D(O3[2]),
        .Q(Q[2]),
        .R(p_0_in));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDRE #(
    .INIT(1'b0)) 
    \exe_PC_reg[4]_lopt_replica 
       (.C(CLK),
        .CE(1'b1),
        .D(O3[2]),
        .Q(\exe_PC_reg[4]_lopt_replica_1 ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \exe_PC_reg[5] 
       (.C(CLK),
        .CE(1'b1),
        .D(O3[3]),
        .Q(Q[3]),
        .R(p_0_in));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDRE #(
    .INIT(1'b0)) 
    \exe_PC_reg[5]_lopt_replica 
       (.C(CLK),
        .CE(1'b1),
        .D(O3[3]),
        .Q(\exe_PC_reg[5]_lopt_replica_1 ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \exe_PC_reg[6] 
       (.C(CLK),
        .CE(1'b1),
        .D(O3[4]),
        .Q(Q[4]),
        .R(p_0_in));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDRE #(
    .INIT(1'b0)) 
    \exe_PC_reg[6]_lopt_replica 
       (.C(CLK),
        .CE(1'b1),
        .D(O3[4]),
        .Q(\exe_PC_reg[6]_lopt_replica_1 ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \exe_PC_reg[7] 
       (.C(CLK),
        .CE(1'b1),
        .D(O3[5]),
        .Q(Q[5]),
        .R(p_0_in));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDRE #(
    .INIT(1'b0)) 
    \exe_PC_reg[7]_lopt_replica 
       (.C(CLK),
        .CE(1'b1),
        .D(O3[5]),
        .Q(\exe_PC_reg[7]_lopt_replica_1 ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \exe_PC_reg[8] 
       (.C(CLK),
        .CE(1'b1),
        .D(O3[6]),
        .Q(Q[6]),
        .R(p_0_in));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDRE #(
    .INIT(1'b0)) 
    \exe_PC_reg[8]_lopt_replica 
       (.C(CLK),
        .CE(1'b1),
        .D(O3[6]),
        .Q(\exe_PC_reg[8]_lopt_replica_1 ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \exe_PC_reg[9] 
       (.C(CLK),
        .CE(1'b1),
        .D(O3[7]),
        .Q(Q[7]),
        .R(p_0_in));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDRE #(
    .INIT(1'b0)) 
    \exe_PC_reg[9]_lopt_replica 
       (.C(CLK),
        .CE(1'b1),
        .D(O3[7]),
        .Q(\exe_PC_reg[9]_lopt_replica_1 ),
        .R(p_0_in));
endmodule

module pipereg_if_id
   (Q,
    p_0_in,
    O1,
    CLK,
    lopt,
    lopt_1,
    lopt_2,
    lopt_3,
    lopt_4,
    lopt_5,
    lopt_6,
    lopt_7,
    lopt_8,
    lopt_9);
  output [9:0]Q;
  input p_0_in;
  input [9:0]O1;
  input CLK;
  output lopt;
  output lopt_1;
  output lopt_2;
  output lopt_3;
  output lopt_4;
  output lopt_5;
  output lopt_6;
  output lopt_7;
  output lopt_8;
  output lopt_9;

  wire CLK;
  wire [9:0]O1;
  wire [9:0]Q;
  wire \id_PC_reg[10]_lopt_replica_1 ;
  wire \id_PC_reg[11]_lopt_replica_1 ;
  wire \id_PC_reg[2]_lopt_replica_1 ;
  wire \id_PC_reg[3]_lopt_replica_1 ;
  wire \id_PC_reg[4]_lopt_replica_1 ;
  wire \id_PC_reg[5]_lopt_replica_1 ;
  wire \id_PC_reg[6]_lopt_replica_1 ;
  wire \id_PC_reg[7]_lopt_replica_1 ;
  wire \id_PC_reg[8]_lopt_replica_1 ;
  wire \id_PC_reg[9]_lopt_replica_1 ;
  wire p_0_in;

  assign lopt = \id_PC_reg[10]_lopt_replica_1 ;
  assign lopt_1 = \id_PC_reg[11]_lopt_replica_1 ;
  assign lopt_2 = \id_PC_reg[2]_lopt_replica_1 ;
  assign lopt_3 = \id_PC_reg[3]_lopt_replica_1 ;
  assign lopt_4 = \id_PC_reg[4]_lopt_replica_1 ;
  assign lopt_5 = \id_PC_reg[5]_lopt_replica_1 ;
  assign lopt_6 = \id_PC_reg[6]_lopt_replica_1 ;
  assign lopt_7 = \id_PC_reg[7]_lopt_replica_1 ;
  assign lopt_8 = \id_PC_reg[8]_lopt_replica_1 ;
  assign lopt_9 = \id_PC_reg[9]_lopt_replica_1 ;
  FDRE #(
    .INIT(1'b0)) 
    \id_PC_reg[10] 
       (.C(CLK),
        .CE(1'b1),
        .D(O1[8]),
        .Q(Q[8]),
        .R(p_0_in));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDRE #(
    .INIT(1'b0)) 
    \id_PC_reg[10]_lopt_replica 
       (.C(CLK),
        .CE(1'b1),
        .D(O1[8]),
        .Q(\id_PC_reg[10]_lopt_replica_1 ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \id_PC_reg[11] 
       (.C(CLK),
        .CE(1'b1),
        .D(O1[9]),
        .Q(Q[9]),
        .R(p_0_in));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDRE #(
    .INIT(1'b0)) 
    \id_PC_reg[11]_lopt_replica 
       (.C(CLK),
        .CE(1'b1),
        .D(O1[9]),
        .Q(\id_PC_reg[11]_lopt_replica_1 ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \id_PC_reg[2] 
       (.C(CLK),
        .CE(1'b1),
        .D(O1[0]),
        .Q(Q[0]),
        .R(p_0_in));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDRE #(
    .INIT(1'b0)) 
    \id_PC_reg[2]_lopt_replica 
       (.C(CLK),
        .CE(1'b1),
        .D(O1[0]),
        .Q(\id_PC_reg[2]_lopt_replica_1 ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \id_PC_reg[3] 
       (.C(CLK),
        .CE(1'b1),
        .D(O1[1]),
        .Q(Q[1]),
        .R(p_0_in));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDRE #(
    .INIT(1'b0)) 
    \id_PC_reg[3]_lopt_replica 
       (.C(CLK),
        .CE(1'b1),
        .D(O1[1]),
        .Q(\id_PC_reg[3]_lopt_replica_1 ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \id_PC_reg[4] 
       (.C(CLK),
        .CE(1'b1),
        .D(O1[2]),
        .Q(Q[2]),
        .R(p_0_in));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDRE #(
    .INIT(1'b0)) 
    \id_PC_reg[4]_lopt_replica 
       (.C(CLK),
        .CE(1'b1),
        .D(O1[2]),
        .Q(\id_PC_reg[4]_lopt_replica_1 ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \id_PC_reg[5] 
       (.C(CLK),
        .CE(1'b1),
        .D(O1[3]),
        .Q(Q[3]),
        .R(p_0_in));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDRE #(
    .INIT(1'b0)) 
    \id_PC_reg[5]_lopt_replica 
       (.C(CLK),
        .CE(1'b1),
        .D(O1[3]),
        .Q(\id_PC_reg[5]_lopt_replica_1 ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \id_PC_reg[6] 
       (.C(CLK),
        .CE(1'b1),
        .D(O1[4]),
        .Q(Q[4]),
        .R(p_0_in));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDRE #(
    .INIT(1'b0)) 
    \id_PC_reg[6]_lopt_replica 
       (.C(CLK),
        .CE(1'b1),
        .D(O1[4]),
        .Q(\id_PC_reg[6]_lopt_replica_1 ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \id_PC_reg[7] 
       (.C(CLK),
        .CE(1'b1),
        .D(O1[5]),
        .Q(Q[5]),
        .R(p_0_in));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDRE #(
    .INIT(1'b0)) 
    \id_PC_reg[7]_lopt_replica 
       (.C(CLK),
        .CE(1'b1),
        .D(O1[5]),
        .Q(\id_PC_reg[7]_lopt_replica_1 ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \id_PC_reg[8] 
       (.C(CLK),
        .CE(1'b1),
        .D(O1[6]),
        .Q(Q[6]),
        .R(p_0_in));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDRE #(
    .INIT(1'b0)) 
    \id_PC_reg[8]_lopt_replica 
       (.C(CLK),
        .CE(1'b1),
        .D(O1[6]),
        .Q(\id_PC_reg[8]_lopt_replica_1 ),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \id_PC_reg[9] 
       (.C(CLK),
        .CE(1'b1),
        .D(O1[7]),
        .Q(Q[7]),
        .R(p_0_in));
  (* OPT_INSERTED_REPDRIVER *) 
  (* OPT_MODIFIED = "SWEEP" *) 
  FDRE #(
    .INIT(1'b0)) 
    \id_PC_reg[9]_lopt_replica 
       (.C(CLK),
        .CE(1'b1),
        .D(O1[7]),
        .Q(\id_PC_reg[9]_lopt_replica_1 ),
        .R(p_0_in));
endmodule

module pipereg_mem_wb
   (Q,
    p_0_in,
    O5,
    CLK);
  output [9:0]Q;
  input p_0_in;
  input [9:0]O5;
  input CLK;

  wire CLK;
  wire [9:0]O5;
  wire [9:0]Q;
  wire p_0_in;

  FDRE #(
    .INIT(1'b0)) 
    \wb_PC_reg[10] 
       (.C(CLK),
        .CE(1'b1),
        .D(O5[8]),
        .Q(Q[8]),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \wb_PC_reg[11] 
       (.C(CLK),
        .CE(1'b1),
        .D(O5[9]),
        .Q(Q[9]),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \wb_PC_reg[2] 
       (.C(CLK),
        .CE(1'b1),
        .D(O5[0]),
        .Q(Q[0]),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \wb_PC_reg[3] 
       (.C(CLK),
        .CE(1'b1),
        .D(O5[1]),
        .Q(Q[1]),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \wb_PC_reg[4] 
       (.C(CLK),
        .CE(1'b1),
        .D(O5[2]),
        .Q(Q[2]),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \wb_PC_reg[5] 
       (.C(CLK),
        .CE(1'b1),
        .D(O5[3]),
        .Q(Q[3]),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \wb_PC_reg[6] 
       (.C(CLK),
        .CE(1'b1),
        .D(O5[4]),
        .Q(Q[4]),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \wb_PC_reg[7] 
       (.C(CLK),
        .CE(1'b1),
        .D(O5[5]),
        .Q(Q[5]),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \wb_PC_reg[8] 
       (.C(CLK),
        .CE(1'b1),
        .D(O5[6]),
        .Q(Q[6]),
        .R(p_0_in));
  FDRE #(
    .INIT(1'b0)) 
    \wb_PC_reg[9] 
       (.C(CLK),
        .CE(1'b1),
        .D(O5[7]),
        .Q(Q[7]),
        .R(p_0_in));
endmodule

(* ECO_CHECKSUM = "d72c9920" *) 
(* NotValidForBitStream *)
module top
   (CLK100MHZ,
    nrst,
    OUT_if_PC,
    OUT_id_PC,
    OUT_exe_PC,
    OUT_mem_PC,
    OUT_wb_PC);
  input CLK100MHZ;
  input nrst;
  output [11:0]OUT_if_PC;
  output [11:0]OUT_id_PC;
  output [11:0]OUT_exe_PC;
  output [11:0]OUT_mem_PC;
  output [11:0]OUT_wb_PC;

  wire CLK100MHZ;
  wire CLK100MHZ_IBUF;
  wire CLK100MHZ_IBUF_BUFG;
  wire [11:0]OUT_exe_PC;
  wire [11:2]OUT_exe_PC_OBUF;
  wire [11:0]OUT_id_PC;
  wire [11:2]OUT_id_PC_OBUF;
  wire [11:0]OUT_if_PC;
  wire [11:2]OUT_if_PC_OBUF;
  wire [11:0]OUT_mem_PC;
  wire [11:2]OUT_mem_PC_OBUF;
  wire [11:0]OUT_wb_PC;
  wire [11:2]OUT_wb_PC_OBUF;
  wire lopt;
  wire lopt_1;
  wire lopt_10;
  wire lopt_11;
  wire lopt_12;
  wire lopt_13;
  wire lopt_14;
  wire lopt_15;
  wire lopt_16;
  wire lopt_17;
  wire lopt_18;
  wire lopt_19;
  wire lopt_2;
  wire lopt_20;
  wire lopt_21;
  wire lopt_22;
  wire lopt_23;
  wire lopt_24;
  wire lopt_25;
  wire lopt_26;
  wire lopt_27;
  wire lopt_28;
  wire lopt_29;
  wire lopt_3;
  wire lopt_4;
  wire lopt_5;
  wire lopt_6;
  wire lopt_7;
  wire lopt_8;
  wire lopt_9;
  wire nrst;
  wire nrst_IBUF;
  wire p_0_in;

initial begin
 $sdf_annotate("tb_top_time_impl.sdf",,,,"tool_control");
end
  BUFG CLK100MHZ_IBUF_BUFG_inst
       (.I(CLK100MHZ_IBUF),
        .O(CLK100MHZ_IBUF_BUFG));
  IBUF CLK100MHZ_IBUF_inst
       (.I(CLK100MHZ),
        .O(CLK100MHZ_IBUF));
  pipereg_exe_mem EXE_MEM
       (.CLK(CLK100MHZ_IBUF_BUFG),
        .O2(OUT_exe_PC_OBUF),
        .Q(OUT_mem_PC_OBUF),
        .lopt(lopt_20),
        .lopt_1(lopt_21),
        .lopt_2(lopt_22),
        .lopt_3(lopt_23),
        .lopt_4(lopt_24),
        .lopt_5(lopt_25),
        .lopt_6(lopt_26),
        .lopt_7(lopt_27),
        .lopt_8(lopt_28),
        .lopt_9(lopt_29),
        .p_0_in(p_0_in));
  pipereg_id_exe ID_EXE
       (.CLK(CLK100MHZ_IBUF_BUFG),
        .O3(OUT_id_PC_OBUF),
        .Q(OUT_exe_PC_OBUF),
        .lopt(lopt),
        .lopt_1(lopt_1),
        .lopt_2(lopt_2),
        .lopt_3(lopt_3),
        .lopt_4(lopt_4),
        .lopt_5(lopt_5),
        .lopt_6(lopt_6),
        .lopt_7(lopt_7),
        .lopt_8(lopt_8),
        .lopt_9(lopt_9),
        .p_0_in(p_0_in));
  pipereg_if_id IF_ID
       (.CLK(CLK100MHZ_IBUF_BUFG),
        .O1(OUT_if_PC_OBUF),
        .Q(OUT_id_PC_OBUF),
        .lopt(lopt_10),
        .lopt_1(lopt_11),
        .lopt_2(lopt_12),
        .lopt_3(lopt_13),
        .lopt_4(lopt_14),
        .lopt_5(lopt_15),
        .lopt_6(lopt_16),
        .lopt_7(lopt_17),
        .lopt_8(lopt_18),
        .lopt_9(lopt_19),
        .p_0_in(p_0_in));
  pipereg_mem_wb MEM_WB
       (.CLK(CLK100MHZ_IBUF_BUFG),
        .O5(OUT_mem_PC_OBUF),
        .Q(OUT_wb_PC_OBUF),
        .p_0_in(p_0_in));
  OBUF \OUT_exe_PC_OBUF[0]_inst 
       (.I(1'b0),
        .O(OUT_exe_PC[0]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \OUT_exe_PC_OBUF[10]_inst 
       (.I(lopt),
        .O(OUT_exe_PC[10]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \OUT_exe_PC_OBUF[11]_inst 
       (.I(lopt_1),
        .O(OUT_exe_PC[11]));
  OBUF \OUT_exe_PC_OBUF[1]_inst 
       (.I(1'b0),
        .O(OUT_exe_PC[1]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \OUT_exe_PC_OBUF[2]_inst 
       (.I(lopt_2),
        .O(OUT_exe_PC[2]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \OUT_exe_PC_OBUF[3]_inst 
       (.I(lopt_3),
        .O(OUT_exe_PC[3]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \OUT_exe_PC_OBUF[4]_inst 
       (.I(lopt_4),
        .O(OUT_exe_PC[4]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \OUT_exe_PC_OBUF[5]_inst 
       (.I(lopt_5),
        .O(OUT_exe_PC[5]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \OUT_exe_PC_OBUF[6]_inst 
       (.I(lopt_6),
        .O(OUT_exe_PC[6]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \OUT_exe_PC_OBUF[7]_inst 
       (.I(lopt_7),
        .O(OUT_exe_PC[7]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \OUT_exe_PC_OBUF[8]_inst 
       (.I(lopt_8),
        .O(OUT_exe_PC[8]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \OUT_exe_PC_OBUF[9]_inst 
       (.I(lopt_9),
        .O(OUT_exe_PC[9]));
  OBUF \OUT_id_PC_OBUF[0]_inst 
       (.I(1'b0),
        .O(OUT_id_PC[0]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \OUT_id_PC_OBUF[10]_inst 
       (.I(lopt_10),
        .O(OUT_id_PC[10]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \OUT_id_PC_OBUF[11]_inst 
       (.I(lopt_11),
        .O(OUT_id_PC[11]));
  OBUF \OUT_id_PC_OBUF[1]_inst 
       (.I(1'b0),
        .O(OUT_id_PC[1]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \OUT_id_PC_OBUF[2]_inst 
       (.I(lopt_12),
        .O(OUT_id_PC[2]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \OUT_id_PC_OBUF[3]_inst 
       (.I(lopt_13),
        .O(OUT_id_PC[3]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \OUT_id_PC_OBUF[4]_inst 
       (.I(lopt_14),
        .O(OUT_id_PC[4]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \OUT_id_PC_OBUF[5]_inst 
       (.I(lopt_15),
        .O(OUT_id_PC[5]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \OUT_id_PC_OBUF[6]_inst 
       (.I(lopt_16),
        .O(OUT_id_PC[6]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \OUT_id_PC_OBUF[7]_inst 
       (.I(lopt_17),
        .O(OUT_id_PC[7]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \OUT_id_PC_OBUF[8]_inst 
       (.I(lopt_18),
        .O(OUT_id_PC[8]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \OUT_id_PC_OBUF[9]_inst 
       (.I(lopt_19),
        .O(OUT_id_PC[9]));
  OBUF \OUT_if_PC_OBUF[0]_inst 
       (.I(1'b0),
        .O(OUT_if_PC[0]));
  OBUF \OUT_if_PC_OBUF[10]_inst 
       (.I(OUT_if_PC_OBUF[10]),
        .O(OUT_if_PC[10]));
  OBUF \OUT_if_PC_OBUF[11]_inst 
       (.I(OUT_if_PC_OBUF[11]),
        .O(OUT_if_PC[11]));
  OBUF \OUT_if_PC_OBUF[1]_inst 
       (.I(1'b0),
        .O(OUT_if_PC[1]));
  OBUF \OUT_if_PC_OBUF[2]_inst 
       (.I(OUT_if_PC_OBUF[2]),
        .O(OUT_if_PC[2]));
  OBUF \OUT_if_PC_OBUF[3]_inst 
       (.I(OUT_if_PC_OBUF[3]),
        .O(OUT_if_PC[3]));
  OBUF \OUT_if_PC_OBUF[4]_inst 
       (.I(OUT_if_PC_OBUF[4]),
        .O(OUT_if_PC[4]));
  OBUF \OUT_if_PC_OBUF[5]_inst 
       (.I(OUT_if_PC_OBUF[5]),
        .O(OUT_if_PC[5]));
  OBUF \OUT_if_PC_OBUF[6]_inst 
       (.I(OUT_if_PC_OBUF[6]),
        .O(OUT_if_PC[6]));
  OBUF \OUT_if_PC_OBUF[7]_inst 
       (.I(OUT_if_PC_OBUF[7]),
        .O(OUT_if_PC[7]));
  OBUF \OUT_if_PC_OBUF[8]_inst 
       (.I(OUT_if_PC_OBUF[8]),
        .O(OUT_if_PC[8]));
  OBUF \OUT_if_PC_OBUF[9]_inst 
       (.I(OUT_if_PC_OBUF[9]),
        .O(OUT_if_PC[9]));
  OBUF \OUT_mem_PC_OBUF[0]_inst 
       (.I(1'b0),
        .O(OUT_mem_PC[0]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \OUT_mem_PC_OBUF[10]_inst 
       (.I(lopt_20),
        .O(OUT_mem_PC[10]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \OUT_mem_PC_OBUF[11]_inst 
       (.I(lopt_21),
        .O(OUT_mem_PC[11]));
  OBUF \OUT_mem_PC_OBUF[1]_inst 
       (.I(1'b0),
        .O(OUT_mem_PC[1]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \OUT_mem_PC_OBUF[2]_inst 
       (.I(lopt_22),
        .O(OUT_mem_PC[2]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \OUT_mem_PC_OBUF[3]_inst 
       (.I(lopt_23),
        .O(OUT_mem_PC[3]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \OUT_mem_PC_OBUF[4]_inst 
       (.I(lopt_24),
        .O(OUT_mem_PC[4]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \OUT_mem_PC_OBUF[5]_inst 
       (.I(lopt_25),
        .O(OUT_mem_PC[5]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \OUT_mem_PC_OBUF[6]_inst 
       (.I(lopt_26),
        .O(OUT_mem_PC[6]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \OUT_mem_PC_OBUF[7]_inst 
       (.I(lopt_27),
        .O(OUT_mem_PC[7]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \OUT_mem_PC_OBUF[8]_inst 
       (.I(lopt_28),
        .O(OUT_mem_PC[8]));
  (* OPT_MODIFIED = "SWEEP" *) 
  OBUF \OUT_mem_PC_OBUF[9]_inst 
       (.I(lopt_29),
        .O(OUT_mem_PC[9]));
  OBUF \OUT_wb_PC_OBUF[0]_inst 
       (.I(1'b0),
        .O(OUT_wb_PC[0]));
  OBUF \OUT_wb_PC_OBUF[10]_inst 
       (.I(OUT_wb_PC_OBUF[10]),
        .O(OUT_wb_PC[10]));
  OBUF \OUT_wb_PC_OBUF[11]_inst 
       (.I(OUT_wb_PC_OBUF[11]),
        .O(OUT_wb_PC[11]));
  OBUF \OUT_wb_PC_OBUF[1]_inst 
       (.I(1'b0),
        .O(OUT_wb_PC[1]));
  OBUF \OUT_wb_PC_OBUF[2]_inst 
       (.I(OUT_wb_PC_OBUF[2]),
        .O(OUT_wb_PC[2]));
  OBUF \OUT_wb_PC_OBUF[3]_inst 
       (.I(OUT_wb_PC_OBUF[3]),
        .O(OUT_wb_PC[3]));
  OBUF \OUT_wb_PC_OBUF[4]_inst 
       (.I(OUT_wb_PC_OBUF[4]),
        .O(OUT_wb_PC[4]));
  OBUF \OUT_wb_PC_OBUF[5]_inst 
       (.I(OUT_wb_PC_OBUF[5]),
        .O(OUT_wb_PC[5]));
  OBUF \OUT_wb_PC_OBUF[6]_inst 
       (.I(OUT_wb_PC_OBUF[6]),
        .O(OUT_wb_PC[6]));
  OBUF \OUT_wb_PC_OBUF[7]_inst 
       (.I(OUT_wb_PC_OBUF[7]),
        .O(OUT_wb_PC[7]));
  OBUF \OUT_wb_PC_OBUF[8]_inst 
       (.I(OUT_wb_PC_OBUF[8]),
        .O(OUT_wb_PC[8]));
  OBUF \OUT_wb_PC_OBUF[9]_inst 
       (.I(OUT_wb_PC_OBUF[9]),
        .O(OUT_wb_PC[9]));
  pc PC
       (.CLK(CLK100MHZ_IBUF_BUFG),
        .O7(OUT_if_PC_OBUF),
        .nrst_IBUF(nrst_IBUF),
        .p_0_in(p_0_in));
  IBUF nrst_IBUF_inst
       (.I(nrst),
        .O(nrst_IBUF));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
