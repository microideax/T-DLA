// (c) Copyright 1995-2018 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: user.org:user:top:1.0
// IP Revision: 2

(* X_CORE_INFO = "top,Vivado 2018.1" *)
(* CHECK_LICENSE_TYPE = "design_1_top_0_0,top,{}" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module design_1_top_0_0 (
  clk,
  fast_clk,
  rst,
  arm_write_feature_enable,
  arm_write_feature_addr,
  arm_write_feature_data,
  arm_write_feature_select,
  arm_read_feature_enable,
  arm_read_feature_addr,
  arm_read_feature_data,
  arm_read_feature_select,
  enable,
  CLP_state
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk, FREQ_HZ 125000000, PHASE 0.000, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
input wire clk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME fast_clk, FREQ_HZ 250000000, PHASE 0.000, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK1" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 fast_clk CLK" *)
input wire fast_clk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME rst, POLARITY ACTIVE_LOW" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 rst RST" *)
input wire rst;
input wire arm_write_feature_enable;
input wire [16 : 0] arm_write_feature_addr;
input wire [23 : 0] arm_write_feature_data;
input wire arm_write_feature_select;
input wire arm_read_feature_enable;
input wire [17 : 0] arm_read_feature_addr;
output wire [23 : 0] arm_read_feature_data;
input wire arm_read_feature_select;
input wire enable;
output wire CLP_state;

  top #(
    .Tn(4),
    .Tm(8),
    .KERNEL_SIZE(5),
    .KERNEL_WIDTH(2),
    .FEATURE_WIDTH(12),
    .SCALER_WIDTH(12)
  ) inst (
    .clk(clk),
    .fast_clk(fast_clk),
    .rst(rst),
    .arm_write_feature_enable(arm_write_feature_enable),
    .arm_write_feature_addr(arm_write_feature_addr),
    .arm_write_feature_data(arm_write_feature_data),
    .arm_write_feature_select(arm_write_feature_select),
    .arm_read_feature_enable(arm_read_feature_enable),
    .arm_read_feature_addr(arm_read_feature_addr),
    .arm_read_feature_data(arm_read_feature_data),
    .arm_read_feature_select(arm_read_feature_select),
    .enable(enable),
    .CLP_state(CLP_state)
  );
endmodule
