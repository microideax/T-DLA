// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (lin64) Build 2188600 Wed Apr  4 18:39:19 MDT 2018
// Date        : Mon Nov 26 16:08:06 2018
// Host        : kaizhang-MS-7B46 running 64-bit Ubuntu 18.04.1 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/kaizhang/TNN_ACC/lab40/lab40.srcs/sources_1/ip/weight_ram_gen/weight_ram_gen_stub.v
// Design      : weight_ram_gen
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_1,Vivado 2018.1" *)
module weight_ram_gen(clka, ena, wea, addra, dina, clkb, enb, addrb, doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,ena,wea[0:0],addra[14:0],dina[49:0],clkb,enb,addrb[11:0],doutb[399:0]" */;
  input clka;
  input ena;
  input [0:0]wea;
  input [14:0]addra;
  input [49:0]dina;
  input clkb;
  input enb;
  input [11:0]addrb;
  output [399:0]doutb;
endmodule
