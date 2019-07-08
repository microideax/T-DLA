`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.11.2018 18:29:52
// Design Name: 
// Module Name: tb_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_top();

reg clk;
reg rst;
reg enable;

top mytest(
        .clk(clk),
        .rst(rst),
  
        .arm_write_feature_enable(),
        .arm_write_feature_addr(),
        .arm_write_feature_data(),
        .arm_write_feature_select(),
        
        .arm_read_feature_enable(),
        .arm_read_feature_addr(),
        .arm_read_feature_data(),
        .arm_read_feature_select(),
        
        .enable(enable),
        .CLP_state()      //0 CLP idle    1 CLP busy
        );


initial
    begin
        clk = 0;
        rst = 1;
        enable = 0;
        #50;
        rst = 0;
        enable = 1; 
         
    
    
    
    
    end

always #20 clk = ~clk;


endmodule
