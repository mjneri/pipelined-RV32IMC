// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Wed Jun 10 22:41:25 2020
// Host        : Kouzui running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim {C:/Users/MJ/Documents/UP Diliman/5th Year/2nd Sem/CoE
//               198/pipelined-RV32IMC/Vivado Files/ipsrcs/mult_gen_u/mult_gen_u_sim_netlist.v}
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
OIu3yAAEfnJmvkke+d01A0o+7F/phtqhenLMXY4N8aAv0a43zs7QW29x3hHwdOCZ+7Xslc7xHep9
VDvSPF2Hi/Pz9UkRQzyNLszAyw+4BOxmAgRL/0SnW+7ouQUBkEHRLsHwPw0iR+ig022nOQXgIQH8
WyVeIogbfkzmdpx2IRCP/VxqGws+gxF90POEShY/E+3lpz+Rqa+SASXtKRPyE/S2xL/uId/crvDo
rRd/VK/8VdY2Q9ZbHZFParclbQULI+DDocqadqjkMzWj4cUIlrCpXq7dnrUTu0H4yPtn/AudWLmM
eet9eiLtRq+Pmm7kdPtny5IZIIcL6H0Cf8FD5Q==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
TE3gBAn+n0TfQjse8eLOcIdt9uc5k/c7HCew6Q6x3s12wIBmxY3rZ+u3fOzZxArN3LBe6nRi5lmn
uKJehcl7lgDDAwcozTSKrId8nuX7zTrw3CdcdRVcRnJjvkUcdxbqj30w40t1wMD2hl/cnbXHbBtv
6DGoK0VdlBFcALDhq4MUGTleTgU3YLQPeExaJ/vmEvDudcke9vddpsjlqAfGr2Pc7sCj0DiOxsqZ
TclvB3KZ1kBoYmC03lkzqZe0IEjaJBKwho+e2ZrqN+F/YfRQPOLPmn5eRzGssfnQjNx4O3Bl2bn7
TQpXIRVqkt4DxnmASDA+Ecl6Zi74yF0u/nEx4Q==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 26752)
`pragma protect data_block
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
krgkm0r9Hatd7QAwAKqhgunJog==
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
