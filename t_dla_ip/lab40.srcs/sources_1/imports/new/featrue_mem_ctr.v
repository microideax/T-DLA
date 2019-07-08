`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/02/2018 02:27:25 PM
// Design Name: 
// Module Name: featrue_mem_ctr
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
//
//   feature_in_memory_gen         Port A : data_width   24        depth  8192       ---->      24KB
//                                 Port B : data_width   384       depth  512
//                                 data_width of PortB = feature_width * Tn * FEATURE_IN_MEM_READ_WIDTH_COF    (Tn = 2  ,  4       FEATURE_IN_MEM_READ_WIDTH_COF = 8  )
// 
//   feature_out_memory_gen        Port A : data_width   96        depth  2048       ---->      24KB
//                                 Port B : data_width   24        depth  8192
//
//
//////////////////////////////////////////////////////////////////////////////////
`include "network_para.vh"

module featrue_mem_ctr#(
    parameter Tn = `Tn,
    parameter Tm = `Tm,
    parameter FEATURE_WIDTH = `FEATURE_WIDTH,
    parameter KERNEL_SIZE = `KERNEL_SIZE,
    parameter FEATURE_IN_MEM_READ_WIDTH_COF = `FEATURE_IN_MEM_READ_WIDTH_COF
)(
    input wire                                                                    clk,
    input wire                                                                    rst,
    input wire   [2:0]                                                            current_kernel_size,
    input wire                                                                    state,
    input wire   [7:0]                                                            feature_size,
    input wire                                                                    CLP_output_flag,
    input wire   [Tm * FEATURE_WIDTH - 1 : 0]                                     CLP_output,
    
    input wire                                                                    arm_write_feature_enable,
    input wire   [14:0]                                                           arm_write_feature_addr,
    input wire   [FEATURE_WIDTH*2 - 1 : 0]                                        arm_write_feature_data,
    input wire                                                                    arm_write_feature_select,
    
    
     
    input wire                                                                    arm_read_feature_enable,
    input wire   [15:0]                                                           arm_read_feature_addr,
    output wire  [FEATURE_WIDTH*2 - 1 : 0]                                        arm_read_feature_data,
    input wire                                                                    arm_read_feature_select,
    
    
    input wire                                                                    feature_in_select,
    input wire                                                                    feature_out_select,
    output wire  [Tn * KERNEL_SIZE * KERNEL_SIZE * FEATURE_WIDTH - 1 : 0]         feature_wire
    );
    
genvar i,j,k,x,y,z;


//signals for CLP write feature

reg                                             feature_mem_write_enable;
reg                                             feature_mem_write_enable_p;
reg     [12:0]                                  feature_mem_write_addr;
reg     [12:0]                                  feature_mem_write_addr_n;
reg     [Tm * FEATURE_WIDTH - 1:0]              feature_mem_write_data;

wire                                            feature_mem_write_enable_0;
wire    [12:0]                                  feature_mem_write_addr_0;
wire    [Tm * FEATURE_WIDTH - 1:0]              feature_mem_write_data_0;                          

wire                                            feature_mem_write_enable_1;
wire    [12:0]                                  feature_mem_write_addr_1;
wire    [Tm * FEATURE_WIDTH - 1:0]              feature_mem_write_data_1;

assign  feature_mem_write_enable_0 = (feature_out_select == 0) ? feature_mem_write_enable  : 0;
assign  feature_mem_write_enable_1 = (feature_out_select == 0) ? 0                         : feature_mem_write_enable;

assign  feature_mem_write_addr_0   = (feature_out_select == 0) ? feature_mem_write_addr    : 0;
assign  feature_mem_write_addr_1   = (feature_out_select == 0) ? 0                         : feature_mem_write_addr;

assign  feature_mem_write_data_0   = (feature_out_select == 0) ? feature_mem_write_data    : 0;
assign  feature_mem_write_data_1   = (feature_out_select == 0) ? 0                         : feature_mem_write_data;

//signals for ARM wirte feature

wire                                                                    arm_write_feature_enable_0;
wire   [14:0]                                                           arm_write_feature_addr_0;
wire   [FEATURE_WIDTH*2 - 1 : 0]                                        arm_write_feature_data_0;
wire                                                                    arm_write_feature_enable_1;
wire   [14:0]                                                           arm_write_feature_addr_1;
wire   [FEATURE_WIDTH*2 - 1 : 0]                                        arm_write_feature_data_1;

assign arm_write_feature_enable_0 = (arm_write_feature_select == 0) ? arm_write_feature_enable  : 0;
assign arm_write_feature_enable_1 = (arm_write_feature_select == 0) ? 0                         : arm_write_feature_enable;

assign arm_write_feature_addr_0   = (arm_write_feature_select == 0) ? arm_write_feature_addr    : 0;
assign arm_write_feature_addr_1   = (arm_write_feature_select == 0) ? 0                         : arm_write_feature_addr;

assign arm_write_feature_data_0   = (arm_write_feature_select == 0) ? arm_write_feature_data    : 0;
assign arm_write_feature_data_1   = (arm_write_feature_select == 0) ? 0                         : arm_write_feature_data;
 



//signals for CLP read feature 

reg                                                                                 feature_mem_read_enable;
reg                                                                                 feature_mem_read_enable_p;
reg     [5:0]                                                                       feature_mem_read_cnt2;

reg     [10:0]                                                                       feature_mem_read_addr;
wire    [Tn * FEATURE_WIDTH * FEATURE_IN_MEM_READ_WIDTH_COF - 1 :0]                 feature_mem_read_data;
wire    [10:0]                                                                       feature_mem_read_addr_0;
wire    [Tn * FEATURE_WIDTH * FEATURE_IN_MEM_READ_WIDTH_COF - 1 :0]                 feature_mem_read_data_0;
wire    [10:0]                                                                       feature_mem_read_addr_1;
wire    [Tn * FEATURE_WIDTH * FEATURE_IN_MEM_READ_WIDTH_COF - 1 :0]                 feature_mem_read_data_1;
wire                                                                                feature_mem_read_enable_0;
wire                                                                                feature_mem_read_enable_1;


reg     [Tn * FEATURE_WIDTH * FEATURE_IN_MEM_READ_WIDTH_COF - 1 :0]                 feature_mem_read_data_tmp;
reg                                                                                 line_buffer_enable;


assign  feature_mem_read_addr_0     = (feature_in_select==0)? feature_mem_read_addr   : 0;
assign  feature_mem_read_addr_1     = (feature_in_select==0)? 0                       : feature_mem_read_addr;
assign  feature_mem_read_enable_0   = (feature_in_select==0)? feature_mem_read_enable : 0;
assign  feature_mem_read_enable_1   = (feature_in_select==0)? 0                       : feature_mem_read_enable;
assign  feature_mem_read_data       = (feature_in_select==0)? feature_mem_read_data_0 : feature_mem_read_data_1 ;


//singals for ARM read feature
    
wire                                                                    arm_read_feature_enable_0;
wire   [15:0]                                                           arm_read_feature_addr_0;
wire   [FEATURE_WIDTH*2 - 1 : 0]                                        arm_read_feature_data_0;

wire                                                                    arm_read_feature_enable_1;
wire   [15:0]                                                           arm_read_feature_addr_1;
wire   [FEATURE_WIDTH*2 - 1 : 0]                                        arm_read_feature_data_1;


assign  arm_read_feature_enable_0   = (arm_read_feature_select == 0) ? arm_read_feature_enable   : 0;
assign  arm_read_feature_enable_1   = (arm_read_feature_select == 0) ? 0                         : arm_read_feature_enable;

assign  arm_read_feature_addr_0     = (arm_read_feature_select == 0) ? arm_read_feature_addr     : 0;
assign  arm_read_feature_addr_1     = (arm_read_feature_select == 0) ? 0                         : arm_read_feature_addr;

assign  arm_read_feature_data       = (arm_read_feature_select == 0) ? arm_read_feature_data_0   : arm_read_feature_data_1;



always@(posedge clk)
    if(rst)
        feature_mem_read_enable <= 0;
    else 
        if(state == 0)
            feature_mem_read_enable <= 0;
        else
            feature_mem_read_enable <= 1;
            
always@(posedge clk)
    if(rst)
        feature_mem_read_enable_p <= 0;
    else
        feature_mem_read_enable_p <= feature_mem_read_enable;     
 
always@(posedge clk)
    if(rst)
        begin
            feature_mem_read_addr <= 0;
            feature_mem_read_cnt2 <= 0;
        end          
    else
        if(state == 0)
            feature_mem_read_cnt2 <= 0;
        else
            if((feature_mem_read_enable_p == 0)&&(feature_mem_read_enable == 1))
                feature_mem_read_addr <= 0;
            else if(feature_mem_read_enable_p == 1)
                begin
                    if(current_kernel_size != 1)
                        if(feature_mem_read_addr <= (feature_size-2))   //!!!!!!!!   30
                            feature_mem_read_addr <= feature_mem_read_addr + 1;
                        else
                            begin
                                if(feature_mem_read_cnt2 == 0)
                                    begin
                                        feature_mem_read_addr <= feature_mem_read_addr + 1;
                                        feature_mem_read_cnt2 <= 1;
                                    end  
                                else if(feature_mem_read_cnt2 == 7)
                                    begin
                                        feature_mem_read_addr <= feature_mem_read_addr + 1;
                                        feature_mem_read_cnt2 <= 8;
                                    end
                                else if(feature_mem_read_cnt2 == 8)
                                    feature_mem_read_cnt2 <= 1;    
                                else
                                    begin
                                        feature_mem_read_cnt2 <= feature_mem_read_cnt2 + 1;
                                    end
                            end
                    else   //kernel_size = 1 
                        begin
                            if(feature_mem_read_cnt2 == 7)
                                begin
                                    feature_mem_read_cnt2 <= 0;   
                                end
                            else if(feature_mem_read_cnt2 == 6)
                                begin
                                    feature_mem_read_addr <= feature_mem_read_addr + 1;
                                    feature_mem_read_cnt2 <= feature_mem_read_cnt2 + 1;  
                                end    
                            else
                                feature_mem_read_cnt2 <= feature_mem_read_cnt2 + 1; 
                        end                       
                end
 
 
always@(posedge clk)
    if(rst)
        feature_mem_read_data_tmp <= 0;
    else 
        if ((current_kernel_size != 1) && (feature_mem_read_cnt2 == 2))
            feature_mem_read_data_tmp <= feature_mem_read_data >> (FEATURE_WIDTH*Tn);
        else if ((current_kernel_size == 1) && (feature_mem_read_cnt2 == 0))
            feature_mem_read_data_tmp <= feature_mem_read_data >> (FEATURE_WIDTH*Tn); 
        else
            feature_mem_read_data_tmp <= feature_mem_read_data_tmp >> (FEATURE_WIDTH*Tn);
 
always@(posedge clk)
    if(rst)
        line_buffer_enable <= 0;
    else
        if(state == 0)
            line_buffer_enable <= 0;
        else
            if((feature_mem_read_enable_p == 0)&&(feature_mem_read_enable == 1))
                line_buffer_enable <= 1;
            else
                line_buffer_enable <= line_buffer_enable;
 
feature_in_mem_gen feature_in_memory_0 (
              .clka(clk),                           // input wire clka
              .ena(arm_write_feature_enable_0),       // input wire ena
              .wea(1'b1),                              // input wire [0 : 0] wea
              .addra(arm_write_feature_addr_0),       // input wire [12 : 0] addra
              .dina(arm_write_feature_data_0),        // input wire [23 : 0] dina
              .clkb(clk),                           // input wire clkb
              .enb(feature_mem_read_enable_0),        // input wire enb
              .addrb(feature_mem_read_addr_0),        // input wire [8 : 0] addrb
              .doutb(feature_mem_read_data_0)         // output wire [383 : 0] doutb
            );



feature_in_mem_gen feature_in_memory_1 (
              .clka(clk),                             // input wire clka
              .ena(arm_write_feature_enable_1),       // input wire ena
              .wea(1'b1),                             // input wire [0 : 0] wea
              .addra(arm_write_feature_addr_1),       // input wire [12 : 0] addra
              .dina(arm_write_feature_data_1),        // input wire [23 : 0] dina
              .clkb(clk),                             // input wire clkb
              .enb(feature_mem_read_enable_1),        // input wire enb
              .addrb(feature_mem_read_addr_1),        // input wire [8 : 0] addrb
              .doutb(feature_mem_read_data_1)         // output wire [383 : 0] doutb
            );


           
feature_out_mem_gen feature_out_memory_0 (
             .clka(clk),                            // input wire clka
             .ena(feature_mem_write_enable_0),        // input wire ena
             .wea(1'b1),                               // input wire [0 : 0] wea
             .addra(feature_mem_write_addr_0),        // input wire [9 : 0] addra
             .dina(feature_mem_write_data_0),         // input wire [95 : 0] dina
             .clkb(clk),                            // input wire clkb
             .enb(arm_read_feature_enable_0),         // input wire enb
             .addrb(arm_read_feature_addr_0),         // input wire [11 : 0] addrb
             .doutb(arm_read_feature_data_0)          // output wire [23 : 0] doutb
           );
 
 
feature_out_mem_gen feature_out_memory_1 (
             .clka(clk),                            // input wire clka
             .ena(feature_mem_write_enable_1),        // input wire ena
             .wea(1'b1),                               // input wire [0 : 0] wea
             .addra(feature_mem_write_addr_1),        // input wire [9 : 0] addra
             .dina(feature_mem_write_data_1),         // input wire [95 : 0] dina
             .clkb(clk),                            // input wire clkb
             .enb(arm_read_feature_enable_1),         // input wire enb
             .addrb(arm_read_feature_addr_1),         // input wire [11 : 0] addrb
             .doutb(arm_read_feature_data_1)          // output wire [23 : 0] doutb
           );

 
 
reg  [ FEATURE_WIDTH - 1 : 0 ]                                          feature_in_buf[Tn * KERNEL_SIZE * KERNEL_SIZE - 1 : 0];
wire [ Tn * FEATURE_WIDTH * KERNEL_SIZE - 1 : 0 ]                       feature_transfer_wire;
wire [ FEATURE_WIDTH * KERNEL_SIZE - 1 : 0 ]                            line_buffer_in[Tn - 1 : 0];   
wire [ Tn * FEATURE_WIDTH * KERNEL_SIZE - 1 : 0 ]                       line_buffer_out;   
reg                                                                     read_mem_mode;
wire [ Tn * FEATURE_WIDTH * KERNEL_SIZE * KERNEL_SIZE - 1 : 0 ]         feature_transfer_wire_for_1X1;

always@(posedge clk)
    if(rst)
        read_mem_mode <= 1'd0;
    else
        if(feature_mem_read_addr < feature_size)    //!!!!!!!
            read_mem_mode <= 1'd0;
        else
            read_mem_mode <= 1'd1;
 
assign feature_transfer_wire = (read_mem_mode == 0) ? feature_mem_read_data[ Tn * FEATURE_WIDTH * KERNEL_SIZE - 1 : 0 ]: line_buffer_out;

generate
    for(i = 0 ; i < Tn ; i = i + 1) begin:line_buffer_in_i
        assign line_buffer_in[i] = (read_mem_mode == 0) ? feature_transfer_wire[(i+1) * KERNEL_SIZE * FEATURE_WIDTH - 1 : i * KERNEL_SIZE * FEATURE_WIDTH] : ((feature_mem_read_cnt2 == 2) ?  
                {{FEATURE_WIDTH*4{1'd0}},feature_mem_read_data[i*FEATURE_WIDTH + FEATURE_WIDTH - 1 : i*FEATURE_WIDTH]}:
                {{FEATURE_WIDTH*4{1'd0}},feature_mem_read_data_tmp[i*FEATURE_WIDTH + FEATURE_WIDTH - 1 : i*FEATURE_WIDTH]});
    end
endgenerate

           
generate
for(i = 0 ; i < Tn; i = i+1) begin:line_buffer_i
    line_buffer line_buffer0(
                    .clk(clk),
                    .enable(line_buffer_enable),
                    .line_buffer_mod(read_mem_mode),   
                    .current_kernel_size(current_kernel_size),
                    .shift_ram_depth(feature_size),//shift_ram_depth(5'd31),
                    .data_in(line_buffer_in[i]),
                    .data_out(line_buffer_out[(i+1) * FEATURE_WIDTH * KERNEL_SIZE - 1 : i * FEATURE_WIDTH * KERNEL_SIZE])
                    );
end
endgenerate


generate
for(i = 0 ; i < Tn; i = i + 1) begin:feature_in_buf_i
    for(j = 0 ; j < KERNEL_SIZE; j = j + 1) begin:feature_in_buf_j
        always@(posedge clk)
            if(rst)
            ;
//                begin
//                    feature_in_buf[i * KERNEL_SIZE * KERNEL_SIZE  + j * KERNEL_SIZE ]       <= 0;    
//                    feature_in_buf[i * KERNEL_SIZE * KERNEL_SIZE  + j * KERNEL_SIZE + 1]    <= 0;   
//                    feature_in_buf[i * KERNEL_SIZE * KERNEL_SIZE  + j * KERNEL_SIZE + 2]    <= 0;  
//                    feature_in_buf[i * KERNEL_SIZE * KERNEL_SIZE  + j * KERNEL_SIZE + 3]    <= 0; 
//                    feature_in_buf[i * KERNEL_SIZE * KERNEL_SIZE  + j * KERNEL_SIZE + 4]    <= 0;
//                end
            else
                begin
                    if(current_kernel_size == 5)
                        begin
                            feature_in_buf[i * KERNEL_SIZE * KERNEL_SIZE  + j * KERNEL_SIZE ]       <= feature_in_buf[i * KERNEL_SIZE * KERNEL_SIZE  + j * KERNEL_SIZE + 1];    
                            feature_in_buf[i * KERNEL_SIZE * KERNEL_SIZE  + j * KERNEL_SIZE + 1]    <= feature_in_buf[i * KERNEL_SIZE * KERNEL_SIZE  + j * KERNEL_SIZE + 2];
                            feature_in_buf[i * KERNEL_SIZE * KERNEL_SIZE  + j * KERNEL_SIZE + 2]    <= feature_in_buf[i * KERNEL_SIZE * KERNEL_SIZE  + j * KERNEL_SIZE + 3];
                            feature_in_buf[i * KERNEL_SIZE * KERNEL_SIZE  + j * KERNEL_SIZE + 3]    <= feature_in_buf[i * KERNEL_SIZE * KERNEL_SIZE  + j * KERNEL_SIZE + 4];  
                            feature_in_buf[i * KERNEL_SIZE * KERNEL_SIZE  + j * KERNEL_SIZE + 4]    <= feature_transfer_wire[i * KERNEL_SIZE * FEATURE_WIDTH + j * FEATURE_WIDTH + FEATURE_WIDTH - 1 : i * KERNEL_SIZE * FEATURE_WIDTH + j * FEATURE_WIDTH];
                        end
                    else if(current_kernel_size == 3)
                        begin
                            feature_in_buf[i * KERNEL_SIZE * KERNEL_SIZE  + j * KERNEL_SIZE ]       <= feature_in_buf[i * KERNEL_SIZE * KERNEL_SIZE  + j * KERNEL_SIZE + 1];    
                            feature_in_buf[i * KERNEL_SIZE * KERNEL_SIZE  + j * KERNEL_SIZE + 1]    <= feature_in_buf[i * KERNEL_SIZE * KERNEL_SIZE  + j * KERNEL_SIZE + 2];
                            feature_in_buf[i * KERNEL_SIZE * KERNEL_SIZE  + j * KERNEL_SIZE + 2]    <= feature_transfer_wire[i * KERNEL_SIZE * FEATURE_WIDTH + j * FEATURE_WIDTH + FEATURE_WIDTH - 1 : i * KERNEL_SIZE * FEATURE_WIDTH + j * FEATURE_WIDTH];
                            feature_in_buf[i * KERNEL_SIZE * KERNEL_SIZE  + j * KERNEL_SIZE + 3]    <= 0; 
                            feature_in_buf[i * KERNEL_SIZE * KERNEL_SIZE  + j * KERNEL_SIZE + 4]    <= 0;
                        end
                end
    end
end
endgenerate


generate
    for(i = 0;i < Tn; i = i + 1)  begin:feature_transfer_wire_for_1X1_i
        for(j = 1 ; j < KERNEL_SIZE;j = j + 1) begin:feature_transfer_wire_for_1X1_j
            for(k = 0 ; k < KERNEL_SIZE; k = k + 1) begin:feature_transfer_wire_for_1X1_k
                assign feature_transfer_wire_for_1X1[i * KERNEL_SIZE * KERNEL_SIZE * FEATURE_WIDTH + j * KERNEL_SIZE * FEATURE_WIDTH + k * FEATURE_WIDTH + FEATURE_WIDTH - 1 : 
                                                     i * KERNEL_SIZE * KERNEL_SIZE * FEATURE_WIDTH + j * KERNEL_SIZE * FEATURE_WIDTH + k * FEATURE_WIDTH ] = {FEATURE_WIDTH{1'd0}};
            end
        end
        for(x = 1; x < KERNEL_SIZE; x = x + 1) begin:feature_transfer_wire_for_1X1_x
            assign feature_transfer_wire_for_1X1[i * KERNEL_SIZE * KERNEL_SIZE * FEATURE_WIDTH + x * FEATURE_WIDTH + FEATURE_WIDTH - 1 : 
                                                 i * KERNEL_SIZE * KERNEL_SIZE * FEATURE_WIDTH + x * FEATURE_WIDTH ] =  {FEATURE_WIDTH{1'd0}};
        end
        assign feature_transfer_wire_for_1X1[i * KERNEL_SIZE * KERNEL_SIZE * FEATURE_WIDTH + FEATURE_WIDTH - 1 :  i * KERNEL_SIZE * KERNEL_SIZE * FEATURE_WIDTH ] 
           = (feature_mem_read_cnt2 == 0) ? feature_mem_read_data[i * FEATURE_WIDTH + FEATURE_WIDTH - 1 : i * FEATURE_WIDTH]:feature_mem_read_data_tmp[i * FEATURE_WIDTH + FEATURE_WIDTH - 1 : i * FEATURE_WIDTH];       
    end
endgenerate




generate
for(i = 0 ; i <Tn ; i = i + 1) begin:feature_wire_i
    for(j = 0 ; j < KERNEL_SIZE; j = j + 1) begin:feature_wire_j
        for(k = 0 ; k < KERNEL_SIZE; k = k + 1) begin:feature_wire_k
            assign feature_wire[i * KERNEL_SIZE * KERNEL_SIZE * FEATURE_WIDTH + j * KERNEL_SIZE * FEATURE_WIDTH + k * FEATURE_WIDTH + FEATURE_WIDTH - 1 : 
                                i * KERNEL_SIZE * KERNEL_SIZE * FEATURE_WIDTH + j * KERNEL_SIZE * FEATURE_WIDTH + k * FEATURE_WIDTH]
                    = (current_kernel_size == 1) ? feature_transfer_wire_for_1X1[i * KERNEL_SIZE * KERNEL_SIZE * FEATURE_WIDTH + j * KERNEL_SIZE * FEATURE_WIDTH + k * FEATURE_WIDTH + FEATURE_WIDTH - 1 : 
                                                                                 i * KERNEL_SIZE * KERNEL_SIZE * FEATURE_WIDTH + j * KERNEL_SIZE * FEATURE_WIDTH + k * FEATURE_WIDTH]
                                                  :feature_in_buf[i * KERNEL_SIZE * KERNEL_SIZE + j * KERNEL_SIZE + k];
        end
    end
end
endgenerate


always@(posedge clk)
    if(rst)
        feature_mem_write_enable <= 0;
    else 
        if(state == 0)
            feature_mem_write_enable <= 0;
        else
            feature_mem_write_enable <= 1;
 
always@(posedge clk)
    if(rst)
        feature_mem_write_enable_p <= 0;
    else
        feature_mem_write_enable_p <= feature_mem_write_enable;             

always@(posedge clk)
    if(rst)
        begin
            feature_mem_write_addr_n <= 0;
            feature_mem_write_addr <= 0;
            feature_mem_write_data <= 0;
        end
    else 
        if(state == 0)
            begin
                feature_mem_write_addr_n <= 0;
                feature_mem_write_addr <= 0;
            end
        else    
            if((feature_mem_write_enable_p == 0) && (feature_mem_write_enable == 1))
                feature_mem_write_addr_n <= 0;
            else
                if(CLP_output_flag == 1)
                    begin
                        feature_mem_write_addr_n <= feature_mem_write_addr_n + 1;
                        feature_mem_write_data <= CLP_output;
                        feature_mem_write_addr<=feature_mem_write_addr_n;
                    end
                else
                    begin
                        feature_mem_write_addr_n <= feature_mem_write_addr_n;
                        feature_mem_write_data <= feature_mem_write_data;
                        feature_mem_write_addr <= feature_mem_write_addr;
                    end      
endmodule