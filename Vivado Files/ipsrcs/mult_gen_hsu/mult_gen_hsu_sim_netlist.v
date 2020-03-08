// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Sat Mar  7 12:16:36 2020
// Host        : Kouzui running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               C:/Users/MJ/Documents/Vivado/pipelined-RV32IMC/pipelined-RV32IMC.srcs/sources_1/ip/mult_gen_hsu/mult_gen_hsu_sim_netlist.v
// Design      : mult_gen_hsu
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35ticsg324-1L
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "mult_gen_hsu,mult_gen_v12_0_16,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "mult_gen_v12_0_16,Vivado 2019.2" *) 
(* NotValidForBitStream *)
module mult_gen_hsu
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

  (* C_A_TYPE = "0" *) 
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
  mult_gen_hsu_mult_gen_v12_0_16 U0
       (.A(A),
        .B(B),
        .CE(CE),
        .CLK(CLK),
        .P(P),
        .PCASC(NLW_U0_PCASC_UNCONNECTED[47:0]),
        .SCLR(1'b0),
        .ZERO_DETECT(NLW_U0_ZERO_DETECT_UNCONNECTED[1:0]));
endmodule

(* C_A_TYPE = "0" *) (* C_A_WIDTH = "32" *) (* C_B_TYPE = "1" *) 
(* C_B_VALUE = "10000001" *) (* C_B_WIDTH = "32" *) (* C_CCM_IMP = "0" *) 
(* C_CE_OVERRIDES_SCLR = "0" *) (* C_HAS_CE = "1" *) (* C_HAS_SCLR = "0" *) 
(* C_HAS_ZERO_DETECT = "0" *) (* C_LATENCY = "1" *) (* C_MODEL_TYPE = "0" *) 
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
  wire CE;
  wire CLK;
  wire [63:0]P;
  wire [47:0]PCASC;
  wire [1:0]NLW_i_mult_ZERO_DETECT_UNCONNECTED;

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
  mult_gen_hsu_mult_gen_v12_0_16_viv i_mult
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
SuYM1nPKESpSRctMHoc/a29LY5sTOZ2dvMwGJUWMq7HDKzGP2yOdrQRDJv5cEanbwRjElH4YmoCO
1BO2hjCV4qT8u3uw8wVJ+XI7Htt+SWdH2yBMClfmzJpmLNPwIhPd6JvSmni7IsEuOSnG/h73MqTv
6fnrKjhbKM7pDTyPZFAPEODUjwF/k6o3zpEiSheu+Erzwue5wDpd19nQpixUMeAw2zaxVErLQVLI
VImeEs7uNs1qh/tZf0EVFA2fnyoita9PLV07/EjjqNc5ZlDII5OSIUc0/qxLHAdP9Xos/U3sYulB
tvf8dFfup/n0z8AWWDSwcK96hiY82q90P6dYWw==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
a6OvYQfssM2fpdy9bgX3OeMlOPKPJaLCkp2dR7/0RqA/61riTz2NezrpO4Ogyh0W2c0gUHBhr1vk
LWF9mTg3dr9jfBMyb6ufEjDTONBi3gfEB2fWPHCN8HDZh+aY/CTBUod1uMAUJXdN1DEDHkZB3tf2
TaUyne/IiTT+fcgKRzDnFfa6BUsfsbcpn67viQkSlS7ebUWjo/qjw15AC99vELsmgGVOrb++l5k/
GlgO7Te7O+omwnLh3+/OAI5AfCCuEB5Bm7dZbg3GncA91bCuKaW4ZOSoi1zUg766UULYAvG7APdl
wvpr1CpOaWMMU1vRblCRHSI2mvKjzRnONgZpeQ==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 26768)
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
