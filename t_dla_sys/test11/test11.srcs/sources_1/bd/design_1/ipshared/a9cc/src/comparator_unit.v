`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/25/2018 02:03:43 PM
// Design Name: 
// Module Name: comparator_unit
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
module comparator_unit#(
    parameter FEATURE_WIDTH = 32    
)(
    input wire                                      clk,
    input wire                                      rst,
    input wire signed [ FEATURE_WIDTH - 1 : 0 ]     data_in_a,
    input wire signed [ FEATURE_WIDTH - 1 : 0 ]     data_in_b,
    output reg signed [ FEATURE_WIDTH - 1 : 0 ]     data_out
    );
always @(posedge clk)
    begin
       if(rst)
           data_out <= 0;
       else
           data_out <= (data_in_a >= data_in_b)?data_in_a:data_in_b;
    end
endmodule