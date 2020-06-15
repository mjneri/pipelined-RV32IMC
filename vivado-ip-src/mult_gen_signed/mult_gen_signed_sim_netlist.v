// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Wed Jun 10 22:39:12 2020
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
OxH9bovGXhvQpBsnA0KY4owIOeIdXIYJN0eQ6ETSKRwQdXsapPhhLXAbo9FkoGwUBHH8RT+KvP1x
kNDs/+Rvf/wfLPhIP7S8xRzEryGj0bKprTT1Xdk/AwHTI4EcdJbgXYUxNsO8Xi/VPa+yJ+PP5rRd
60dyzmyOhdrJFkhRy06+4Lb4bYCnsZifl7oC+7QmgMPTcKaOypTOAnLpRFpovv2HnRnYn0X9cIvE
aXQRnZi+2eCdoHgk80ZJFyYkG7F40mVoxXhyuTTLwTo+cz6y7tMR2eQMu3lo90o20goS7IB4Jkfa
yvgiKpKDGoBKMxSM0+DVLK8e3IEz6gWl9bzOqg==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
HnWx/Hh8jVcLqREQT4q0XBVBehbZaR3a12qYhBhIR9CUkc0gn/+sdJ2t7Ug/7Jj19amOFuDUrx5z
Q+ootVCVsTqfwAa5sdBbVuW/seGzw82r12/RwNEDFBlk9cpR3Hb60l+/62lDoKw7ItaUJhATk7pO
EYu8XJjy+9BsAiNoo2hQ0IsAi9l4g7/YekFjSCpHcHWarJ5xaBVKiSO769l14qX9sjmzXg7qtHd+
XKkYJIOwXGQ41lWITwu18uyVf/l/JL9TzkfeMfWhFyirnyWMvXv5M0MdNDvhsDmtl+yKqqiBUn4w
fX9r9SQAeHPyBRcv80MsRPWRuExhbtQ5wSrh2g==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 26800)
`pragma protect data_block
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
hqlq+5ROLBhizA==
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
