// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (lin64) Build 2258646 Thu Jun 14 20:02:38 MDT 2018
// Date        : Wed Sep 25 14:26:12 2019
// Host        : yao-ADSC running 64-bit Ubuntu 16.04.5 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/yaochen/work/NN/TDLA/t_dla_sys/sys_test/test11.srcs/sources_1/bd/design_1/ip/design_1_smartconnect_0_0/design_1_smartconnect_0_0_stub.v
// Design      : design_1_smartconnect_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "bd_48ac,Vivado 2018.2" *)
module design_1_smartconnect_0_0(aclk, aresetn, S00_AXI_awid, S00_AXI_awaddr, 
  S00_AXI_awlen, S00_AXI_awsize, S00_AXI_awburst, S00_AXI_awlock, S00_AXI_awcache, 
  S00_AXI_awprot, S00_AXI_awqos, S00_AXI_awvalid, S00_AXI_awready, S00_AXI_wid, 
  S00_AXI_wdata, S00_AXI_wstrb, S00_AXI_wlast, S00_AXI_wvalid, S00_AXI_wready, S00_AXI_bid, 
  S00_AXI_bresp, S00_AXI_bvalid, S00_AXI_bready, S00_AXI_arid, S00_AXI_araddr, S00_AXI_arlen, 
  S00_AXI_arsize, S00_AXI_arburst, S00_AXI_arlock, S00_AXI_arcache, S00_AXI_arprot, 
  S00_AXI_arqos, S00_AXI_arvalid, S00_AXI_arready, S00_AXI_rid, S00_AXI_rdata, S00_AXI_rresp, 
  S00_AXI_rlast, S00_AXI_rvalid, S00_AXI_rready, M00_AXI_awaddr, M00_AXI_awlen, 
  M00_AXI_awsize, M00_AXI_awburst, M00_AXI_awlock, M00_AXI_awcache, M00_AXI_awprot, 
  M00_AXI_awqos, M00_AXI_awvalid, M00_AXI_awready, M00_AXI_wdata, M00_AXI_wstrb, 
  M00_AXI_wlast, M00_AXI_wvalid, M00_AXI_wready, M00_AXI_bresp, M00_AXI_bvalid, 
  M00_AXI_bready, M00_AXI_araddr, M00_AXI_arlen, M00_AXI_arsize, M00_AXI_arburst, 
  M00_AXI_arlock, M00_AXI_arcache, M00_AXI_arprot, M00_AXI_arqos, M00_AXI_arvalid, 
  M00_AXI_arready, M00_AXI_rdata, M00_AXI_rresp, M00_AXI_rlast, M00_AXI_rvalid, 
  M00_AXI_rready, M01_AXI_awaddr, M01_AXI_awlen, M01_AXI_awsize, M01_AXI_awburst, 
  M01_AXI_awlock, M01_AXI_awcache, M01_AXI_awprot, M01_AXI_awqos, M01_AXI_awvalid, 
  M01_AXI_awready, M01_AXI_wdata, M01_AXI_wstrb, M01_AXI_wlast, M01_AXI_wvalid, 
  M01_AXI_wready, M01_AXI_bresp, M01_AXI_bvalid, M01_AXI_bready, M01_AXI_araddr, 
  M01_AXI_arlen, M01_AXI_arsize, M01_AXI_arburst, M01_AXI_arlock, M01_AXI_arcache, 
  M01_AXI_arprot, M01_AXI_arqos, M01_AXI_arvalid, M01_AXI_arready, M01_AXI_rdata, 
  M01_AXI_rresp, M01_AXI_rlast, M01_AXI_rvalid, M01_AXI_rready, M02_AXI_awaddr, 
  M02_AXI_awprot, M02_AXI_awvalid, M02_AXI_awready, M02_AXI_wdata, M02_AXI_wstrb, 
  M02_AXI_wvalid, M02_AXI_wready, M02_AXI_bresp, M02_AXI_bvalid, M02_AXI_bready, 
  M02_AXI_araddr, M02_AXI_arprot, M02_AXI_arvalid, M02_AXI_arready, M02_AXI_rdata, 
  M02_AXI_rresp, M02_AXI_rvalid, M02_AXI_rready, M03_AXI_awaddr, M03_AXI_awprot, 
  M03_AXI_awvalid, M03_AXI_awready, M03_AXI_wdata, M03_AXI_wstrb, M03_AXI_wvalid, 
  M03_AXI_wready, M03_AXI_bresp, M03_AXI_bvalid, M03_AXI_bready, M03_AXI_araddr, 
  M03_AXI_arprot, M03_AXI_arvalid, M03_AXI_arready, M03_AXI_rdata, M03_AXI_rresp, 
  M03_AXI_rvalid, M03_AXI_rready, M04_AXI_awid, M04_AXI_awaddr, M04_AXI_awlen, 
  M04_AXI_awsize, M04_AXI_awburst, M04_AXI_awlock, M04_AXI_awcache, M04_AXI_awprot, 
  M04_AXI_awregion, M04_AXI_awqos, M04_AXI_awuser, M04_AXI_awvalid, M04_AXI_awready, 
  M04_AXI_wid, M04_AXI_wdata, M04_AXI_wstrb, M04_AXI_wlast, M04_AXI_wuser, M04_AXI_wvalid, 
  M04_AXI_wready, M04_AXI_bid, M04_AXI_bresp, M04_AXI_buser, M04_AXI_bvalid, M04_AXI_bready, 
  M04_AXI_arid, M04_AXI_araddr, M04_AXI_arlen, M04_AXI_arsize, M04_AXI_arburst, 
  M04_AXI_arlock, M04_AXI_arcache, M04_AXI_arprot, M04_AXI_arregion, M04_AXI_arqos, 
  M04_AXI_aruser, M04_AXI_arvalid, M04_AXI_arready, M04_AXI_rid, M04_AXI_rdata, 
  M04_AXI_rresp, M04_AXI_rlast, M04_AXI_ruser, M04_AXI_rvalid, M04_AXI_rready, M05_AXI_awid, 
  M05_AXI_awaddr, M05_AXI_awlen, M05_AXI_awsize, M05_AXI_awburst, M05_AXI_awlock, 
  M05_AXI_awcache, M05_AXI_awprot, M05_AXI_awregion, M05_AXI_awqos, M05_AXI_awuser, 
  M05_AXI_awvalid, M05_AXI_awready, M05_AXI_wid, M05_AXI_wdata, M05_AXI_wstrb, M05_AXI_wlast, 
  M05_AXI_wuser, M05_AXI_wvalid, M05_AXI_wready, M05_AXI_bid, M05_AXI_bresp, M05_AXI_buser, 
  M05_AXI_bvalid, M05_AXI_bready, M05_AXI_arid, M05_AXI_araddr, M05_AXI_arlen, 
  M05_AXI_arsize, M05_AXI_arburst, M05_AXI_arlock, M05_AXI_arcache, M05_AXI_arprot, 
  M05_AXI_arregion, M05_AXI_arqos, M05_AXI_aruser, M05_AXI_arvalid, M05_AXI_arready, 
  M05_AXI_rid, M05_AXI_rdata, M05_AXI_rresp, M05_AXI_rlast, M05_AXI_ruser, M05_AXI_rvalid, 
  M05_AXI_rready)
