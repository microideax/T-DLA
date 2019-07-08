// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (lin64) Build 2188600 Wed Apr  4 18:39:19 MDT 2018
// Date        : Tue Nov 27 14:31:01 2018
// Host        : kaizhang-MS-7B46 running 64-bit Ubuntu 18.04.1 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/kaizhang/TNN_ACC/test11/test11.srcs/sources_1/bd/design_1/ip/design_1_top_0_0/design_1_top_0_0_stub.v
// Design      : design_1_top_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "top,Vivado 2018.1" *)
module design_1_top_0_0(clk, fast_clk, rst, arm_write_feature_enable, 
  arm_write_feature_addr, arm_write_feature_data, arm_write_feature_select, 
  arm_read_feature_enable, arm_read_feature_addr, arm_read_feature_data, 
  arm_read_feature_select, enable, CLP_state)
/* synthesis syn_black_box black_box_pad_pin="clk,fast_clk,rst,arm_write_feature_enable,arm_write_feature_addr[16:0],arm_write_feature_data[23:0],arm_write_feature_select,arm_read_feature_enable,arm_read_feature_addr[17:0],arm_read_feature_data[23:0],arm_read_feature_select,enable,CLP_state" */;
  input clk;
  input fast_clk;
  input rst;
  input arm_write_feature_enable;
  input [16:0]arm_write_feature_addr;
  input [23:0]arm_write_feature_data;
  input arm_write_feature_select;
  input arm_read_feature_enable;
  input [17:0]arm_read_feature_addr;
  output [23:0]arm_read_feature_data;
  input arm_read_feature_select;
  input enable;
  output CLP_state;
endmodule
