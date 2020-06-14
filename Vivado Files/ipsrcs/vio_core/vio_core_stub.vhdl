-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
-- Date        : Sat Mar 14 15:52:02 2020
-- Host        : Kouzui running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               c:/Users/MJ/Documents/Vivado/pipelined-RV32IMC/pipelined-RV32IMC.srcs/sources_1/ip/vio_core/vio_core_stub.vhdl
-- Design      : vio_core
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35ticsg324-1L
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vio_core is
  Port ( 
    clk : in STD_LOGIC;
    probe_in0 : in STD_LOGIC_VECTOR ( 11 downto 0 );
    probe_in1 : in STD_LOGIC_VECTOR ( 11 downto 0 );
    probe_in2 : in STD_LOGIC_VECTOR ( 11 downto 0 );
    probe_in3 : in STD_LOGIC_VECTOR ( 11 downto 0 );
    probe_in4 : in STD_LOGIC_VECTOR ( 11 downto 0 );
    probe_in5 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    probe_in6 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe_in7 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe_in8 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe_in9 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe_in10 : in STD_LOGIC_VECTOR ( 11 downto 0 );
    probe_in11 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe_in12 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe_in13 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe_in14 : in STD_LOGIC_VECTOR ( 3 downto 0 );
    probe_in15 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    probe_in16 : in STD_LOGIC_VECTOR ( 2 downto 0 );
    probe_in17 : in STD_LOGIC_VECTOR ( 31 downto 0 );
    probe_in18 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe_out0 : out STD_LOGIC_VECTOR ( 0 to 0 )
  );

end vio_core;

architecture stub of vio_core is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,probe_in0[11:0],probe_in1[11:0],probe_in2[11:0],probe_in3[11:0],probe_in4[11:0],probe_in5[31:0],probe_in6[0:0],probe_in7[0:0],probe_in8[0:0],probe_in9[0:0],probe_in10[11:0],probe_in11[0:0],probe_in12[0:0],probe_in13[0:0],probe_in14[3:0],probe_in15[31:0],probe_in16[2:0],probe_in17[31:0],probe_in18[0:0],probe_out0[0:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "vio,Vivado 2019.2";
begin
end;
