// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Sat Mar  7 12:43:21 2020
// Host        : Kouzui running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               C:/Users/MJ/Documents/Vivado/pipelined-RV32IMC/pipelined-RV32IMC.srcs/sources_1/ip/mult_gen_u/mult_gen_u_sim_netlist.v
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
YXiZlFYQRKnR+LFKNnkW3Q5zOQ1xRWXhWhBw3+YvJWgkzXIr0QSHZCvPNMI4qOSYRhmxDPFaIioT
nSBwOWrBOttcOIPQwssb4cibOs/CW0rxomAM9HqWvONNMX1vVNMRw6tP2atkVBhAJ1/hMMN3zK3y
2XMIrLy9LyzW8+wxbjHOlJYxrFkXMNLQZ6Ne5JQ0y7S1hD9mFLRq5BJ/dFK3yh0lXPNGT/fzmykX
FGDXsTOIp5WwGroIqv2ir3oMPELmR7RYFp8bqf22ZD7sgc5+vj4+LsvLlczG8hUIDp+/JE1hNpbB
nNKdGNwibCe6xV0TUsiGLjI1xQGIc+61OQM3aQ==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
fL0pZHvgO9IEy4k2Xwi70ACaqdbA1cfmWHTUGfdUDdWt4cPtlOZSFsrO0rm84XoQLlZS9DBBhK3X
9guZBJsixH2KzWmTiePeQOEc1O0XRnglYuOWFvOEdVNCuBYOb2I0yde3ciAjYsIVEzaJAZY3SjkQ
Ph57936liE4L2jxVW2/2O+8bPiriJYcXRW5qv0j/K5wLXJPLp0EPomCe1X72mEkA0dTjwQ53SWiD
TI3nPzHN/jubVNSbzmmAGrhhZipYd1cjC80IUFL5j0WCKKVVtmdPOAYasAcvQT03uLkYGF5hnkHY
LT5YnYrPRIpAxpe2Eanvd9RdMkRNTA2Aixjeqg==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 26752)
`pragma protect data_block
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
re9n/I6HPe0+vimXMBjLjsBRUA==
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