/* synthesis syn_black_box black_box_pad_pin="aclk,aresetn,S00_AXI_awid[11:0],S00_AXI_awaddr[31:0],S00_AXI_awlen[3:0],S00_AXI_awsize[2:0],S00_AXI_awburst[1:0],S00_AXI_awlock[1:0],S00_AXI_awcache[3:0],S00_AXI_awprot[2:0],S00_AXI_awqos[3:0],S00_AXI_awvalid,S00_AXI_awready,S00_AXI_wid[11:0],S00_AXI_wdata[31:0],S00_AXI_wstrb[3:0],S00_AXI_wlast,S00_AXI_wvalid,S00_AXI_wready,S00_AXI_bid[11:0],S00_AXI_bresp[1:0],S00_AXI_bvalid,S00_AXI_bready,S00_AXI_arid[11:0],S00_AXI_araddr[31:0],S00_AXI_arlen[3:0],S00_AXI_arsize[2:0],S00_AXI_arburst[1:0],S00_AXI_arlock[1:0],S00_AXI_arcache[3:0],S00_AXI_arprot[2:0],S00_AXI_arqos[3:0],S00_AXI_arvalid,S00_AXI_arready,S00_AXI_rid[11:0],S00_AXI_rdata[31:0],S00_AXI_rresp[1:0],S00_AXI_rlast,S00_AXI_rvalid,S00_AXI_rready,M00_AXI_awaddr[15:0],M00_AXI_awlen[7:0],M00_AXI_awsize[2:0],M00_AXI_awburst[1:0],M00_AXI_awlock[0:0],M00_AXI_awcache[3:0],M00_AXI_awprot[2:0],M00_AXI_awqos[3:0],M00_AXI_awvalid,M00_AXI_awready,M00_AXI_wdata[31:0],M00_AXI_wstrb[3:0],M00_AXI_wlast,M00_AXI_wvalid,M00_AXI_wready,M00_AXI_bresp[1:0],M00_AXI_bvalid,M00_AXI_bready,M00_AXI_araddr[15:0],M00_AXI_arlen[7:0],M00_AXI_arsize[2:0],M00_AXI_arburst[1:0],M00_AXI_arlock[0:0],M00_AXI_arcache[3:0],M00_AXI_arprot[2:0],M00_AXI_arqos[3:0],M00_AXI_arvalid,M00_AXI_arready,M00_AXI_rdata[31:0],M00_AXI_rresp[1:0],M00_AXI_rlast,M00_AXI_rvalid,M00_AXI_rready,M01_AXI_awaddr[15:0],M01_AXI_awlen[7:0],M01_AXI_awsize[2:0],M01_AXI_awburst[1:0],M01_AXI_awlock[0:0],M01_AXI_awcache[3:0],M01_AXI_awprot[2:0],M01_AXI_awqos[3:0],M01_AXI_awvalid,M01_AXI_awready,M01_AXI_wdata[31:0],M01_AXI_wstrb[3:0],M01_AXI_wlast,M01_AXI_wvalid,M01_AXI_wready,M01_AXI_bresp[1:0],M01_AXI_bvalid,M01_AXI_bready,M01_AXI_araddr[15:0],M01_AXI_arlen[7:0],M01_AXI_arsize[2:0],M01_AXI_arburst[1:0],M01_AXI_arlock[0:0],M01_AXI_arcache[3:0],M01_AXI_arprot[2:0],M01_AXI_arqos[3:0],M01_AXI_arvalid,M01_AXI_arready,M01_AXI_rdata[31:0],M01_AXI_rresp[1:0],M01_AXI_rlast,M01_AXI_rvalid,M01_AXI_rready,M02_AXI_awaddr[8:0],M02_AXI_awprot[2:0],M02_AXI_awvalid,M02_AXI_awready,M02_AXI_wdata[31:0],M02_AXI_wstrb[3:0],M02_AXI_wvalid,M02_AXI_wready,M02_AXI_bresp[1:0],M02_AXI_bvalid,M02_AXI_bready,M02_AXI_araddr[8:0],M02_AXI_arprot[2:0],M02_AXI_arvalid,M02_AXI_arready,M02_AXI_rdata[31:0],M02_AXI_rresp[1:0],M02_AXI_rvalid,M02_AXI_rready,M03_AXI_awaddr[8:0],M03_AXI_awprot[2:0],M03_AXI_awvalid,M03_AXI_awready,M03_AXI_wdata[31:0],M03_AXI_wstrb[3:0],M03_AXI_wvalid,M03_AXI_wready,M03_AXI_bresp[1:0],M03_AXI_bvalid,M03_AXI_bready,M03_AXI_araddr[8:0],M03_AXI_arprot[2:0],M03_AXI_arvalid,M03_AXI_arready,M03_AXI_rdata[31:0],M03_AXI_rresp[1:0],M03_AXI_rvalid,M03_AXI_rready,M04_AXI_awid,M04_AXI_awaddr,M04_AXI_awlen,M04_AXI_awsize[2:0],M04_AXI_awburst[1:0],M04_AXI_awlock,M04_AXI_awcache[3:0],M04_AXI_awprot[2:0],M04_AXI_awregion[3:0],M04_AXI_awqos[3:0],M04_AXI_awuser,M04_AXI_awvalid[0:0],M04_AXI_awready[0:0],M04_AXI_wid,M04_AXI_wdata,M04_AXI_wstrb,M04_AXI_wlast[0:0],M04_AXI_wuser,M04_AXI_wvalid[0:0],M04_AXI_wready[0:0],M04_AXI_bid,M04_AXI_bresp[1:0],M04_AXI_buser,M04_AXI_bvalid[0:0],M04_AXI_bready[0:0],M04_AXI_arid,M04_AXI_araddr,M04_AXI_arlen,M04_AXI_arsize[2:0],M04_AXI_arburst[1:0],M04_AXI_arlock,M04_AXI_arcache[3:0],M04_AXI_arprot[2:0],M04_AXI_arregion[3:0],M04_AXI_arqos[3:0],M04_AXI_aruser,M04_AXI_arvalid[0:0],M04_AXI_arready[0:0],M04_AXI_rid,M04_AXI_rdata,M04_AXI_rresp[1:0],M04_AXI_rlast[0:0],M04_AXI_ruser,M04_AXI_rvalid[0:0],M04_AXI_rready[0:0],M05_AXI_awid,M05_AXI_awaddr,M05_AXI_awlen,M05_AXI_awsize[2:0],M05_AXI_awburst[1:0],M05_AXI_awlock,M05_AXI_awcache[3:0],M05_AXI_awprot[2:0],M05_AXI_awregion[3:0],M05_AXI_awqos[3:0],M05_AXI_awuser,M05_AXI_awvalid[0:0],M05_AXI_awready[0:0],M05_AXI_wid,M05_AXI_wdata,M05_AXI_wstrb,M05_AXI_wlast[0:0],M05_AXI_wuser,M05_AXI_wvalid[0:0],M05_AXI_wready[0:0],M05_AXI_bid,M05_AXI_bresp[1:0],M05_AXI_buser,M05_AXI_bvalid[0:0],M05_AXI_bready[0:0],M05_AXI_arid,M05_AXI_araddr,M05_AXI_arlen,M05_AXI_arsize[2:0],M05_AXI_arburst[1:0],M05_AXI_arlock,M05_AXI_arcache[3:0],M05_AXI_arprot[2:0],M05_AXI_arregion[3:0],M05_AXI_arqos[3:0],M05_AXI_aruser,M05_AXI_arvalid[0:0],M05_AXI_arready[0:0],M05_AXI_rid,M05_AXI_rdata,M05_AXI_rresp[1:0],M05_AXI_rlast[0:0],M05_AXI_ruser,M05_AXI_rvalid[0:0],M05_AXI_rready[0:0]" */;
  input aclk;
  input aresetn;
  input [11:0]S00_AXI_awid;
  input [31:0]S00_AXI_awaddr;
  input [3:0]S00_AXI_awlen;
  input [2:0]S00_AXI_awsize;
  input [1:0]S00_AXI_awburst;
  input [1:0]S00_AXI_awlock;
  input [3:0]S00_AXI_awcache;
  input [2:0]S00_AXI_awprot;
  input [3:0]S00_AXI_awqos;
  input S00_AXI_awvalid;
  output S00_AXI_awready;
  input [11:0]S00_AXI_wid;
  input [31:0]S00_AXI_wdata;
  input [3:0]S00_AXI_wstrb;
  input S00_AXI_wlast;
  input S00_AXI_wvalid;
  output S00_AXI_wready;
  output [11:0]S00_AXI_bid;
  output [1:0]S00_AXI_bresp;
  output S00_AXI_bvalid;
  input S00_AXI_bready;
  input [11:0]S00_AXI_arid;
  input [31:0]S00_AXI_araddr;
  input [3:0]S00_AXI_arlen;
  input [2:0]S00_AXI_arsize;
  input [1:0]S00_AXI_arburst;
  input [1:0]S00_AXI_arlock;
  input [3:0]S00_AXI_arcache;
  input [2:0]S00_AXI_arprot;
  input [3:0]S00_AXI_arqos;
  input S00_AXI_arvalid;
  output S00_AXI_arready;
  output [11:0]S00_AXI_rid;
  output [31:0]S00_AXI_rdata;
  output [1:0]S00_AXI_rresp;
  output S00_AXI_rlast;
  output S00_AXI_rvalid;
  input S00_AXI_rready;
  output [15:0]M00_AXI_awaddr;
  output [7:0]M00_AXI_awlen;
  output [2:0]M00_AXI_awsize;
  output [1:0]M00_AXI_awburst;
  output [0:0]M00_AXI_awlock;
  output [3:0]M00_AXI_awcache;
  output [2:0]M00_AXI_awprot;
  output [3:0]M00_AXI_awqos;
  output M00_AXI_awvalid;
  input M00_AXI_awready;
  output [31:0]M00_AXI_wdata;
  output [3:0]M00_AXI_wstrb;
  output M00_AXI_wlast;
  output M00_AXI_wvalid;
  input M00_AXI_wready;
  input [1:0]M00_AXI_bresp;
  input M00_AXI_bvalid;
  output M00_AXI_bready;
  output [15:0]M00_AXI_araddr;
  output [7:0]M00_AXI_arlen;
  output [2:0]M00_AXI_arsize;
  output [1:0]M00_AXI_arburst;
  output [0:0]M00_AXI_arlock;
  output [3:0]M00_AXI_arcache;
  output [2:0]M00_AXI_arprot;
  output [3:0]M00_AXI_arqos;
  output M00_AXI_arvalid;
  input M00_AXI_arready;
  input [31:0]M00_AXI_rdata;
  input [1:0]M00_AXI_rresp;
  input M00_AXI_rlast;
  input M00_AXI_rvalid;
  output M00_AXI_rready;
  output [15:0]M01_AXI_awaddr;
  output [7:0]M01_AXI_awlen;
  output [2:0]M01_AXI_awsize;
  output [1:0]M01_AXI_awburst;
  output [0:0]M01_AXI_awlock;
  output [3:0]M01_AXI_awcache;
  output [2:0]M01_AXI_awprot;
  output [3:0]M01_AXI_awqos;
  output M01_AXI_awvalid;
  input M01_AXI_awready;
  output [31:0]M01_AXI_wdata;
  output [3:0]M01_AXI_wstrb;
  output M01_AXI_wlast;
  output M01_AXI_wvalid;
  input M01_AXI_wready;
  input [1:0]M01_AXI_bresp;
  input M01_AXI_bvalid;
  output M01_AXI_bready;
  output [15:0]M01_AXI_araddr;
  output [7:0]M01_AXI_arlen;
  output [2:0]M01_AXI_arsize;
  output [1:0]M01_AXI_arburst;
  output [0:0]M01_AXI_arlock;
  output [3:0]M01_AXI_arcache;
  output [2:0]M01_AXI_arprot;
  output [3:0]M01_AXI_arqos;
  output M01_AXI_arvalid;
  input M01_AXI_arready;
  input [31:0]M01_AXI_rdata;
  input [1:0]M01_AXI_rresp;
  input M01_AXI_rlast;
  input M01_AXI_rvalid;
  output M01_AXI_rready;
  output [8:0]M02_AXI_awaddr;
  output [2:0]M02_AXI_awprot;
  output M02_AXI_awvalid;
  input M02_AXI_awready;
  output [31:0]M02_AXI_wdata;
  output [3:0]M02_AXI_wstrb;
  output M02_AXI_wvalid;
  input M02_AXI_wready;
  input [1:0]M02_AXI_bresp;
  input M02_AXI_bvalid;
  output M02_AXI_bready;
  output [8:0]M02_AXI_araddr;
  output [2:0]M02_AXI_arprot;
  output M02_AXI_arvalid;
  input M02_AXI_arready;
  input [31:0]M02_AXI_rdata;
  input [1:0]M02_AXI_rresp;
  input M02_AXI_rvalid;
  output M02_AXI_rready;
  output [8:0]M03_AXI_awaddr;
  output [2:0]M03_AXI_awprot;
  output M03_AXI_awvalid;
  input M03_AXI_awready;
  output [31:0]M03_AXI_wdata;
  output [3:0]M03_AXI_wstrb;
  output M03_AXI_wvalid;
  input M03_AXI_wready;
  input [1:0]M03_AXI_bresp;
  input M03_AXI_bvalid;
  output M03_AXI_bready;
  output [8:0]M03_AXI_araddr;
  output [2:0]M03_AXI_arprot;
  output M03_AXI_arvalid;
  input M03_AXI_arready;
  input [31:0]M03_AXI_rdata;
  input [1:0]M03_AXI_rresp;
  input M03_AXI_rvalid;
  output M03_AXI_rready;
  output M04_AXI_awid;
  output M04_AXI_awaddr;
  output M04_AXI_awlen;
  output [2:0]M04_AXI_awsize;
  output [1:0]M04_AXI_awburst;
  output M04_AXI_awlock;
  output [3:0]M04_AXI_awcache;
  output [2:0]M04_AXI_awprot;
  output [3:0]M04_AXI_awregion;
  output [3:0]M04_AXI_awqos;
  output M04_AXI_awuser;
  output [0:0]M04_AXI_awvalid;
  input [0:0]M04_AXI_awready;
  output M04_AXI_wid;
  output M04_AXI_wdata;
  output M04_AXI_wstrb;
  output [0:0]M04_AXI_wlast;
  output M04_AXI_wuser;
  output [0:0]M04_AXI_wvalid;
  input [0:0]M04_AXI_wready;
  input M04_AXI_bid;
  input [1:0]M04_AXI_bresp;
  input M04_AXI_buser;
  input [0:0]M04_AXI_bvalid;
  output [0:0]M04_AXI_bready;
  output M04_AXI_arid;
  output M04_AXI_araddr;
  output M04_AXI_arlen;
  output [2:0]M04_AXI_arsize;
  output [1:0]M04_AXI_arburst;
  output M04_AXI_arlock;
  output [3:0]M04_AXI_arcache;
  output [2:0]M04_AXI_arprot;
  output [3:0]M04_AXI_arregion;
  output [3:0]M04_AXI_arqos;
  output M04_AXI_aruser;
  output [0:0]M04_AXI_arvalid;
  input [0:0]M04_AXI_arready;
  input M04_AXI_rid;
  input M04_AXI_rdata;
  input [1:0]M04_AXI_rresp;
  input [0:0]M04_AXI_rlast;
  input M04_AXI_ruser;
  input [0:0]M04_AXI_rvalid;
  output [0:0]M04_AXI_rready;
  output M05_AXI_awid;
  output M05_AXI_awaddr;
  output M05_AXI_awlen;
  output [2:0]M05_AXI_awsize;
  output [1:0]M05_AXI_awburst;
  output M05_AXI_awlock;
  output [3:0]M05_AXI_awcache;
  output [2:0]M05_AXI_awprot;
  output [3:0]M05_AXI_awregion;
  output [3:0]M05_AXI_awqos;
  output M05_AXI_awuser;
  output [0:0]M05_AXI_awvalid;
  input [0:0]M05_AXI_awready;
  output M05_AXI_wid;
  output M05_AXI_wdata;
  output M05_AXI_wstrb;
  output [0:0]M05_AXI_wlast;
  output M05_AXI_wuser;
  output [0:0]M05_AXI_wvalid;
  input [0:0]M05_AXI_wready;
  input M05_AXI_bid;
  input [1:0]M05_AXI_bresp;
  input M05_AXI_buser;
  input [0:0]M05_AXI_bvalid;
  output [0:0]M05_AXI_bready;
  output M05_AXI_arid;
  output M05_AXI_araddr;
  output M05_AXI_arlen;
  output [2:0]M05_AXI_arsize;
  output [1:0]M05_AXI_arburst;
  output M05_AXI_arlock;
  output [3:0]M05_AXI_arcache;
  output [2:0]M05_AXI_arprot;
  output [3:0]M05_AXI_arregion;
  output [3:0]M05_AXI_arqos;
  output M05_AXI_aruser;
  output [0:0]M05_AXI_arvalid;
  input [0:0]M05_AXI_arready;
  input M05_AXI_rid;
  input M05_AXI_rdata;
  input [1:0]M05_AXI_rresp;
  input [0:0]M05_AXI_rlast;
  input M05_AXI_ruser;
  input [0:0]M05_AXI_rvalid;
  output [0:0]M05_AXI_rready;
endmodule
