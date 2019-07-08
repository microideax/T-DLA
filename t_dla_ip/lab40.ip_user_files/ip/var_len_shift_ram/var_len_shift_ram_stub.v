// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (lin64) Build 2188600 Wed Apr  4 18:39:19 MDT 2018
// Date        : Mon Nov 26 15:24:11 2018
// Host        : kaizhang-MS-7B46 running 64-bit Ubuntu 18.04.1 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/kaizhang/TNN_ACC/lab40/lab40.srcs/sources_1/ip/var_len_shift_ram/var_len_shift_ram_stub.v
// Design      : var_len_shift_ram
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "c_shift_ram_v12_0_12,Vivado 2018.1" *)
module var_len_shift_ram(A, D, CLK, CE, Q)
/* synthesis syn_black_box black_box_pad_pin="A[7:0],D[7:0],CLK,CE,Q[7:0]" */;
  input [7:0]A;
  input [7:0]D;
  input CLK;
  input CE;
  output [7:0]Q;
endmodule
