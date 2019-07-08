`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/02/2018 11:26:05 AM
// Design Name: 
// Module Name: scaler_ctr
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

module scaler_ctr#(
    parameter SCALER_WIDTH = `SCALER_WIDTH
)(
    input wire                                          clk,
    input wire                                          rst,
    input wire                                          state,
    input wire [7:0]                                    scaler_mem_addr,
    output wire [SCALER_WIDTH - 1:0]                    scaler_wire
    );
reg                                     scaler_mem_enable;
reg                                     scaler_mem_enable_p;
wire [SCALER_WIDTH - 1:0]               scaler_mem_dout;
reg                                     scaler_wire_ready;
reg  [SCALER_WIDTH - 1:0]               scaler_buf;
    
scaler_mem_gen scaler_mem (
  .clka(clk),    // input wire clka
  .ena(scaler_mem_enable),      // input wire ena
  .addra(scaler_mem_addr),  // input wire [5 : 0] addra
  .douta(scaler_mem_dout)  // output wire [7 : 0] douta
);
    
    
always@(posedge clk)
    if(rst)
        scaler_mem_enable_p <= 0;
    else
        scaler_mem_enable_p <= scaler_mem_enable;    

always@(posedge clk)
    if(rst)
        begin
            scaler_mem_enable <= 0;
            scaler_wire_ready <= 0;
        end
    else 
        if(state == 0)
            begin
                scaler_mem_enable <= 0;
                scaler_wire_ready <= 0;
            end    
        else    
            if(scaler_wire_ready == 0)
                begin
                    scaler_mem_enable <= 1;
                    scaler_wire_ready <= 1;
                end
            else
                begin
                    scaler_mem_enable <= 0;  
                end     
                

always@(posedge clk)
    if(rst)
        scaler_buf <= 0;
    else
        if((scaler_mem_enable_p == 1) && (scaler_mem_enable == 0))
            scaler_buf <= scaler_mem_dout;    
        else
            scaler_buf <= scaler_buf;
assign scaler_wire = scaler_buf;    
endmodule