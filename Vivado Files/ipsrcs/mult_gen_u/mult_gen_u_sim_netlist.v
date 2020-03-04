// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Thu Feb 13 15:56:46 2020
// Host        : Kouzui running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/MJ/Documents/Vivado/pipelined-RV32IMC/pipelined-RV32IMC.srcs/sources_1/ip/mult_gen_u/mult_gen_u_sim_netlist.v
// Design      : mult_gen_u
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35ticsg324-1L
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "mult_gen_u,mult_gen_v12_0_16,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "mult_gen_v12_0_16,Vivado 2019.2" *) 
(* NotValidForBitStream *)
module mult_gen_u
   (A,
    B,
    P);
  (* x_interface_info = "xilinx.com:signal:data:1.0 a_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME a_intf, LAYERED_METADATA undef" *) input [31:0]A;
  (* x_interface_info = "xilinx.com:signal:data:1.0 b_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME b_intf, LAYERED_METADATA undef" *) input [31:0]B;
  (* x_interface_info = "xilinx.com:signal:data:1.0 p_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME p_intf, LAYERED_METADATA undef" *) output [63:0]P;

  wire [31:0]A;
  wire [31:0]B;
  wire [63:0]P;
  wire [47:0]NLW_U0_PCASC_UNCONNECTED;
  wire [1:0]NLW_U0_ZERO_DETECT_UNCONNECTED;

  (* C_A_TYPE = "1" *) 
  (* C_A_WIDTH = "32" *) 
  (* C_B_TYPE = "1" *) 
  (* C_B_VALUE = "10000001" *) 
  (* C_B_WIDTH = "32" *) 
  (* C_CCM_IMP = "0" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_CE = "0" *) 
  (* C_HAS_SCLR = "0" *) 
  (* C_HAS_ZERO_DETECT = "0" *) 
  (* C_LATENCY = "0" *) 
  (* C_MODEL_TYPE = "0" *) 
  (* C_MULT_TYPE = "1" *) 
  (* C_OPTIMIZE_GOAL = "1" *) 
  (* C_OUT_HIGH = "63" *) 
  (* C_OUT_LOW = "0" *) 
  (* C_ROUND_OUTPUT = "0" *) 
  (* C_ROUND_PT = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  mult_gen_u_mult_gen_v12_0_16 U0
       (.A(A),
        .B(B),
        .CE(1'b1),
        .CLK(1'b1),
        .P(P),
        .PCASC(NLW_U0_PCASC_UNCONNECTED[47:0]),
        .SCLR(1'b0),
        .ZERO_DETECT(NLW_U0_ZERO_DETECT_UNCONNECTED[1:0]));
endmodule

(* C_A_TYPE = "1" *) (* C_A_WIDTH = "32" *) (* C_B_TYPE = "1" *) 
(* C_B_VALUE = "10000001" *) (* C_B_WIDTH = "32" *) (* C_CCM_IMP = "0" *) 
(* C_CE_OVERRIDES_SCLR = "0" *) (* C_HAS_CE = "0" *) (* C_HAS_SCLR = "0" *) 
(* C_HAS_ZERO_DETECT = "0" *) (* C_LATENCY = "0" *) (* C_MODEL_TYPE = "0" *) 
(* C_MULT_TYPE = "1" *) (* C_OPTIMIZE_GOAL = "1" *) (* C_OUT_HIGH = "63" *) 
(* C_OUT_LOW = "0" *) (* C_ROUND_OUTPUT = "0" *) (* C_ROUND_PT = "0" *) 
(* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "artix7" *) (* ORIG_REF_NAME = "mult_gen_v12_0_16" *) 
(* downgradeipidentifiedwarnings = "yes" *) 
module mult_gen_u_mult_gen_v12_0_16
   (CLK,
    A,
    B,
    CE,
    SCLR,
    ZERO_DETECT,
    P,
    PCASC);
  input CLK;
  input [31:0]A;
  input [31:0]B;
  input CE;
  input SCLR;
  output [1:0]ZERO_DETECT;
  output [63:0]P;
  output [47:0]PCASC;

  wire \<const0> ;
  wire [31:0]A;
  wire [31:0]B;
  wire [63:0]P;
  wire [47:0]NLW_i_mult_PCASC_UNCONNECTED;
  wire [1:0]NLW_i_mult_ZERO_DETECT_UNCONNECTED;

  assign PCASC[47] = \<const0> ;
  assign PCASC[46] = \<const0> ;
  assign PCASC[45] = \<const0> ;
  assign PCASC[44] = \<const0> ;
  assign PCASC[43] = \<const0> ;
  assign PCASC[42] = \<const0> ;
  assign PCASC[41] = \<const0> ;
  assign PCASC[40] = \<const0> ;
  assign PCASC[39] = \<const0> ;
  assign PCASC[38] = \<const0> ;
  assign PCASC[37] = \<const0> ;
  assign PCASC[36] = \<const0> ;
  assign PCASC[35] = \<const0> ;
  assign PCASC[34] = \<const0> ;
  assign PCASC[33] = \<const0> ;
  assign PCASC[32] = \<const0> ;
  assign PCASC[31] = \<const0> ;
  assign PCASC[30] = \<const0> ;
  assign PCASC[29] = \<const0> ;
  assign PCASC[28] = \<const0> ;
  assign PCASC[27] = \<const0> ;
  assign PCASC[26] = \<const0> ;
  assign PCASC[25] = \<const0> ;
  assign PCASC[24] = \<const0> ;
  assign PCASC[23] = \<const0> ;
  assign PCASC[22] = \<const0> ;
  assign PCASC[21] = \<const0> ;
  assign PCASC[20] = \<const0> ;
  assign PCASC[19] = \<const0> ;
  assign PCASC[18] = \<const0> ;
  assign PCASC[17] = \<const0> ;
  assign PCASC[16] = \<const0> ;
  assign PCASC[15] = \<const0> ;
  assign PCASC[14] = \<const0> ;
  assign PCASC[13] = \<const0> ;
  assign PCASC[12] = \<const0> ;
  assign PCASC[11] = \<const0> ;
  assign PCASC[10] = \<const0> ;
  assign PCASC[9] = \<const0> ;
  assign PCASC[8] = \<const0> ;
  assign PCASC[7] = \<const0> ;
  assign PCASC[6] = \<const0> ;
  assign PCASC[5] = \<const0> ;
  assign PCASC[4] = \<const0> ;
  assign PCASC[3] = \<const0> ;
  assign PCASC[2] = \<const0> ;
  assign PCASC[1] = \<const0> ;
  assign PCASC[0] = \<const0> ;
  assign ZERO_DETECT[1] = \<const0> ;
  assign ZERO_DETECT[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  (* C_A_TYPE = "1" *) 
  (* C_A_WIDTH = "32" *) 
  (* C_B_TYPE = "1" *) 
  (* C_B_VALUE = "10000001" *) 
  (* C_B_WIDTH = "32" *) 
  (* C_CCM_IMP = "0" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_CE = "0" *) 
  (* C_HAS_SCLR = "0" *) 
  (* C_HAS_ZERO_DETECT = "0" *) 
  (* C_LATENCY = "0" *) 
  (* C_MODEL_TYPE = "0" *) 
  (* C_MULT_TYPE = "1" *) 
  (* C_OPTIMIZE_GOAL = "1" *) 
  (* C_OUT_HIGH = "63" *) 
  (* C_OUT_LOW = "0" *) 
  (* C_ROUND_OUTPUT = "0" *) 
  (* C_ROUND_PT = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  mult_gen_u_mult_gen_v12_0_16_viv i_mult
       (.A(A),
        .B(B),
        .CE(1'b0),
        .CLK(1'b1),
        .P(P),
        .PCASC(NLW_i_mult_PCASC_UNCONNECTED[47:0]),
        .SCLR(1'b0),
        .ZERO_DETECT(NLW_i_mult_ZERO_DETECT_UNCONNECTED[1:0]));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2019.1"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
HPMPLvpmoX7LOmPj78BMT9X1rCnPz6PdhVGZQ307N9haGfAdMGVirvGR3e0Glyn2ieoWqXA6qOQL
t0xn28+h0g==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
Nxv/BnutRgdmHnLyK7kvDGjm7WGfFKW2mxQ6xUKF14zS4ziz5pSV0ueW4VqAzUyEPsErIAEuyV6F
m5KCqRBB197Q2NbZa7O7tdAqboX6tPAJzbB6u4U/MmNS1AQcSgtfj5srMbdBzDa5pR4V3HrI0MRj
0xhV1BWf725FYPP4av0=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
F5KGJgEDQsX2btdjtRUlSmNtuyodIhGXEa3/AXv1Y7qgSO8gknBfiqj5HcIaVA9b4npQpDnNcmq+
1ONAqLeLhdOm9TES+GsTAkh/lClvl89bzfqgOV33iqwQHYIHwSsWMRXT9JSUx+YWu+g6xKpT1Ycn
8BCPsq4QUJIqL6W16fheEHB/lkMgnespIWEYJJG6R6zvv2zG8GiU6cG8zHrRjdvAj8kOkhmiMvSd
YjGXJSMfjw7ojCPSUF+nb6WWhUEmoMA/6lgSVaXRm00YHSZ09k7rKTJWSXFSpTmkL2WOsQhNS0ek
jdTK2KF5K6z2YOK4zkfHgZ+fB0KJyANaLLJH/Q==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
lFuQXeJ0hi7qnIKAR+37XCSOwp8bGLukonngcICceOVpL87+rxvhP5TyNJ/zXpAWDF0BaRYlGr7d
isPiUStrvUthNyOqCr4vFZyhCdY8n+Mrv3OCvLoLQSarxVXbaKbXb0tPsXJCUdXTrCt9mr5x0Nda
6DAI8FBPlFMAiqnFXnYMwlUiSlkNWUpInuNw7+1eD8kUdckEUV1PDwZ0yjpFqMokMH9oJjN6z0Yy
65D8Tqo288ZMfZQuIimjski+X6EK157XbpyuoZIuYLJ7j6oaATdintgfZpgGzVvhCZtMbx6/SJtR
efW5vLBGiGs7rPBPE2T8fosHGOvmeC9QBSj8Ww==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2019_02", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Q8VVvHzTNgU3tZr4+8ia7ylST+kbNPWskONHDOT1dTkB7cHZIAWyzXpQZPuEgk2wJq21PoqmVlG9
t08IYzkfC8vYQ2LRf2Co3SXc7p3gF2OFMC68J9Nf9D+/PXJCJy3QO4H8oO39l6bn8c56K2ARnK0R
mMIALbCWSBDGCWGQmXWZJ+xmDGs1KgTeiSW3bZRftWJ6K8l8BhMit8BLOY2Mi3jJ0WRhN8kKd6JT
D4NU1jTZT6jEtmI7Gnj/AXG6auTqDPHsVQzf+ZzBsLTfw83CFoO70xM997L5cZXlqz8fEDmxezkr
wWxPwJbJeVkRV3tUxlo2Bs2x1uVkXQeNVMI8jg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
oUeTLA0HA2uKORUHo1HidNC3lw54gxwlLUkv28qRPv1pz7AEVUbIJ7wsyu2Scju+EkC2Ivi8HbBn
jxkeqRDTAwAbAqIKnY3AdyfojN9Hb8SMLcLnpWLLCpb6E0vwA09r7uqKRZ8wYAgT9CPFvzpQ3zKt
9DTLgQ3rZtFxx2nfCug=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Fayrlym1l14Y48yZ195XboT9ZQmp/mAzUyHby3Y9qJTzDF+m6mRQ/ZbebObo8bu4VAm45JeETPx1
YI4UZNOK4IqKv0BZsAlzUfAYAmqmkmIJYbn2gWUCwXyKX5AoA4ONnlxEHxzZhqtsmEXvxwTEs25/
R7iLzeoMfmwwNHgPNQkteiR4zDlB76CYmgu6EOSUX5Nnitq1oh7qRuU8WqWN7lLfgIC6T7qNHwGD
RPze2yiP06fSG45jPrOn2fvBX9SRbUXjNtiFgmqim4anwJU46v7y3ubit/I6giZhz5PJMZfkDaFX
ag+uCMq4Q8ZEolqMBmjUjat86BdVd4Nmr0yUaA==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
kIpxh3qIIkWUg8aLJSPKvKhKTPFH7T8fisti5RtNaftS7xh3KDsGLYnF1lYhH2RVXgzbdaVqvtED
5QJazVo6wUFI91xgFeOR5jX+Ny5UBUX2MngsK+UZyZg5+EdtSiDtiJNtQqgjq1Rn+XQCGF3xP80n
7YvuVMbgRHCAfWrWw7ZJ7Y3raRzeIkx+koPFio7XnC+QdRJ0ItO1YtQgF4Sg1Ihr5TH8/RrNn903
kPa+anH9spo3SFCf2Ts11UXAGLdIBmOLMtEAKjjCUbtmjGSeSc0gn2q2I+xRTFcegLevlr/iuLTw
3lFndBAoW40xOiCDjWZ6Rz7J+jZhsRl3D0Bhwg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Zw337fx1ZdIhrFRC3IheB45Zhy1j0ImGO4Av40i+nFOTQ+ENQaqX/Gvii41MB2PPxNT8EAi4dfsR
Ucq7sXQ0jQXqweDHNd9npfNSzTn+hngs8j/gWxGZBJYhK0wcXrDGbkgQseAbiVdwirMpxTHOW96v
Ir3AQ8yI+r6DIUJxHxF8SO2CLNSM9zzrV6oW4G3XcQdDRHXc+va6arXObk0jENwEljbCVZitI0ZZ
XnQWx+ckzLA42ZJCWgRgTufKgK6C7B8YiUBNB2pV0ge9Dodq4cFj0sqK1H0mkYP51lem77k6E1zl
Gnje4E6WsYXxhLZAkRE3UNtSLysL/eGHGNoVkg==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Ax5PvYSC/zUHMgBP5L9SdPVdENfj0vEzsiDHMXp6+BM83Gpf9vjsFLwoDpcRT4iZ+wk976y9kTMU
7+mIs6hxwX9pdQY16GhCLD9kLpBmo+uyCmeE2zpJ9/NtIV+2j/7vEXnpgiJAjQ6AY4dMg1xIBnPN
joy/mfdDRWKA3UFl8MRGCmCDFwpg3zniDvpO0XrvUErqxMZnXsKH8Id/Qbsozf77awmgXFY/0UXx
/5IIEjPvDYy3EMsXJFrBQdfl0Gx/Dua/cBFVRqtlpJ1GF6fnuNvhgwNe9svd+qfqrFn/lFDZ8lsk
4l2vtY/0qlTmjv7EbBh7K45IoSgM3N201QazeA==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 28672)
`pragma protect data_block
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
yg==
`pragma protect end_protected
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
