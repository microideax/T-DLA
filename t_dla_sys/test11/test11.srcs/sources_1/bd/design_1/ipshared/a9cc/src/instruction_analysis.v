`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.09.2018 17:57:19
// Design Name: 
// Module Name: instruction_analysis
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


module instruction_analysis(
       input   wire                                         clk,
       input   wire                                         rst,
       input   wire  [63:0]                                 instruction,
       input   wire                                         state,
       output  reg   [3:0]                                  CLP_type,
       output  reg   [2:0]                                  current_kernel_size,
       output  reg   [15:0]                                 CLP_work_time,
       output  reg   [7:0]                                  scaler_mem_addr,
       output  reg   [15:0]                                 weight_mem_init_addr,
       output  reg   [10:0]                                 feature_amount,
       output  reg                                          feature_in_select,       //   0 :  CLP read feature from ram0          1:  CLP read feature from ram1
       output  reg                                          feature_out_select,     //    0:   CLP write feature to ram0           1:  CLP write feature to ram1
       output  reg   [7:0]                                  feature_size
           );
    
    
always@(posedge clk)
   if(rst)
       begin
           CLP_type                     <= 0;
           current_kernel_size          <= 0;
           CLP_work_time                <= 0;
           scaler_mem_addr              <= 0;
           weight_mem_init_addr         <= 0;
           feature_amount               <= 0;
           feature_in_select            <= 0;
           feature_out_select           <= 0;
           feature_size                 <= 0;
       end   
   else
       begin
           if(state == 1)
               begin
                   CLP_type                <= instruction[3:0];
                   current_kernel_size     <= instruction[6:4];
                   CLP_work_time           <= instruction[22:7];    
                   scaler_mem_addr         <= instruction[30:23];  
                   weight_mem_init_addr    <= instruction[46:31];   
                   feature_in_select       <= instruction[47];
                   feature_out_select      <= instruction[48];
                   feature_size            <= instruction[56:49];   
               end
           else
               begin
                   CLP_type                <= CLP_type;
                   current_kernel_size     <= current_kernel_size;
                   CLP_work_time           <= CLP_work_time;
                   scaler_mem_addr         <= scaler_mem_addr; 
                   weight_mem_init_addr    <= weight_mem_init_addr;
                   feature_amount          <= feature_amount;
                   feature_in_select       <= feature_in_select;
                   feature_out_select      <= feature_out_select;
                   feature_size            <= feature_size;
               end
       end  
endmodule
//

/*

                   CLP_type                <= instruction[3:0];
                   current_kernel_size     <= instruction[6:4];
                   CLP_work_time           <= instruction[17:7];    //
                   scaler_mem_addr         <= instruction[23:18];   //
                   weight_mem_init_addr    <= instruction[39:24];
                   feature_amount          <= instruction[50:40];
                   feature_in_select       <= instruction[51];
                   feature_out_select      <= instruction[52];
                   feature_size            <= instruction[58:53];*/