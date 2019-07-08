`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/28/2018 10:45:54 PM
// Design Name: 
// Module Name: top
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

module top#(
        parameter Tn = `Tn,
        parameter Tm = `Tm,
        parameter KERNEL_SIZE = `KERNEL_SIZE,
        parameter KERNEL_WIDTH = `KERNEL_WIDTH,
        parameter FEATURE_WIDTH = `FEATURE_WIDTH,
        parameter SCALER_WIDTH = `SCALER_WIDTH
)(
        input   wire                                        clk,
        input   wire                                        fast_clk,
        input   wire                                        rst,
  
        input   wire                                        arm_write_feature_enable,
        input   wire  [14+2:0]                              arm_write_feature_addr,
        input   wire  [FEATURE_WIDTH*2 - 1 : 0]             arm_write_feature_data,
        input   wire                                        arm_write_feature_select,
         
        input   wire                                        arm_read_feature_enable,
        input   wire  [15+2:0]                              arm_read_feature_addr,
        output  wire  [FEATURE_WIDTH*2 - 1 : 0]             arm_read_feature_data,
        input   wire                                        arm_read_feature_select,
        
        input   wire                                        enable,
        output  wire                                        CLP_state      //0 CLP idle    1 CLP busy
        );



reg      [9:0]      i_mem_addr;
wire     [63:0]     i_mem_dout;


reg                 CLP_enable;
reg      [63:0]     ctr;
reg                 CLP_state_p;

i_memory_gen instruction_mem(
                .clka(clk),
                .ena(1'b1),
                .addra(i_mem_addr),  // input wire [9 : 0] addra
                .douta(i_mem_dout)  // output wire [63 : 0] douta
            );

always@(posedge clk)
    if(rst)
        CLP_state_p <= 0;
    else
        CLP_state_p <= CLP_state;

always@(posedge clk)
    if(rst)
        i_mem_addr <= 0;
    else
        if((CLP_state == 0) && (CLP_state_p == 1))
            i_mem_addr <= i_mem_addr + 1;
        else
            i_mem_addr <= i_mem_addr;  


reg  [3:0]state;


always@(posedge clk)
    if(rst)
        begin
            CLP_enable <= 0;
            ctr <= 0;
            state <= 0;
        end
    else
        begin
            case(state)
                0:begin
                    if(enable == 1)
                        state <= 1;
                    else 
                        state <= state;
                end    
                1,2:begin
                    state <= state + 1;
                end
                3:begin
                    CLP_enable<=1;
                    ctr <= i_mem_dout;
                    state <= 4;
                end
                4:begin
                    CLP_enable <= 0;
                    state <= 5;
                end  
                    
                5:begin
                    if(CLP_state == 0)
                        state <= 0;
                    else
                        state <= state;
                end
            endcase
        end
 
 
 
CLP_ctr CLP_ctr0(
            .clk(clk),
            .fast_clk(fast_clk),
            .rst(rst),
            .enable(CLP_enable),
            .instruction(ctr),
            .arm_write_feature_enable(arm_write_feature_enable),
            .arm_write_feature_addr(arm_write_feature_addr[16:2]),
            .arm_write_feature_data(arm_write_feature_data),
            .arm_write_feature_select(arm_write_feature_select),
             
            .arm_read_feature_enable(arm_read_feature_enable),
            .arm_read_feature_addr(arm_read_feature_addr[17:2]),
            .arm_read_feature_data(arm_read_feature_data),
            .arm_read_feature_select(arm_read_feature_select),
            .state(CLP_state)
            );    
        
        
reg [12:0] cnt_for_test;

always@(posedge clk)
    if(rst)
        cnt_for_test <= 0;
    else
        cnt_for_test <= cnt_for_test + 1;

endmodule