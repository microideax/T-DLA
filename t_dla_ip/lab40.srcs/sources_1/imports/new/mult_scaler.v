`include "network_para.vh"
module mult_scaler#(
    parameter FEATURE_WIDTH = `FEATURE_WIDTH,
    parameter SCALER_WIDTH = `SCALER_WIDTH
)(
    input wire                                      clk,
    input wire                                      rst,
    input wire signed [ FEATURE_WIDTH - 1 : 0 ]     in1,
    input wire signed [ FEATURE_WIDTH - 1 : 0 ]     in2,
    output reg signed [ FEATURE_WIDTH - 1 : 0 ]    out
  );
reg    signed [ FEATURE_WIDTH + SCALER_WIDTH  - 1 :0]   temp_out;

always@(posedge clk)
    if(rst)
        temp_out<= 0;
    else
        temp_out <= in1 * in2;


always@(posedge clk)
    if(rst)
        out <= 0;
    else
        out <= (temp_out>>>10);
//assign out = temp_out>>>10;
//assign out[`MULT_SCALER_OUT_WIDTH - 1 : 0 ] = temp_out[`ADD_OUT_WIDTH + `SCALER_WIDTH  - 1: `ADD_OUT_WIDTH + `SCALER_WIDTH - `MULT_SCALER_OUT_WIDTH ];
endmodule