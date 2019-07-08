`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.11.2018 15:15:23
// Design Name: 
// Module Name: add_unit
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
module afifo(
    input                       write_clk,
    input                       read_clk,
    input                       rst,
    input [399:0]               data_in,
    input                       write_enable,
    output reg [199:0]          data_out,    
    output reg                  data_out_validate
    );

reg             read_enable;
wire            empty;
wire            full;
wire[399:0]      data_wire;


fifo_generator_0 fifo0 (
  .rst(rst),                            // input wire rst
  .wr_clk(write_clk),                   // input wire wr_clk
  .rd_clk(read_clk),                    // input wire rd_clk
  .din(data_in),                        // input wire [399 : 0] din
  .wr_en(write_enable),                 // input wire wr_en
  .rd_en(read_enable),                  // input wire rd_en
  .dout(data_wire),                     // output wire [399 : 0] dout
  .full(full),                          // output wire full
  .empty(empty)                         // output wire empty
);

reg [2:0] state;

always@(posedge read_clk)
    if(rst)
        begin
            read_enable <= 0;
            state <= 0;
            data_out <= 0;
            data_out_validate <= 0;
        end
    else
        case(state)
            0:begin
                data_out_validate <= 0;
                data_out <= 0;
                if(empty == 0)
                    state <= 1;
                else
                    state <= 0;
            end
            1:begin
                read_enable <= 1;
                state <= 2;      
            end
            2:begin
                read_enable <= 0;
                state <= 3;
            end
            3:begin
                read_enable <= 1;
                data_out <= data_wire[199:0];
                data_out_validate <= 1;
                if(empty == 1)
                    state <= 5;
                else
                    state <= 4;
            end
            4:begin
                read_enable <= 0;
                state <= 3;
                data_out <= data_wire[399:200];
            end
            5:begin
                read_enable <= 0;
                data_out <= data_wire[399:200];
                state <= 0;
            end    
        endcase
endmodule