// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Sun Jun  7 16:25:34 2020
// Host        : Kouzui running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim {C:/Users/MJ/Documents/UP Diliman/5th Year/2nd Sem/CoE
//               198/pipelined-RV32IMC/Vivado Files/ipsrcs/mult_gen_signed/mult_gen_signed_sim_netlist.v}
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
jBGaP3d/q+b2Hm0HCQu5870Gmza7VejAQVrMBkr1maGvKYAoiLpsgNDsBOJVAFt8aVaWR7zS/VtW
Sgg4VieBfHV8iO5FF9GM9A3QsIgncg9s4UnL/vSO7x4CxzJYlLpcQ8rVJ74uLeeKcjRxf1cD8vAo
Rb8vBFRIC0VFjfsWZCVJV5JV8L3Y3x12kJ+bMm8K8SVOVhyYcHBQcmCbSAuLDwOw6ai7u/pQybRE
mNkcbFtwJnoVqJ3DQcIFyOKLlotqL58WOt5AnVw29ZuaCOpM67PoBYwl/JbIMQOb1OjF/7P9cesT
/Exv4cM5P+OJyUt/TgG0riDxpF8ZOQvoICsHmA==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
LeElhf8PEaIE6Pv/0DGXi0MG6AKUPm+zFo/8MJ6zAyJhY8WzTi88+pLRbkj7DyBk/BObyT72S9J3
xd4kiSWUS1spn3Or3fG8PZu055qxH5/scXK9Qx7jX4gQYTMawgKd/rLg1K+H3UtTB6jK6tacFzrF
mOTTf1brp7YDdH0ppQLgvHKuj1KrC1q8LRGjeGzqXxcHtvJ5dlB9+i8hIRQ4cTKjVnaOi4NdQqn9
Z2rY6xHM32CjGz4Ik7nRy6TVg22nd9RRq9ASCS9uOm0v2LsjQqWzKv3y1GC3NWMcTy+leRw4U2LX
b2XGpLeKEpRS6w1p3cRq67ABBbjeRYU3kFF08A==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 26800)
`pragma protect data_block
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
OWrlErHMT235OQ==
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
