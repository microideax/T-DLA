`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2018 05:32:39 PM
// Design Name: 
// Module Name: line_buffer
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
`include "network_para.vh"

module line_buffer#(
    parameter DATA_WIDTH = `FEATURE_WIDTH,
    parameter KERNEL_SIZE = `KERNEL_SIZE    
)(
    input wire                                      clk,
    input wire                                      enable,
    input wire                                      line_buffer_mod,
    input wire  [2:0]                               current_kernel_size,
    input wire  [7:0]                               shift_ram_depth,
    input wire  [DATA_WIDTH * KERNEL_SIZE - 1 : 0 ] data_in,
    output wire [DATA_WIDTH * KERNEL_SIZE - 1 : 0 ] data_out
    );
    
wire [ DATA_WIDTH - 1 : 0 ]                           data_wire[KERNEL_SIZE - 2 : 0];
wire [ DATA_WIDTH - 1 : 0 ]                           shift_ram_in[KERNEL_SIZE - 1 : 0];  

genvar i;


assign shift_ram_in[0] = (line_buffer_mod == 0)? data_in[(KERNEL_SIZE - 1) * DATA_WIDTH + DATA_WIDTH - 1 : (KERNEL_SIZE - 1) * DATA_WIDTH ] : ((current_kernel_size==5)? data_in[DATA_WIDTH - 1 : 0] : {DATA_WIDTH{1'd0}});

assign shift_ram_in[1] = (line_buffer_mod == 0)? data_in[(KERNEL_SIZE - 2) * DATA_WIDTH + DATA_WIDTH - 1 : (KERNEL_SIZE - 2) * DATA_WIDTH ] : ((current_kernel_size==5)? data_wire[0] : {DATA_WIDTH{1'd0}});
    
assign shift_ram_in[2] = (line_buffer_mod == 0)? data_in[(KERNEL_SIZE - 3) * DATA_WIDTH + DATA_WIDTH - 1 : (KERNEL_SIZE - 3) * DATA_WIDTH ] : ((current_kernel_size==5)? data_wire[1] : data_in[DATA_WIDTH - 1 : 0]);
        
assign shift_ram_in[3] = (line_buffer_mod == 0)? data_in[(KERNEL_SIZE - 4) * DATA_WIDTH + DATA_WIDTH - 1 : (KERNEL_SIZE - 4) * DATA_WIDTH ] : data_wire[2];

              
var_len_shift_ram ram0 (
                .A(shift_ram_depth),      // input wire [7 : 0] A
                .D(shift_ram_in[0]),      // input wire [11 : 0] D
                .CLK(clk),  // input wire CLK
                .CE(enable),    // input wire CE
                .Q(data_wire[0])      // output wire [11 : 0] Q
              );              
                       
generate 
    for(i = 0; i < KERNEL_SIZE-2 ; i = i+1) begin:buffer_wire    //buffer1 ---> (KERNEL_SIZE-2)
        var_len_shift_ram ram1 (
                    .A(shift_ram_depth),      // input wire [7 : 0] A
                    .D(shift_ram_in[i+1]),      // input wire [11 : 0] D
                    .CLK(clk),  // input wire CLK
                    .CE(enable),    // input wire CE
                    .Q(data_wire[i+1])      // output wire [11 : 0] Q
                  );
    end
endgenerate

assign data_out[DATA_WIDTH - 1 : 0]                  = data_wire[3];
assign data_out[DATA_WIDTH * 2 - 1 : DATA_WIDTH]     = data_wire[2];
assign data_out[DATA_WIDTH * 3 - 1 : DATA_WIDTH * 2] = (current_kernel_size==5)  ?  data_wire[1]: data_in[DATA_WIDTH - 1 : 0];
assign data_out[DATA_WIDTH * 4 - 1 : DATA_WIDTH * 3] = (current_kernel_size==5)  ?  data_wire[0]: {DATA_WIDTH{1'd0}};
assign data_out[DATA_WIDTH * 5 - 1 : DATA_WIDTH * 4] = (current_kernel_size==5)  ?  data_in[DATA_WIDTH - 1 : 0] : {DATA_WIDTH{1'd0}};

endmodule