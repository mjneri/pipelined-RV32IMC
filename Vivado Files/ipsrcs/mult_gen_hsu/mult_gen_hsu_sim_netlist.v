// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Thu Feb 13 15:51:39 2020
// Host        : Kouzui running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/MJ/Documents/Vivado/pipelined-RV32IMC/pipelined-RV32IMC.srcs/sources_1/ip/mult_gen_hsu/mult_gen_hsu_sim_netlist.v
// Design      : mult_gen_hsu
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35ticsg324-1L
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "mult_gen_hsu,mult_gen_v12_0_16,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "mult_gen_v12_0_16,Vivado 2019.2" *) 
(* NotValidForBitStream *)
module mult_gen_hsu
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

  (* C_A_TYPE = "0" *) 
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
  mult_gen_hsu_mult_gen_v12_0_16 U0
       (.A(A),
        .B(B),
        .CE(1'b1),
        .CLK(1'b1),
        .P(P),
        .PCASC(NLW_U0_PCASC_UNCONNECTED[47:0]),
        .SCLR(1'b0),
        .ZERO_DETECT(NLW_U0_ZERO_DETECT_UNCONNECTED[1:0]));
endmodule

(* C_A_TYPE = "0" *) (* C_A_WIDTH = "32" *) (* C_B_TYPE = "1" *) 
(* C_B_VALUE = "10000001" *) (* C_B_WIDTH = "32" *) (* C_CCM_IMP = "0" *) 
(* C_CE_OVERRIDES_SCLR = "0" *) (* C_HAS_CE = "0" *) (* C_HAS_SCLR = "0" *) 
(* C_HAS_ZERO_DETECT = "0" *) (* C_LATENCY = "0" *) (* C_MODEL_TYPE = "0" *) 
(* C_MULT_TYPE = "1" *) (* C_OPTIMIZE_GOAL = "1" *) (* C_OUT_HIGH = "63" *) 
(* C_OUT_LOW = "0" *) (* C_ROUND_OUTPUT = "0" *) (* C_ROUND_PT = "0" *) 
(* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "artix7" *) (* ORIG_REF_NAME = "mult_gen_v12_0_16" *) 
(* downgradeipidentifiedwarnings = "yes" *) 
module mult_gen_hsu_mult_gen_v12_0_16
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
  (* C_A_TYPE = "0" *) 
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
  mult_gen_hsu_mult_gen_v12_0_16_viv i_mult
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
T4LQVc9FEHRxKmfRvBH5h6w5lhliVbjGnur3Spdtgl2Zre6iAO806btNIDjlyB/HMIYiggd4c9ZB
w0oATb+OpFisZZ3frv5UnHD8LdclE+E8oH+bBIY7pHoAiEDgfCTsjiWhcvslhxrY/SIGBmD8z341
NkrRp5MfU/r/4tduhTK3Q1iBnb91wZBe0stAz0Z3+l4GL1qlCLg7qZkORWGB0NHtSQTNhSBukL9B
zckGRLcEomMjXWQ4tbuBA+hAyMs0qBhCYwz7uaat4BwH5qvDC8fy3Cbl9OKkP6EIqDPeh7GE8Kub
pt7a82JY6z18jr7ig3N1k0+tbqDy9v/Ae3mJuQ==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
YHLVT1H+miTPG5APx1ufnj14Xn4jUwRnNfVFaJ/fLELcBgW6BZiJTQcWG7tpNR9ddlvMOkAqmRyA
m0ThjzO4K1lxDn0Z1ymv9eMkw6ebbpaSv/Vpr8rU/rSc/SRQZyXk7TV5vdiYMLkasgc7eIsyV+zR
WYxejSo9myebuT5nUMYKTCGd+gYUxmvE8Wbg38rb03HV0wif3AKycjkzL5b0b/a6CUgG049ryyUQ
NtGULLCj7omqT5AD7FEs2gh4gAxiR7za6yGVhabFRawYvG9OszsAZ25D/Js6X/kxLMKL3RNGgHkE
worsnJYFXnT+8TiPxS3fej62ZHEz9T4Uw4JVjA==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 28688)
`pragma protect data_block
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
AwY4/mw2Ej65Sq/enVV+40A=
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
