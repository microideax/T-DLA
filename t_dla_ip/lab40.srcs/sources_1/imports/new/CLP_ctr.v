`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/29/2018 07:46:24 PM
// Design Name: 
// Module Name: CLP_ctr
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//      change feature_width from 12 to 8
// Dependencies: 
//      
// Revision:
// Revision 0.01 - File Created
// Additional Comments:

//////////////////////////////////////////////////////////////////////////////////
`include "network_para.vh"

module CLP_ctr#(
    parameter Tn = `Tn,
    parameter Tm = `Tm,
    parameter KERNEL_SIZE = `KERNEL_SIZE,
    parameter KERNEL_WIDTH = `KERNEL_WIDTH,
    parameter FEATURE_WIDTH = `FEATURE_WIDTH,
    parameter SCALER_WIDTH = `SCALER_WIDTH,
    parameter BIAS_WIDTH = `BIAS_WIDTH
)(
    input   wire                                        clk,
    input   wire                                        fast_clk,
    input   wire                                        rst,
    input   wire                                        enable,
    input   wire  [63:0]                                instruction,
    
    input   wire                                        arm_write_feature_enable,
    input   wire  [14:0]                                arm_write_feature_addr,
    input   wire  [FEATURE_WIDTH*2 - 1 : 0]             arm_write_feature_data,
    input   wire                                        arm_write_feature_select,
     
    input   wire                                        arm_read_feature_enable,
    input   wire  [15:0]                                arm_read_feature_addr,
    output  wire  [FEATURE_WIDTH*2 - 1 : 0]             arm_read_feature_data,
    input   wire                                        arm_read_feature_select,
    
    output  reg                                         state
    );
    
genvar i,j,k,x,y,z;


// wire for instructions
wire     [3:0]           CLP_type;
wire     [2:0]           current_kernel_size;
wire     [15:0]          CLP_work_time;
wire     [7:0]           scaler_mem_addr;
wire     [15:0]          weight_mem_init_addr;
wire                     feature_in_select;       //   0 :  CLP read feature from ram0          1:  CLP read feature from ram1
wire                     feature_out_select;     //    0:   CLP write feature to ram0           1:  CLP write feature to ram1
wire     [7:0]           feature_size;


reg     [7:0]           CLP_row_cnt;
reg     [11:0]          CLP_ctr_cnt;

reg                     CLP_enable;
reg                     CLP_enable_p;
reg                     CLP_data_ready;
wire                    CLP_state;
wire                    CLP_output_flag;
wire   [ Tm * FEATURE_WIDTH - 1 : 0 ]                     CLP_output;

always@(posedge clk)
    if(rst)
        CLP_ctr_cnt <= 0;
    else
        if(state == 0)
            CLP_ctr_cnt <= 0;
        else
            CLP_ctr_cnt <= CLP_ctr_cnt + 1;    
  
always@(posedge clk)
    if(rst)
        state <= 0;
    else
        if(enable == 1)
            state <= 1;
        else
            if(CLP_ctr_cnt == CLP_work_time)
                state <= 0;
            else
                state <= state;


        
always@(posedge clk)
    if(rst)
        CLP_enable_p <= 0;
    else 
        CLP_enable_p <= CLP_enable;
   
 
always@(posedge clk)
    if(rst)
        begin
            CLP_row_cnt <= 0;
        end 
    else
        if((CLP_enable_p == 0) && (CLP_enable == 1))
            CLP_row_cnt <= 0;    
        else 
            if(CLP_data_ready == 1)
                CLP_row_cnt <= CLP_row_cnt + 1; 
            else
                CLP_row_cnt <= CLP_row_cnt;
       
      
instruction_analysis instruction_analysis_0(
                      .clk(clk),
                      .rst(rst),
                      .instruction(instruction),
                      .state(state),
                      .CLP_type(CLP_type),
                      .current_kernel_size(current_kernel_size),
                      .CLP_work_time(CLP_work_time),
                      .scaler_mem_addr(scaler_mem_addr),
                      .weight_mem_init_addr(weight_mem_init_addr),
                      .feature_amount(),
                      .feature_in_select(feature_in_select),       //   0 :  CLP read feature from ram0          1:  CLP read feature from ram1
                      .feature_out_select(feature_out_select),     //    0:   CLP write feature to ram0           1:  CLP write feature to ram1
                      .feature_size(feature_size)
                    );     
 
 always@(posedge clk)
    if(rst)
        CLP_data_ready <= 0;
    else 
        if(current_kernel_size == 5)
            begin
                if(CLP_ctr_cnt == 7)
                    CLP_data_ready <= 1;
                else if(CLP_ctr_cnt == CLP_work_time)
                    CLP_data_ready <= 0;
            end
        else if(current_kernel_size == 3)
            begin
                if(CLP_ctr_cnt == 5)
                    CLP_data_ready <= 1;
                else if(CLP_ctr_cnt == CLP_work_time)
                    CLP_data_ready <= 0;
            end
        else  //current_kernel_size == 1
            begin
                if(CLP_ctr_cnt == 1)
                    CLP_data_ready <= 1;
                else if(CLP_data_ready == CLP_work_time)
                    CLP_data_ready <= 0;
            end

    
always@(posedge clk)
    if(rst)
        CLP_enable <= 0;
    else 
        begin
            if(current_kernel_size == 5)
                begin
                    if(CLP_ctr_cnt == 7)
                        CLP_enable <= 1;
                    else if(CLP_ctr_cnt >= CLP_work_time)
                        CLP_enable <= 0;
                    else        
                        if(CLP_row_cnt == feature_size - current_kernel_size - 1)     // if(CLP_row_cnt== 22) 
                            CLP_enable <= 0;
                        else if(CLP_row_cnt == feature_size-2)    //else if(CLP_row_cnt == 26)
                            CLP_enable <= 1;
                        else
                            CLP_enable <= CLP_enable; 
                end
            else if(current_kernel_size == 3)
                begin
                    if(CLP_ctr_cnt == 5)
                        CLP_enable <= 1;
                    else if(CLP_ctr_cnt >= CLP_work_time)
                        CLP_enable <= 0;
                    else        
                        if(CLP_row_cnt== 24) 
                            CLP_enable <= 0;
                        else if(CLP_row_cnt == 26)
                            CLP_enable <= 1; 
                end
            else //current_kernel_size == 1
                begin
                    if(CLP_ctr_cnt == 1)
                        CLP_enable <= 1;
                    else if(CLP_ctr_cnt >= CLP_work_time)
                        CLP_enable <= 0;
                    else 
                        CLP_enable <= CLP_enable;
                
                end
        end


    
wire  [ Tn * KERNEL_SIZE * KERNEL_SIZE * FEATURE_WIDTH - 1 : 0 ]                   feature_wire;    
wire  [ SCALER_WIDTH - 1:0  ]                                                      scaler_wire;
wire  [ Tn * Tm * KERNEL_SIZE * KERNEL_SIZE * KERNEL_WIDTH - 1 : 0 ]               weight_wire;

featrue_mem_ctr featrue_mem_ctr0(
           .clk(clk),
           .rst(rst),
           .current_kernel_size(current_kernel_size),
           .state(state),
           .feature_size(feature_size),
           .CLP_output_flag(CLP_output_flag),
           .CLP_output(CLP_output),
           
           .arm_write_feature_enable(arm_write_feature_enable),
           .arm_write_feature_addr(arm_write_feature_addr),
           .arm_write_feature_data(arm_write_feature_data),
           .arm_write_feature_select(arm_write_feature_select),
            
            
           .arm_read_feature_enable(arm_read_feature_enable),
           .arm_read_feature_addr(arm_read_feature_addr),
           .arm_read_feature_data(arm_read_feature_data),
           .arm_read_feature_select(arm_read_feature_select),
           
           .feature_in_select(feature_in_select),
           .feature_out_select(feature_out_select),
           .feature_wire(feature_wire)
    );
weight_mem_ctr weight_mem_ctr0(
        .clk(clk),
        .rst(rst),
        .state(state),
        .weight_mem_init_addr(weight_mem_init_addr),
        .weight_wire(weight_wire)
    );

scaler_ctr scaler_ctr0(
        .clk(clk),
        .rst(rst),
        .state(state),
        .scaler_mem_addr(scaler_mem_addr),
        .scaler_wire(scaler_wire)
        );

CLP CLP0( 
        .clk(clk),
        .fast_clk(fast_clk),
        .rst(rst),
        .feature_in(feature_wire),
        .weight_in(weight_wire),
        .weight_scaler(scaler_wire),
        .bias_in({Tm * BIAS_WIDTH{1'b0}}),
        .ctr(CLP_type),
        .addr_clear(CLP_data_ready),
        .enable(CLP_enable),
        .out_valid(CLP_output_flag),
        .feature_out(CLP_output)
    );

endmodule