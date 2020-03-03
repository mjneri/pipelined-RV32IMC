// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Thu Feb 13 15:54:24 2020
// Host        : Kouzui running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/MJ/Documents/Vivado/pipelined-RV32IMC/pipelined-RV32IMC.srcs/sources_1/ip/mult_gen_signed/mult_gen_signed_sim_netlist.v
// Design      : mult_gen_signed
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35ticsg324-1L
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "mult_gen_signed,mult_gen_v12_0_16,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "mult_gen_v12_0_16,Vivado 2019.2" *) 
(* NotValidForBitStream *)
module mult_gen_signed
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
  (* C_B_TYPE = "0" *) 
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
  mult_gen_signed_mult_gen_v12_0_16 U0
       (.A(A),
        .B(B),
        .CE(1'b1),
        .CLK(1'b1),
        .P(P),
        .PCASC(NLW_U0_PCASC_UNCONNECTED[47:0]),
        .SCLR(1'b0),
        .ZERO_DETECT(NLW_U0_ZERO_DETECT_UNCONNECTED[1:0]));
endmodule

(* C_A_TYPE = "0" *) (* C_A_WIDTH = "32" *) (* C_B_TYPE = "0" *) 
(* C_B_VALUE = "10000001" *) (* C_B_WIDTH = "32" *) (* C_CCM_IMP = "0" *) 
(* C_CE_OVERRIDES_SCLR = "0" *) (* C_HAS_CE = "0" *) (* C_HAS_SCLR = "0" *) 
(* C_HAS_ZERO_DETECT = "0" *) (* C_LATENCY = "0" *) (* C_MODEL_TYPE = "0" *) 
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
  (* C_B_TYPE = "0" *) 
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
  mult_gen_signed_mult_gen_v12_0_16_viv i_mult
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
d+I4QTcA/KpixHNbZQ/Nusxssrqozr4OWaveLJZIU9086hDKphrvlJyQd9Djs2kVkASN+uI9fcN1
0XzYtYHK1mNlhcnU6mJ6VYvxY9fzKHPOBfhLOdHASQSqJznkmwYFNrCp71j0wcs2QTzPFFWUXMuO
iZliJTSwmWEt1c17HGHY1HPnrMky6v0SHRO65Yhw/OSQ1v83vn7wCfgqlN8Q2PzJyCJWx17BnfwD
eL4AE4yMDaRZnbxUQV+s0zpR9cxbbEkKWCFEYZq3bAVGkhdFzh9QXT/R1QZX90WIG7mJgU93lWSO
ADr2OpWLHK+9H3eAatr+B1HHfrGmhgz6p/0U/A==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
XQYN69noHc339A7pL/HifTesVqLfk70PA+32lZLSCclXjeebbLfdyv3udqpn6p85kp6NQkQdwkML
vlPhSVDYGZvVjpCToG4IE3v+WoH2xAkAghNZbyqRPylp4SQVtXZsWbultaJfGTV1btdmrsIKQwIp
ZpC0xojqigA1x/tAfAGUFI1kZrE1ylFETQKqrJ30tm+jB73xCxe+4pKb1Ty5F4G5AJJDn5DxxOzn
dMV2+mexB5tjrvzP5tn6TV/d82l6TPHo0bgbnZXJoQyJ8RQnXK1uw/kt0DcYpwf9psY7lxNAOhSu
GSZaQcwBY1eoROcDTksy9DU5zWvQU3xppCh7HA==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 28704)
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
