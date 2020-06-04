// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Sat Mar  7 12:23:26 2020
// Host        : Kouzui running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top mult_gen_signed -prefix
//               mult_gen_signed_ mult_gen_signed_sim_netlist.v
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
(* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "artix7" *) (* downgradeipidentifiedwarnings = "yes" *) 
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
ZtnJKUoLv6zYczNl8oysyRPa5PSHELzPgaA3IqGv3SA48bRGnhCBSF7O+FKaOC2BE5kte2dqcS7O
5vH0f5DrEydwr06MDU2A3XbeIoXwoA3CkoysjN59LfuDwa3dZxYS4hVh6GzXtNBtL2AMDhQp8opq
bHfemAQyu4uk64U7OSDrNvO/yS1bVnvWS4zd2yRXhQqTeFYb8l3PXVqEMyP85236Or8TnUwPnyKK
gNJaevYE2sd5tq3+M/VOs0WHEOfGlsDlADfqCXnBDpr1fQXZrh43Pa605RyGHetI0LioGWR9MIZ9
FiaYZ5E+2A9OuEEXp3HsTBXXiBlJ12mBMY491A==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
bAUOZ6JUlkIkq6ATcc3Npy6u3zyJNJie30b95Ope2REyRaU3u7bufThWIdLFkNsZ4aU+vCMfXwON
FeJZHwcTv+PpAWavaV7sk4cKkrrX3NEs7Ov/vLwpobVvfyZ1x6tpRm1T+nevuiNCXH7dQ8XVzbwX
wKXbgYIxthv3biXcnUsa02rOmJxDNjSyZOvTrCS+fUEarjhKc6bAQTNuKdQkDbHI3wQxnpYY2hr1
GmhIVH7ZeP/QXpEr5grbTDboY9WE/HkPtJ1BOenCSVVhsfzErF4CCW6X7Vfydm9Pw2j1RkXjGjGu
LujikT0pVfs8WtdSLbLroxAxzpAOaq5+7AuLSA==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 26912)
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
