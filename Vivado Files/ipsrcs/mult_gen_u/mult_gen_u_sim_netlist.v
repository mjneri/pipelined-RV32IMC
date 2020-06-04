// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Sat Mar  7 12:43:20 2020
// Host        : Kouzui running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top mult_gen_u -prefix
//               mult_gen_u_ mult_gen_u_sim_netlist.v
// Design      : mult_gen_u
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35ticsg324-1L
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "mult_gen_u,mult_gen_v12_0_16,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "mult_gen_v12_0_16,Vivado 2019.2" *) 
(* NotValidForBitStream *)
module mult_gen_u
   (CLK,
    A,
    B,
    CE,
    P);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk_intf CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME clk_intf, ASSOCIATED_BUSIF p_intf:b_intf:a_intf, ASSOCIATED_RESET sclr, ASSOCIATED_CLKEN ce, FREQ_HZ 10000000, PHASE 0.000, INSERT_VIP 0" *) input CLK;
  (* x_interface_info = "xilinx.com:signal:data:1.0 a_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME a_intf, LAYERED_METADATA undef" *) input [31:0]A;
  (* x_interface_info = "xilinx.com:signal:data:1.0 b_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME b_intf, LAYERED_METADATA undef" *) input [31:0]B;
  (* x_interface_info = "xilinx.com:signal:clockenable:1.0 ce_intf CE" *) (* x_interface_parameter = "XIL_INTERFACENAME ce_intf, POLARITY ACTIVE_HIGH" *) input CE;
  (* x_interface_info = "xilinx.com:signal:data:1.0 p_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME p_intf, LAYERED_METADATA undef" *) output [63:0]P;

  wire [31:0]A;
  wire [31:0]B;
  wire CE;
  wire CLK;
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
  (* C_HAS_CE = "1" *) 
  (* C_HAS_SCLR = "0" *) 
  (* C_HAS_ZERO_DETECT = "0" *) 
  (* C_LATENCY = "1" *) 
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
        .CE(CE),
        .CLK(CLK),
        .P(P),
        .PCASC(NLW_U0_PCASC_UNCONNECTED[47:0]),
        .SCLR(1'b0),
        .ZERO_DETECT(NLW_U0_ZERO_DETECT_UNCONNECTED[1:0]));
endmodule

(* C_A_TYPE = "1" *) (* C_A_WIDTH = "32" *) (* C_B_TYPE = "1" *) 
(* C_B_VALUE = "10000001" *) (* C_B_WIDTH = "32" *) (* C_CCM_IMP = "0" *) 
(* C_CE_OVERRIDES_SCLR = "0" *) (* C_HAS_CE = "1" *) (* C_HAS_SCLR = "0" *) 
(* C_HAS_ZERO_DETECT = "0" *) (* C_LATENCY = "1" *) (* C_MODEL_TYPE = "0" *) 
(* C_MULT_TYPE = "1" *) (* C_OPTIMIZE_GOAL = "1" *) (* C_OUT_HIGH = "63" *) 
(* C_OUT_LOW = "0" *) (* C_ROUND_OUTPUT = "0" *) (* C_ROUND_PT = "0" *) 
(* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "artix7" *) (* downgradeipidentifiedwarnings = "yes" *) 
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
  wire CE;
  wire CLK;
  wire [63:0]P;
  wire [47:0]PCASC;
  wire [1:0]NLW_i_mult_ZERO_DETECT_UNCONNECTED;

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
  (* C_HAS_CE = "1" *) 
  (* C_HAS_SCLR = "0" *) 
  (* C_HAS_ZERO_DETECT = "0" *) 
  (* C_LATENCY = "1" *) 
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
        .CE(CE),
        .CLK(CLK),
        .P(P),
        .PCASC(PCASC),
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
c0dCMjMifmh8QUNrw+baI2xscSsIRuOS+uhsF1ZHQ4xV2RghB7vAAI9R5IaVRSU1e7U5kgvO8jYo
sgQgk5rRz8M4OxaKTOV+wipHwVxCNP1IWECzYU3CEhPCSlAhPX30uXUvu4x7Y13xf72V4I5hnzwc
FyfYqort42ezIXcfRIsVWnc2Qp/eKcwPtgH73o8N8EQuZidkxWz46RpIxndSe0bFg1XWVqDR5ASf
FpaY94xDshszyLBMV0qon2N2rJaU/qJQ1LoRXiAzt3ernlooSOG2aY2Efq/sv9XpJWiIlohef6ZZ
gyUb+BRG5zddGezTMEZeWkStYG/8pRcTV9fKqQ==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Z7D+2As4y/KSTJX9BQwTI9l06vLh35iGrnLElrpd0duAf9orNBgh3cEDIe1zw7KV+r+ckxm8y+gV
S7Xf8vS7UjGP02qvelw1TrkpOPTSyktAgZMioAerO6fF5TZJ6TUSQWY4vHGtnmvLWaSzuP2Lych1
YyeZ0q23zM0Dd5RBIRKBoBdTiGX50DDpAUs7VGmx32ChBiI/KI35kTuDdXVO3IYOdgV64yFcR7So
cyLNyh6wQDo+w8Z4d3FVDTOnVOhtDsHB4rRQMEJNpC+FNuKpr+DTjeWDsRouLjsX9Pour1szqX1m
lTnPHd0ovOrtYsy6BabbTvezlwaw0K7IlVIqvg==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 26896)
`pragma protect data_block
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
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
