// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Sat Mar  7 12:23:28 2020
// Host        : Kouzui running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               C:/Users/MJ/Documents/Vivado/pipelined-RV32IMC/pipelined-RV32IMC.srcs/sources_1/ip/mult_gen_signed/mult_gen_signed_sim_netlist.v
// Design      : mult_gen_signed
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35ticsg324-1L
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "mult_gen_signed,mult_gen_v12_0_16,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "mult_gen_v12_0_16,Vivado 2019.2" *) 
(* NotValidForBitStream *)
module mult_gen_signed
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
  (* C_B_TYPE = "0" *) 
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
  mult_gen_signed_mult_gen_v12_0_16 U0
       (.A(A),
        .B(B),
        .CE(CE),
        .CLK(CLK),
        .P(P),
        .PCASC(NLW_U0_PCASC_UNCONNECTED[47:0]),
        .SCLR(1'b0),
        .ZERO_DETECT(NLW_U0_ZERO_DETECT_UNCONNECTED[1:0]));
endmodule

(* C_A_TYPE = "0" *) (* C_A_WIDTH = "32" *) (* C_B_TYPE = "0" *) 
(* C_B_VALUE = "10000001" *) (* C_B_WIDTH = "32" *) (* C_CCM_IMP = "0" *) 
(* C_CE_OVERRIDES_SCLR = "0" *) (* C_HAS_CE = "1" *) (* C_HAS_SCLR = "0" *) 
(* C_HAS_ZERO_DETECT = "0" *) (* C_LATENCY = "1" *) (* C_MODEL_TYPE = "0" *) 
(* C_MULT_TYPE = "1" *) (* C_OPTIMIZE_GOAL = "1" *) (* C_OUT_HIGH = "63" *) 
(* C_OUT_LOW = "0" *) (* C_ROUND_OUTPUT = "0" *) (* C_ROUND_PT = "0" *) 
(* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "artix7" *) (* ORIG_REF_NAME = "mult_gen_v12_0_16" *) 
(* downgradeipidentifiedwarnings = "yes" *) 
module mult_gen_signed_mult_gen_v12_0_16
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
  (* C_B_TYPE = "0" *) 
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
  mult_gen_signed_mult_gen_v12_0_16_viv i_mult
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
MXJ+ZwPBbiNvsEjYHXvSKaTRXm3auxUWmF2GkOW1eYaTgPAHZlQZtXCXKsIDBgfiOgFlWfYO2DiR
PtCeAQkWAkwISD2JOUMJQxexkdCwDHcx3T0pe79skeyuRJMeZSB/NIb6b1lfcrR5EJGy6pY+K2R+
ah+quspyLQ2py67+PMDzZodz9XpzB6QfPN5SLsO8q4Bt3DvXH35kMFj7kgYzaYyuUDPSLz5ILGC/
FGl+1Bt/s28z39XJGVzNPEAvFBBFc4U/918mBeDAD+LF5H0HB0jamUNqHoSrl8KYdELK9Y6rOd62
brXCEx1VZf3dpYBfMFsYuzDlaZbZH01WKj4JaA==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
QiEFgphk8RQi/M5LOrzmoopfmQV14lGlM9zP92rygJC88lYnIyj9uUGJef8qGWIvj8SAOqZPn5Lm
+jV0khnYRAEZYC65DE94o87T3zEE3mN+j8XPidh/2koV6kyXtWotwT4NDfbe0p7LXqDTxXTPzCPH
TG1lamPcJjfnVpXFpTwZpKmedG+Yls312k640U4jr/if4Cf3N30RXDGK4QiM0oX7/K+ReL3RKYo4
z9SLbQmirYifLrXuCDwEhXXq6MwF8rI3kgYTk7a8J7IQdWhUvCeXM8jgRH2xfMgKiEk+bq0vJg4j
7QgeA0XwRivmoW35u1sobbiDMYjBb6YwRojPsg==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 26800)
`pragma protect data_block
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
6ZWMg6sOIkzsrw==
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
