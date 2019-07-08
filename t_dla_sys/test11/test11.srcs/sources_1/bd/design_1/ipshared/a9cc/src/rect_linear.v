`include "network_para.vh"
module rect_linear#(
    parameter FEATURE_WIDTH = `FEATURE_WIDTH
)(
    input wire                                       clk,
    input wire                                       rst,
    input wire  [FEATURE_WIDTH - 1:0]                function_in,
    output reg  [FEATURE_WIDTH - 1 :0]               function_out
    );
always @(posedge clk)
    begin
        if(rst)
            function_out <= 0;
        else if(function_in[FEATURE_WIDTH - 1] == 1'b1)
            function_out <= 0;
        else 
            function_out <=  function_in;
    end
endmodule