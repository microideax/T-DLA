// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (lin64) Build 2258646 Thu Jun 14 20:02:38 MDT 2018
// Date        : Thu Sep 26 15:29:56 2019
// Host        : yao-ADSC running 64-bit Ubuntu 16.04.5 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/yaochen/work/NN/TDLA/t_dla_ip/lab40.srcs/sources_1/ip/i_memory_gen/i_memory_gen_stub.v
// Design      : i_memory_gen
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_1,Vivado 2018.2" *)
module i_memory_gen(clka, ena, wea, addra, dina, clkb, enb, addrb, doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,ena,wea[0:0],addra[8:0],dina[63:0],clkb,enb,addrb[9:0],doutb[31:0]" */;
  input clka;
  input ena;
  input [0:0]wea;
  input [8:0]addra;
  input [63:0]dina;
  input clkb;
  input enb;
  input [9:0]addrb;
  output [31:0]doutb;
endmodule
