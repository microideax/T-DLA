-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.1 (lin64) Build 2188600 Wed Apr  4 18:39:19 MDT 2018
-- Date        : Tue Nov 27 14:31:01 2018
-- Host        : kaizhang-MS-7B46 running 64-bit Ubuntu 18.04.1 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/kaizhang/TNN_ACC/test11/test11.srcs/sources_1/bd/design_1/ip/design_1_top_0_0/design_1_top_0_0_stub.vhdl
-- Design      : design_1_top_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity design_1_top_0_0 is
  Port ( 
    clk : in STD_LOGIC;
    fast_clk : in STD_LOGIC;
    rst : in STD_LOGIC;
    arm_write_feature_enable : in STD_LOGIC;
    arm_write_feature_addr : in STD_LOGIC_VECTOR ( 16 downto 0 );
    arm_write_feature_data : in STD_LOGIC_VECTOR ( 23 downto 0 );
    arm_write_feature_select : in STD_LOGIC;
    arm_read_feature_enable : in STD_LOGIC;
    arm_read_feature_addr : in STD_LOGIC_VECTOR ( 17 downto 0 );
    arm_read_feature_data : out STD_LOGIC_VECTOR ( 23 downto 0 );
    arm_read_feature_select : in STD_LOGIC;
    enable : in STD_LOGIC;
    CLP_state : out STD_LOGIC
  );

end design_1_top_0_0;

architecture stub of design_1_top_0_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,fast_clk,rst,arm_write_feature_enable,arm_write_feature_addr[16:0],arm_write_feature_data[23:0],arm_write_feature_select,arm_read_feature_enable,arm_read_feature_addr[17:0],arm_read_feature_data[23:0],arm_read_feature_select,enable,CLP_state";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "top,Vivado 2018.1";
begin
end;
