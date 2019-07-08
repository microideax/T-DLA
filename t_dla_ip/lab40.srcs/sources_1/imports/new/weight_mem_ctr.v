`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/02/2018 12:12:24 PM
// Design Name: 
// Module Name: weight_mem_ctr
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
//              port A       data_width   50                depth   1024     ------->6.25KB
// 
//              port B       data_width   400               depth   128
//                    data_width of portB = Tn * K^2 * kernel_width * WEIGHT_MEM_READ_WIDTH_COF      Tn = (2,4)     kernel_width = 2    K = 5      WEIGHT_MEM_READ_WIDTH_COF = 2
//
//////////////////////////////////////////////////////////////////////////////////

`include "network_para.vh"
module weight_mem_ctr#(
    parameter Tn = `Tn,
    parameter Tm = `Tm,
    parameter KERNEL_SIZE = `KERNEL_SIZE,
    parameter KERNEL_WIDTH = `KERNEL_WIDTH,
    parameter WEIGHT_MEM_READ_WIDTH_COF = `WEIGHT_MEM_READ_WIDTH_COF
)(
    input wire                                                                      clk,
    input wire                                                                      rst,
    input wire                                                                      state,
    input wire  [15:0]                                                              weight_mem_init_addr,
    output wire [ Tn * Tm * KERNEL_SIZE * KERNEL_SIZE * KERNEL_WIDTH - 1 : 0 ]      weight_wire
    );

genvar i,j,k,x,y,z;
reg     [11:0]                                                                                              weight_mem_addr;
wire    [KERNEL_SIZE * KERNEL_SIZE * KERNEL_WIDTH * Tn * WEIGHT_MEM_READ_WIDTH_COF - 1 : 0 ]                weight_mem_dout;

reg                                                                                                         weight_mem_read_enable;
reg                                                                                                         weight_mem_read_enable_p;
reg                                                                                                         weight_mem_read_enable_p2;

reg     [KERNEL_SIZE * KERNEL_SIZE * KERNEL_WIDTH * Tn * WEIGHT_MEM_READ_WIDTH_COF - 1 : 0 ]                weight_in_buf[Tm / WEIGHT_MEM_READ_WIDTH_COF - 1 : 0];
reg     [8:0]                                                                                               weight_mem_read_cnt; 
reg                                                                                                         weight_wire_ready;
reg     [3:0]                                                                                               weight_mem_ctr_cnt;

always@(posedge clk)
    if(rst)
        weight_mem_read_enable <= 0;
    else
        if(state == 0)
            weight_mem_read_enable <= 0;
        else
            if(weight_wire_ready == 0)
                weight_mem_read_enable <= 1;
            else 
                weight_mem_read_enable <= 0;


always@(posedge clk)
    if(rst)
        begin
            weight_mem_read_enable_p <= 0;
            weight_mem_read_enable_p2 <= 0;
        end
    else
        begin
            weight_mem_read_enable_p <= weight_mem_read_enable;
            weight_mem_read_enable_p2 <= weight_mem_read_enable_p;
        end

always@(posedge clk)
    if(rst)
        begin
            weight_mem_addr <= 0;
        end
    else
        begin
            if((weight_mem_read_enable_p == 0) && (weight_mem_read_enable == 1))
                begin
                    weight_mem_addr <= weight_mem_init_addr[11:0];
                end
            else if(weight_mem_read_enable == 1)
                begin
                    weight_mem_addr <= weight_mem_addr + 1;
                end
        end

always@(posedge clk)
    if(rst)
         weight_mem_read_cnt <= 0;    
    else
        begin
            if(state == 0)
                weight_mem_read_cnt <= 0;
            else
                if((weight_mem_read_enable_p2 == 0) && (weight_mem_read_enable_p == 1))
                    begin
                        weight_mem_read_cnt <= 0;
                    end
                else if(weight_mem_read_enable_p2 == 1)
                    begin
                        weight_mem_read_cnt <= weight_mem_read_cnt + 1;
                    end
        end




//always@(posedge clk)
//    if(weight_mem_read_enable_p2 == 1)
//        begin
//            weight_in_buf[weight_mem_read_cnt] <= weight_mem_dout;
//        end
//    else
//        weight_in_buf[weight_mem_read_cnt] <= weight_in_buf[weight_mem_read_cnt];


always@(posedge clk)
    if(weight_mem_read_enable_p == 1)
        begin
        
            weight_in_buf[0] <= weight_in_buf[1];
            weight_in_buf[1] <= weight_in_buf[2];
            weight_in_buf[2] <= weight_in_buf[3];
            weight_in_buf[3] <= weight_in_buf[4];
            weight_in_buf[4] <= weight_in_buf[5];
            weight_in_buf[5] <= weight_in_buf[6];
            weight_in_buf[6] <= weight_in_buf[7];
            weight_in_buf[7] <= weight_mem_dout;
        end
    else
        begin
             weight_in_buf[0] <= weight_in_buf[0];
             weight_in_buf[1] <= weight_in_buf[1];
             weight_in_buf[2] <= weight_in_buf[2];
             weight_in_buf[3] <= weight_in_buf[3];
             weight_in_buf[4] <= weight_in_buf[4];
             weight_in_buf[5] <= weight_in_buf[5];
             weight_in_buf[6] <= weight_in_buf[6];
             weight_in_buf[7] <= weight_in_buf[7];
        end

always@(posedge clk)
    if(rst)
        begin
            weight_wire_ready <= 0;
        end
    else 
        begin
            if(state == 0)
                weight_wire_ready <= 0;
            else
                if(weight_mem_ctr_cnt >= (Tm / WEIGHT_MEM_READ_WIDTH_COF - 1))
                    weight_wire_ready <= 1;
                else
                    weight_wire_ready <= 0;
        end

always@(posedge clk)
    if(rst)
        weight_mem_ctr_cnt <= 0;
    else
        if(weight_mem_read_enable == 1)
            weight_mem_ctr_cnt <= weight_mem_ctr_cnt + 1;
        else
            if(state == 0)
                weight_mem_ctr_cnt <= 0;
            else
                weight_mem_ctr_cnt <= weight_mem_ctr_cnt;


weight_ram_gen weight_ram (
  .clka(clk),                               // input wire clka
  .ena(1'b0),                               // input wire ena
  .wea(1'b1),                               // input wire [0 : 0] wea
  .addra(10'd0),                            // input wire [9 : 0] addra
  .dina(50'd0),                             // input wire [49 : 0] dina
  .clkb(clk),                               // input wire clkb
  .enb(weight_mem_read_enable_p),           // input wire enb
  .addrb(weight_mem_addr),                  // input wire [6 : 0] addrb
  .doutb(weight_mem_dout)                   // output wire [399 : 0] doutb
);

generate
    for(i = 0 ; i < Tm / WEIGHT_MEM_READ_WIDTH_COF; i = i + 1)  begin:weight_wire_i
        for(j = 0 ; j < Tn * WEIGHT_MEM_READ_WIDTH_COF ; j = j + 1)  begin:weight_wire_j
            for(k = 0 ; k < KERNEL_SIZE * KERNEL_SIZE ; k = k + 1) begin:weight_wire_k
                assign weight_wire[i * Tn * WEIGHT_MEM_READ_WIDTH_COF * KERNEL_SIZE * KERNEL_SIZE * KERNEL_WIDTH + j * KERNEL_SIZE * KERNEL_SIZE * KERNEL_WIDTH + k * KERNEL_WIDTH + KERNEL_WIDTH - 1 :
                                   i * Tn * WEIGHT_MEM_READ_WIDTH_COF * KERNEL_SIZE * KERNEL_SIZE * KERNEL_WIDTH + j * KERNEL_SIZE * KERNEL_SIZE * KERNEL_WIDTH + k * KERNEL_WIDTH]
                     = weight_in_buf[i][ j * KERNEL_SIZE * KERNEL_SIZE * KERNEL_WIDTH + (KERNEL_SIZE * KERNEL_SIZE - 1 - k) * KERNEL_WIDTH + KERNEL_WIDTH - 1:
                                         j * KERNEL_SIZE * KERNEL_SIZE * KERNEL_WIDTH + (KERNEL_SIZE * KERNEL_SIZE - 1 - k) * KERNEL_WIDTH ];
            end
        end
    end
endgenerate
endmodule