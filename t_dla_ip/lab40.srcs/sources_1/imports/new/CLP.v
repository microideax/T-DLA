`include "network_para.vh"

module CLP#(
    parameter Tn = `Tn,
    parameter Tm = `Tm,

    parameter KERNEL_SIZE = `KERNEL_SIZE,
    parameter KERNEL_WIDTH = `KERNEL_WIDTH,

    parameter SCALER_WIDTH = `SCALER_WIDTH,

    parameter FEATURE_WIDTH = `FEATURE_WIDTH,
    
    parameter BIAS_WIDTH = `BIAS_WIDTH,
    parameter COMPARE_TREE_CELL = 7    
)( 
    input   wire                                                                    clk,
    input   wire                                                                    fast_clk,
    input   wire                                                                    rst,
    input   wire  [ Tn * KERNEL_SIZE * KERNEL_SIZE * FEATURE_WIDTH - 1 : 0 ]        feature_in,
    input   wire  [ Tn * Tm * KERNEL_SIZE * KERNEL_SIZE * KERNEL_WIDTH - 1 : 0 ]    weight_in,
    input   wire  [ SCALER_WIDTH - 1 : 0 ]                                          weight_scaler,
    input   wire  [ Tm * BIAS_WIDTH - 1 : 0 ]                                       bias_in,
    input   wire  [ 3 : 0 ]                                                         ctr,
    input   wire                                                                    enable,
    input   wire                                                                    addr_clear,
    output  wire                                                                    out_valid,
    output  wire  [ Tm * FEATURE_WIDTH - 1 : 0 ]                                    feature_out
    );

wire        [ FEATURE_WIDTH - 1 : 0 ]                                                   feature_in_wire[Tn * KERNEL_SIZE * KERNEL_SIZE - 1:0];
wire        [ KERNEL_WIDTH - 1 : 0 ]                                                    weight_in_wire[Tn * Tm * KERNEL_SIZE * KERNEL_SIZE - 1 : 0];
wire signed [ FEATURE_WIDTH - 1 : 0 ]                                                   select_out_wire[Tn * Tm * KERNEL_SIZE * KERNEL_SIZE - 1 : 0];
wire signed [ FEATURE_WIDTH - 1 : 0 ]                                                   adder_tree_DSP_1[Tn * (Tm/2) * 12 - 1 : 0];
wire signed [ FEATURE_WIDTH - 1 : 0 ]                                                   adder_tree_DSP_2[Tn * (Tm/2) * 6 - 1 : 0];
wire signed [ FEATURE_WIDTH - 1 : 0 ]                                                   adder_tree_DSP_3[Tn * (Tm/2) * 4 - 1 : 0];
wire signed [ FEATURE_WIDTH - 1 : 0 ]                                                   adder_tree_DSP_4[Tn * (Tm/2) * 2 - 1 : 0];
wire signed [ FEATURE_WIDTH - 1 : 0 ]                                                   adder_tree_DSP_5[Tn * (Tm/2) - 1 : 0];
wire signed [ FEATURE_WIDTH - 1 : 0 ]                                                   adder_tree_DSP_6[(Tm/2) * Tn / 2 - 1 : 0];
wire signed [ FEATURE_WIDTH - 1 : 0 ]                                                   adder_tree_DSP_7[(Tm/2) - 1 : 0]; 
wire signed [ FEATURE_WIDTH - 1 : 0 ]                                                   adder_tree_DSP_out[Tm - 1 : 0];                                           
wire signed [ FEATURE_WIDTH - 1 : 0 ]                                                   scaler_out[Tm - 1 : 0];
wire signed [ FEATURE_WIDTH - 1 : 0 ]                                                   bias_out[Tm - 1 : 0];
wire                                                                                    pooling_enable;
reg                                                                                     pooling_enable_p;
wire signed [ FEATURE_WIDTH - 1 : 0 ]                                                   compare_tree_wire[Tm * COMPARE_TREE_CELL - 1 : 0];
wire signed [ FEATURE_WIDTH - 1 : 0 ]                                                   function_in[Tm - 1 : 0];
wire signed [ FEATURE_WIDTH - 1 : 0 ]                                                   function_out[Tm - 1 : 0]; 
reg  signed [ FEATURE_WIDTH - 1 : 0 ]                                                   accumulate_out[Tm - 1 : 0]; 

genvar i,j,k,x,y,z;

generate
    for(i = 0 ; i < Tn ; i = i + 1) begin:feature_in_wire_i
        for(j = 0 ; j < KERNEL_SIZE ; j = j + 1) begin:feature_in_wire_j
            for(k = 0 ; k < KERNEL_SIZE; k = k + 1) begin:feature_in_wire_k
                assign feature_in_wire[i * KERNEL_SIZE * KERNEL_SIZE + j * KERNEL_SIZE + k] 
                        = feature_in[i * KERNEL_SIZE * KERNEL_SIZE * FEATURE_WIDTH + j * KERNEL_SIZE * FEATURE_WIDTH + k * FEATURE_WIDTH  + FEATURE_WIDTH - 1 :
                                     i * KERNEL_SIZE * KERNEL_SIZE * FEATURE_WIDTH + j * KERNEL_SIZE * FEATURE_WIDTH + k * FEATURE_WIDTH  ];
            end
        end
    end
endgenerate


generate
    for(i = 0 ; i < Tm;i = i + 1) begin:weight_in_wire_i
        for(j = 0 ; j < Tn; j = j + 1) begin:weight_in_wire_j
            for(k = 0 ; k < KERNEL_SIZE ; k = k + 1) begin:weight_in_wire_k
                for(x = 0 ; x < KERNEL_SIZE ; x = x+ 1) begin:weight_in_wire_x
                    assign weight_in_wire[i * Tn * KERNEL_SIZE * KERNEL_SIZE + j * KERNEL_SIZE * KERNEL_SIZE + k * KERNEL_SIZE + x]
                            = weight_in[i * Tn * KERNEL_SIZE * KERNEL_SIZE * KERNEL_WIDTH + j * KERNEL_SIZE * KERNEL_SIZE * KERNEL_WIDTH + k * KERNEL_SIZE * KERNEL_WIDTH + x * KERNEL_WIDTH + KERNEL_WIDTH - 1 :
                                        i * Tn * KERNEL_SIZE * KERNEL_SIZE * KERNEL_WIDTH + j * KERNEL_SIZE * KERNEL_SIZE * KERNEL_WIDTH + k * KERNEL_SIZE * KERNEL_WIDTH + x * KERNEL_WIDTH];
                end
            end
        end
    end
endgenerate


generate 
    for(x = 0; x < Tm;x = x + 1) begin:select_m
        for(k = 0; k < Tn; k = k + 1) begin:select_n
            for(i = 0; i < KERNEL_SIZE; i = i + 1) begin:select_r
               for(j = 0; j < KERNEL_SIZE; j = j + 1) begin:select_c
                   select_unit #(
                    .FEATURE_WIDTH(FEATURE_WIDTH) 
                   )my_select_unit(
                    .clk(clk),
                    .rst(rst),
                    .select_in(feature_in_wire[k * KERNEL_SIZE * KERNEL_SIZE + i * KERNEL_SIZE + j]),
                    .kernel(weight_in_wire[x * Tn *KERNEL_SIZE *KERNEL_SIZE + k * KERNEL_SIZE * KERNEL_SIZE + i * KERNEL_SIZE + j]),                                
                    .select_out(select_out_wire[x * Tn * KERNEL_SIZE * KERNEL_SIZE + k * KERNEL_SIZE * KERNEL_SIZE + i * KERNEL_SIZE + j])
                    );
                end
            end
        end
    end
endgenerate 


wire  [Tn * Tm * KERNEL_SIZE * KERNEL_SIZE * FEATURE_WIDTH - 1 : 0]                 fifo_0_in_wire;
wire  [Tn * Tm * KERNEL_SIZE * KERNEL_SIZE * FEATURE_WIDTH / 2 - 1 : 0  ]           fifo_0_out_wire;


generate
    for(i = 0 ; i < Tm; i=i+1) begin:fifo_0_in_wire_i
        for(j = 0 ; j < Tn; j=j+1) begin:fifo_0_in_wire_j
            for(k = 0 ; k < KERNEL_SIZE * KERNEL_SIZE; k=k+1) begin:firo_0_wire_k
                assign fifo_0_in_wire[i*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + j*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + k*FEATURE_WIDTH + FEATURE_WIDTH - 1 : 
                                      i*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + j*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + k*FEATURE_WIDTH] 
                        = select_out_wire[i*Tn*KERNEL_SIZE*KERNEL_SIZE + j*KERNEL_SIZE*KERNEL_SIZE + k];
            end
        end
    end
endgenerate 




generate
    for(i = 0 ; i < Tn; i=i+1) begin:afifo_i
        afifo fifo_0(
                    .write_clk(clk),
                    .read_clk(fast_clk),
                    .rst(rst),
                    .data_in({fifo_0_in_wire[i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH - 1:i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH],
                              fifo_0_in_wire[8*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH - 1 : 8*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH]}),
                    .write_enable(1),
                    .data_out(fifo_0_out_wire[i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH - 1: i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH]),
                    .data_out_validate()
                    );
        afifo fifo_1(
                    .write_clk(clk),
                    .read_clk(fast_clk),
                    .rst(rst),
                    .data_in({fifo_0_in_wire[1*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH - 1 : 1*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH],
                              fifo_0_in_wire[9*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH - 1 : 9*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH]}),
                    .write_enable(1),
                    .data_out(fifo_0_out_wire[1*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH - 1 : 1*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH ]),
                    .data_out_validate()
                    );                
        afifo fifo_2(
                    .write_clk(clk),
                    .read_clk(fast_clk),
                    .rst(rst),
                    .data_in({fifo_0_in_wire[2*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH - 1 : 2*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH],
                              fifo_0_in_wire[10*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH - 1 : 10*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH]}),
                    .write_enable(1),
                    .data_out(fifo_0_out_wire[2*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH - 1 : 2*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH]),
                    .data_out_validate()
                    );   
        afifo fifo_3(
                    .write_clk(clk),
                    .read_clk(fast_clk),
                    .rst(rst),
                    .data_in({fifo_0_in_wire[3*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH - 1 : 3*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH],
                              fifo_0_in_wire[11*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH - 1 : 11*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH]}),
                    .write_enable(1),
                    .data_out(fifo_0_out_wire[3*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH - 1 : 3*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH ]),
                    .data_out_validate()
                    );   
                    
        afifo fifo_4(
                    .write_clk(clk),
                    .read_clk(fast_clk),
                    .rst(rst),
                    .data_in({fifo_0_in_wire[4*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH - 1 : 4*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH],
                              fifo_0_in_wire[12*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH - 1 : 12*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH]}),
                    .write_enable(1),
                    .data_out(fifo_0_out_wire[4*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH - 1 : 4*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH ]),
                    .data_out_validate()
                    );
        afifo fifo_5(
                    .write_clk(clk),
                    .read_clk(fast_clk),
                    .rst(rst),
                    .data_in({fifo_0_in_wire[5*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH - 1 : 5*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH],
                              fifo_0_in_wire[13*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH - 1 : 13*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH]}),
                    .write_enable(1),
                    .data_out(fifo_0_out_wire[5*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH - 1 : 5*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH ]),
                    .data_out_validate()
                    );                
        afifo fifo_6(
                    .write_clk(clk),
                    .read_clk(fast_clk),
                    .rst(rst),
                    .data_in({fifo_0_in_wire[6*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH - 1 : 6*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH],
                              fifo_0_in_wire[14*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH - 1 : 14*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH]}),
                    .write_enable(1),
                    .data_out(fifo_0_out_wire[6*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH - 1 : 6*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH]),
                    .data_out_validate()
                    );   
        afifo fifo_7(
                    .write_clk(clk),
                    .read_clk(fast_clk),
                    .rst(rst),
                    .data_in({fifo_0_in_wire[7*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH - 1 : 7*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH],
                              fifo_0_in_wire[15*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH - 1 : 15*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH]}),
                    .write_enable(1),
                    .data_out(fifo_0_out_wire[7*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH - 1 : 7*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH ]),
                    .data_out_validate()
                    );                     
                    
                    
    end
endgenerate


generate                 //   adder No.1
    for(i = 0 ; i < Tn ; i=i+1) begin:adder_tree_1_i
        for(j = 0 ; j < 24; j=j+2) begin:adder_tree_1_j
             adder_unit_by_DSP_pri  my_adder_tree_1_1(
                                                 .CLK(fast_clk), 
                                                 .RST(rst),
                                                 .AIN1(fifo_0_out_wire[i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + j*FEATURE_WIDTH + FEATURE_WIDTH - 1 : i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + j*FEATURE_WIDTH]), 
                                                 .BIN1(fifo_0_out_wire[i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + (j+1)*FEATURE_WIDTH + FEATURE_WIDTH - 1 : i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + (j+1)*FEATURE_WIDTH]),
                                                 .OUT1(adder_tree_DSP_1[i*12+j/2]), 
                                                 .AIN2(fifo_0_out_wire[1*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + j*FEATURE_WIDTH + FEATURE_WIDTH - 1 : 1*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH +i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + j*FEATURE_WIDTH]),  
                                                 .BIN2(fifo_0_out_wire[1*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + (j+1)*FEATURE_WIDTH + FEATURE_WIDTH - 1 : 1*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH +i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + (j+1)*FEATURE_WIDTH]),   
                                                 .OUT2(adder_tree_DSP_1[1*Tn*12 + i*12+j/2]),    
                                                 .AIN3(fifo_0_out_wire[2*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + j*FEATURE_WIDTH + FEATURE_WIDTH - 1 : 2*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH +i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + j*FEATURE_WIDTH]),
                                                 .BIN3(fifo_0_out_wire[2*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + (j+1)*FEATURE_WIDTH + FEATURE_WIDTH - 1 : 2*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH +i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + (j+1)*FEATURE_WIDTH]),
                                                 .OUT3(adder_tree_DSP_1[2*Tn*12 + i*12+j/2]),
                                                 .AIN4(fifo_0_out_wire[3*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + j*FEATURE_WIDTH + FEATURE_WIDTH - 1 : 3*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH +i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + j*FEATURE_WIDTH]),
                                                 .BIN4(fifo_0_out_wire[3*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + (j+1)*FEATURE_WIDTH + FEATURE_WIDTH - 1 : 3*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH +i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + (j+1)*FEATURE_WIDTH]),
                                                 .OUT4(adder_tree_DSP_1[3*Tn*12 + i*12+j/2])
                                                    );
              adder_unit_by_DSP_pri  my_adder_tree_1_2(
                                                .CLK(fast_clk), 
                                                .RST(rst),
                                                .AIN1(fifo_0_out_wire[4*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + j*FEATURE_WIDTH + FEATURE_WIDTH - 1 : 4*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH +i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + j*FEATURE_WIDTH]),  
                                                .BIN1(fifo_0_out_wire[4*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + (j+1)*FEATURE_WIDTH + FEATURE_WIDTH - 1 : 4*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH +i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + (j+1)*FEATURE_WIDTH]),   
                                                .OUT1(adder_tree_DSP_1[4*Tn*12 + i*12+j/2]),
                                                .AIN2(fifo_0_out_wire[5*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + j*FEATURE_WIDTH + FEATURE_WIDTH - 1 : 5*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH +i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + j*FEATURE_WIDTH]),  
                                                .BIN2(fifo_0_out_wire[5*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + (j+1)*FEATURE_WIDTH + FEATURE_WIDTH - 1 : 5*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH +i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + (j+1)*FEATURE_WIDTH]),   
                                                .OUT2(adder_tree_DSP_1[5*Tn*12 + i*12+j/2]),    
                                                .AIN3(fifo_0_out_wire[6*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + j*FEATURE_WIDTH + FEATURE_WIDTH - 1 : 6*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH +i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + j*FEATURE_WIDTH]),
                                                .BIN3(fifo_0_out_wire[6*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + (j+1)*FEATURE_WIDTH + FEATURE_WIDTH - 1 : 6*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH +i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + (j+1)*FEATURE_WIDTH]),
                                                .OUT3(adder_tree_DSP_1[6*Tn*12 + i*12+j/2]),
                                                .AIN4(fifo_0_out_wire[7*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + j*FEATURE_WIDTH + FEATURE_WIDTH - 1 : 7*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH +i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + j*FEATURE_WIDTH]),
                                                .BIN4(fifo_0_out_wire[7*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + (j+1)*FEATURE_WIDTH + FEATURE_WIDTH - 1 : 7*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH +i*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + (j+1)*FEATURE_WIDTH]),
                                                .OUT4(adder_tree_DSP_1[7*Tn*12 + i*12+j/2])
                                                   );
        end
    end
endgenerate



generate                 //   adder No.2
    for(i = 0 ; i < Tn ; i=i+1) begin:adder_tree_2_i
        for(j = 0 ; j < 12; j=j+2) begin:adder_tree_2_j
             adder_unit_by_DSP_pri  my_adder_tree_2_1(
                                                 .CLK(fast_clk), 
                                                 .RST(rst),
                                                 .AIN1(adder_tree_DSP_1[i*12+j]), 
                                                 .BIN1(adder_tree_DSP_1[i*12+(j+1)]),
                                                 .OUT1(adder_tree_DSP_2[i*6 + j/2]), 
                                                 .AIN2(adder_tree_DSP_1[1*Tn*12 + i*12 + j]),  
                                                 .BIN2(adder_tree_DSP_1[1*Tn*12 + i*12 + (j+1)]),   
                                                 .OUT2(adder_tree_DSP_2[1*Tn*6 + i*6 + j/2]),    
                                                 .AIN3(adder_tree_DSP_1[2*Tn*12 + i*12 + j]),
                                                 .BIN3(adder_tree_DSP_1[2*Tn*12 + i*12 + (j+1)]),
                                                 .OUT3(adder_tree_DSP_2[2*Tn*6 + i*6 + j/2]),
                                                 .AIN4(adder_tree_DSP_1[3*Tn*12 + i*12 + j]),
                                                 .BIN4(adder_tree_DSP_1[3*Tn*12 + i*12 + (j+1)]),
                                                 .OUT4(adder_tree_DSP_2[3*Tn*6 + i*6 + j/2])
                                                    );
             adder_unit_by_DSP_pri  my_adder_tree_2_2(
                                                .CLK(fast_clk), 
                                                .RST(rst),
                                                .AIN1(adder_tree_DSP_1[4*Tn*12 + i*12 + j]),  
                                                .BIN1(adder_tree_DSP_1[4*Tn*12 + i*12 + (j+1)]),   
                                                .OUT1(adder_tree_DSP_2[4*Tn*6 + i*6 + j/2]),    
                                                .AIN2(adder_tree_DSP_1[5*Tn*12 + i*12 + j]),  
                                                .BIN2(adder_tree_DSP_1[5*Tn*12 + i*12 + (j+1)]),   
                                                .OUT2(adder_tree_DSP_2[5*Tn*6 + i*6 + j/2]),    
                                                .AIN3(adder_tree_DSP_1[6*Tn*12 + i*12 + j]),
                                                .BIN3(adder_tree_DSP_1[6*Tn*12 + i*12 + (j+1)]),
                                                .OUT3(adder_tree_DSP_2[6*Tn*6 + i*6 + j/2]),
                                                .AIN4(adder_tree_DSP_1[7*Tn*12 + i*12 + j]),
                                                .BIN4(adder_tree_DSP_1[7*Tn*12 + i*12 + (j+1)]),
                                                .OUT4(adder_tree_DSP_2[7*Tn*6 + i*6 + j/2])
                                                   );                                                    
        end
    end
endgenerate


generate                 //   adder No.3
    for(i = 0 ; i < Tn ; i=i+1) begin:adder_tree_3_i
        for(j = 0 ; j < 6; j=j+2) begin:adder_tree_3_j
             adder_unit_by_DSP_pri  my_adder_tree_3_1(
                                                 .CLK(fast_clk), 
                                                 .RST(rst),
                                                 .AIN1(adder_tree_DSP_2[i*6 + j]), 
                                                 .BIN1(adder_tree_DSP_2[i*6 + (j+1)]),
                                                 .OUT1(adder_tree_DSP_3[i*4 + j/2]), 
                                                 .AIN2(adder_tree_DSP_2[1*Tn*6 + i*6 + j]),  
                                                 .BIN2(adder_tree_DSP_2[1*Tn*6 + i*6 + (j+1)]),   
                                                 .OUT2(adder_tree_DSP_3[1*Tn*4 + i*4 + j/2]),    
                                                 .AIN3(adder_tree_DSP_2[2*Tn*6 + i*6 + j]),
                                                 .BIN3(adder_tree_DSP_2[2*Tn*6 + i*6 + (j+1)]),
                                                 .OUT3(adder_tree_DSP_3[2*Tn*4 + i*4 + j/2]),
                                                 .AIN4(adder_tree_DSP_2[3*Tn*6 + i*6 + j]),
                                                 .BIN4(adder_tree_DSP_2[3*Tn*6 + i*6 + (j+1)]),
                                                 .OUT4(adder_tree_DSP_3[3*Tn*4 + i*4 + j/2])
                                                    );
             adder_unit_by_DSP_pri  my_adder_tree_3_2(
                                                .CLK(fast_clk), 
                                                .RST(rst),
                                                .AIN1(adder_tree_DSP_2[4*Tn*6 + i*6 + j]),  
                                                .BIN1(adder_tree_DSP_2[4*Tn*6 + i*6 + (j+1)]),   
                                                .OUT1(adder_tree_DSP_3[4*Tn*4 + i*4 + j/2]),    
                                                .AIN2(adder_tree_DSP_2[5*Tn*6 + i*6 + j]),  
                                                .BIN2(adder_tree_DSP_2[5*Tn*6 + i*6 + (j+1)]),   
                                                .OUT2(adder_tree_DSP_3[5*Tn*4 + i*4 + j/2]),    
                                                .AIN3(adder_tree_DSP_2[6*Tn*6 + i*6 + j]),
                                                .BIN3(adder_tree_DSP_2[6*Tn*6 + i*6 + (j+1)]),
                                                .OUT3(adder_tree_DSP_3[6*Tn*4 + i*4 + j/2]),
                                                .AIN4(adder_tree_DSP_2[7*Tn*6 + i*6 + j]),
                                                .BIN4(adder_tree_DSP_2[7*Tn*6 + i*6 + (j+1)]),
                                                .OUT4(adder_tree_DSP_3[7*Tn*4 + i*4 + j/2])
                                                   );                                                    
        end
    end
endgenerate

generate   
    for(i = 0 ; i < Tm/2; i = i + 1) begin:DSP_wire_delay_i
        for(j = 0 ; j < Tn ; j = j + 1 ) begin:DSP_wire_delay_j
            register #(
                 .NUM_STAGES(6),
                 .DATA_WIDTH(FEATURE_WIDTH)
                 )DSP_wire_delay(
                 .CLK(fast_clk),
                 .RESET(rst),
                 .DIN(fifo_0_out_wire[i*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + j*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + 24*FEATURE_WIDTH + FEATURE_WIDTH - 1 : i*Tn*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + j*KERNEL_SIZE*KERNEL_SIZE*FEATURE_WIDTH + 24*FEATURE_WIDTH]),
                 .DOUT(adder_tree_DSP_3[i*Tn*4 + j*4 + 3])           
                 );
        end
    end
endgenerate



generate                 //   adder No.4
    for(i = 0 ; i < Tn ; i=i+1) begin:adder_tree_4_i
        for(j = 0 ; j < 4; j=j+2) begin:adder_tree_4_j
             adder_unit_by_DSP_pri  my_adder_tree_4_1(
                                                 .CLK(fast_clk), 
                                                 .RST(rst),
                                                 .AIN1(adder_tree_DSP_3[i*4 + j]), 
                                                 .BIN1(adder_tree_DSP_3[i*4 + (j+1)]),
                                                 .OUT1(adder_tree_DSP_4[i*2 + j/2]), 
                                                 .AIN2(adder_tree_DSP_3[1*Tn*4 + i*4 + j]),  
                                                 .BIN2(adder_tree_DSP_3[1*Tn*4 + i*4 + (j+1)]),   
                                                 .OUT2(adder_tree_DSP_4[1*Tn*2 + i*2 + j/2]),    
                                                 .AIN3(adder_tree_DSP_3[2*Tn*4 + i*4 + j]),
                                                 .BIN3(adder_tree_DSP_3[2*Tn*4 + i*4 + (j+1)]),
                                                 .OUT3(adder_tree_DSP_4[2*Tn*2 + i*2 + j/2]),
                                                 .AIN4(adder_tree_DSP_3[3*Tn*4 + i*4 + j]),
                                                 .BIN4(adder_tree_DSP_3[3*Tn*4 + i*4 + (j+1)]),
                                                 .OUT4(adder_tree_DSP_4[3*Tn*2 + i*2 + j/2])
                                                    );
             adder_unit_by_DSP_pri  my_adder_tree_4_2(
                                                .CLK(fast_clk), 
                                                .RST(rst),
                                                .AIN1(adder_tree_DSP_3[4*Tn*4 + i*4 + j]),  
                                                .BIN1(adder_tree_DSP_3[4*Tn*4 + i*4 + (j+1)]),   
                                                .OUT1(adder_tree_DSP_4[4*Tn*2 + i*2 + j/2]),   
                                                .AIN2(adder_tree_DSP_3[5*Tn*4 + i*4 + j]),  
                                                .BIN2(adder_tree_DSP_3[5*Tn*4 + i*4 + (j+1)]),   
                                                .OUT2(adder_tree_DSP_4[5*Tn*2 + i*2 + j/2]),    
                                                .AIN3(adder_tree_DSP_3[6*Tn*4 + i*4 + j]),
                                                .BIN3(adder_tree_DSP_3[6*Tn*4 + i*4 + (j+1)]),
                                                .OUT3(adder_tree_DSP_4[6*Tn*2 + i*2 + j/2]),
                                                .AIN4(adder_tree_DSP_3[7*Tn*4 + i*4 + j]),
                                                .BIN4(adder_tree_DSP_3[7*Tn*4 + i*4 + (j+1)]),
                                                .OUT4(adder_tree_DSP_4[7*Tn*2 + i*2 + j/2])
                                                   );                                                    
        end
    end
endgenerate


generate                 //   adder No.5
    for(i = 0 ; i < Tn ; i=i+1) begin:adder_tree_5_i
             adder_unit_by_DSP_pri  my_adder_tree_5_1(
                                                 .CLK(fast_clk), 
                                                 .RST(rst),
                                                 .AIN1(adder_tree_DSP_4[i*2 + 0]), 
                                                 .BIN1(adder_tree_DSP_4[i*2 + 1]),
                                                 .OUT1(adder_tree_DSP_5[i]), 
                                                 .AIN2(adder_tree_DSP_4[1*Tn*2 + i*2 + 0]),  
                                                 .BIN2(adder_tree_DSP_4[1*Tn*2 + i*2 + 1]),   
                                                 .OUT2(adder_tree_DSP_5[1*Tn+i]),    
                                                 .AIN3(adder_tree_DSP_4[2*Tn*2 + i*2 + 0]),
                                                 .BIN3(adder_tree_DSP_4[2*Tn*2 + i*2 + 1]),
                                                 .OUT3(adder_tree_DSP_5[2*Tn+i]),
                                                 .AIN4(adder_tree_DSP_4[3*Tn*2 + i*2 + 0]),
                                                 .BIN4(adder_tree_DSP_4[3*Tn*2 + i*2 + 1]),
                                                 .OUT4(adder_tree_DSP_5[3*Tn+i])
                                                    );
             adder_unit_by_DSP_pri  my_adder_tree_5_2(
                                                .CLK(fast_clk), 
                                                .RST(rst),
                                                .AIN1(adder_tree_DSP_4[4*Tn*2 + i*2 + 0]),  
                                                .BIN1(adder_tree_DSP_4[4*Tn*2 + i*2 + 1]),   
                                                .OUT1(adder_tree_DSP_5[4*Tn+i]),    
                                                .AIN2(adder_tree_DSP_4[5*Tn*2 + i*2 + 0]),  
                                                .BIN2(adder_tree_DSP_4[5*Tn*2 + i*2 + 1]),   
                                                .OUT2(adder_tree_DSP_5[5*Tn+i]),    
                                                .AIN3(adder_tree_DSP_4[6*Tn*2 + i*2 + 0]),
                                                .BIN3(adder_tree_DSP_4[6*Tn*2 + i*2 + 1]),
                                                .OUT3(adder_tree_DSP_5[6*Tn+i]),
                                                .AIN4(adder_tree_DSP_4[7*Tn*2 + i*2 + 0]),
                                                .BIN4(adder_tree_DSP_4[7*Tn*2 + i*2 + 1]),
                                                .OUT4(adder_tree_DSP_5[7*Tn+i])
                                                   );                                                    
    end
endgenerate


generate                 //adder2   No.6
    for(i = 0 ; i < 4; i=i+2) begin:adder_tree6_i    //4=Tm/2
        adder_unit_by_DSP_pri  my_adder_tree_6_1(
                                              .CLK(fast_clk), 
                                              .RST(rst),
                                              .AIN1(adder_tree_DSP_5[i]), 
                                              .BIN1(adder_tree_DSP_5[i+1]),
                                              .OUT1(adder_tree_DSP_6[i/2]), 
                                              .AIN2(adder_tree_DSP_5[1*4+i]),  
                                              .BIN2(adder_tree_DSP_5[1*4+i+1]),   
                                              .OUT2(adder_tree_DSP_6[1*2+i/2]),    
                                              .AIN3(adder_tree_DSP_5[2*4+i]),
                                              .BIN3(adder_tree_DSP_5[2*4+i+1]),
                                              .OUT3(adder_tree_DSP_6[2*2+i/2]),
                                              .AIN4(adder_tree_DSP_5[3*4+i]),
                                              .BIN4(adder_tree_DSP_5[3*4+i+1]),
                                              .OUT4(adder_tree_DSP_6[3*2+i/2])
                                                 );
        adder_unit_by_DSP_pri  my_adder_tree_6_2(
                                               .CLK(fast_clk), 
                                               .RST(rst),
                                               .AIN1(adder_tree_DSP_5[4*4+i]),  
                                               .BIN1(adder_tree_DSP_5[4*4+i+1]),   
                                               .OUT1(adder_tree_DSP_6[4*2+i/2]),    
                                               .AIN2(adder_tree_DSP_5[5*4+i]),  
                                               .BIN2(adder_tree_DSP_5[5*4+i+1]),   
                                               .OUT2(adder_tree_DSP_6[5*2+i/2]),    
                                               .AIN3(adder_tree_DSP_5[6*4+i]),
                                               .BIN3(adder_tree_DSP_5[6*4+i+1]),
                                               .OUT3(adder_tree_DSP_6[6*2+i/2]),
                                               .AIN4(adder_tree_DSP_5[7*4+i]),
                                               .BIN4(adder_tree_DSP_5[7*4+i+1]),
                                               .OUT4(adder_tree_DSP_6[7*2+i/2])
                                                  );                                                 
    end
endgenerate 

generate      //adder2   No.7
    adder_unit_by_DSP_pri  my_adder_tree_7_1(
                              .CLK(fast_clk), 
                              .RST(rst),
                              .AIN1(adder_tree_DSP_6[0]), 
                              .BIN1(adder_tree_DSP_6[1]),
                              .OUT1(adder_tree_DSP_7[0]), 
                              .AIN2(adder_tree_DSP_6[2]),  
                              .BIN2(adder_tree_DSP_6[3]),   
                              .OUT2(adder_tree_DSP_7[1]),    
                              .AIN3(adder_tree_DSP_6[4]),
                              .BIN3(adder_tree_DSP_6[5]),
                              .OUT3(adder_tree_DSP_7[2]),
                              .AIN4(adder_tree_DSP_6[6]),
                              .BIN4(adder_tree_DSP_6[7]),
                              .OUT4(adder_tree_DSP_7[3])
                                 );
                                 
     adder_unit_by_DSP_pri  my_adder_tree_7_2(
                               .CLK(fast_clk), 
                               .RST(rst),
                               .AIN1(adder_tree_DSP_6[8]), 
                               .BIN1(adder_tree_DSP_6[9]),
                               .OUT1(adder_tree_DSP_7[4]), 
                               .AIN2(adder_tree_DSP_6[10]),  
                               .BIN2(adder_tree_DSP_6[11]),   
                               .OUT2(adder_tree_DSP_7[5]),    
                               .AIN3(adder_tree_DSP_6[12]),
                               .BIN3(adder_tree_DSP_6[13]),
                               .OUT3(adder_tree_DSP_7[6]),
                               .AIN4(adder_tree_DSP_6[14]),
                               .BIN4(adder_tree_DSP_6[15]),
                               .OUT4(adder_tree_DSP_7[7])
                                  );                            
                                 
                                 
endgenerate


wire [FEATURE_WIDTH * Tm/2 - 1 :0]fifo_1_data_in;      //47
wire [FEATURE_WIDTH * Tm - 1 :0 ]fifo_1_data_out;     //95

generate
    for(i = 0 ; i < Tm/2; i=i+1) begin:fifo_2_data_in_i
        assign fifo_1_data_in[i*FEATURE_WIDTH + FEATURE_WIDTH-1 : i*FEATURE_WIDTH ] = adder_tree_DSP_7[i];
    end
endgenerate




fifo_generator_1 fifo_1 (
  .rst(rst),                  // input wire rst
  .wr_clk(fast_clk),            // input wire wr_clk
  .rd_clk(clk),            // input wire rd_clk
  .din(fifo_1_data_in),                  // input wire [31 : 0] din
  .wr_en(1),              // input wire wr_en
  .rd_en(1),              // input wire rd_en
  .dout(fifo_1_data_out),                // output wire [63 : 0] dout
  .full( ),                // output wire full
  .empty( ),              // output wire empty
  .wr_rst_busy( ),  // output wire wr_rst_busy
  .rd_rst_busy( )  // output wire rd_rst_busy
);


generate 
    for(i = 0 ; i < Tm; i=i+1) begin:fifo_1_data_out_i
        assign adder_tree_DSP_out[i] = fifo_1_data_out[i*FEATURE_WIDTH + FEATURE_WIDTH - 1 : i*FEATURE_WIDTH ];
    end
endgenerate








generate   //adder No.8   bias
    for(i = 0; i < Tm;i = i + 4) begin:add_bias_i                       
    adder_unit_by_DSP_pri  bias_add(
        .CLK(clk), 
        .RST(rst),
        .AIN1(adder_tree_DSP_out[i]), 
        .BIN1(bias_in[i * BIAS_WIDTH + BIAS_WIDTH - 1 : i * BIAS_WIDTH]),
        .OUT1(bias_out[i]), 
        .AIN2(adder_tree_DSP_out[i+1]),  
        .BIN2(bias_in[(i+1) * BIAS_WIDTH + BIAS_WIDTH - 1 : (i+1) * BIAS_WIDTH]),   
        .OUT2(bias_out[i+1]),
        .AIN3(adder_tree_DSP_out[i+2]), 
        .BIN3(bias_in[(i+2) * BIAS_WIDTH + BIAS_WIDTH - 1 : (i+2) * BIAS_WIDTH]),
        .OUT3(bias_out[i+2]), 
        .AIN4(adder_tree_DSP_out[i+3]),  
        .BIN4(bias_in[(i+3) * BIAS_WIDTH + BIAS_WIDTH - 1 : (i+3) * BIAS_WIDTH]),   
        .OUT4(bias_out[i+3])      
        
        );                                
    end
endgenerate

generate 
    for(i = 0; i < Tm;i = i + 1) begin:mult_i
            mult_scaler #(
                .FEATURE_WIDTH(FEATURE_WIDTH),
                .SCALER_WIDTH(SCALER_WIDTH)
            )my_mult_scaler(
            .clk(clk),
            .rst(rst),
            .in1(bias_out[i]),
            .in2(weight_scaler),
            .out(scaler_out[i])
            );
    end
endgenerate

generate
    for(i = 0 ; i < Tm ; i = i + 1) begin:rect_linear_i
        rect_linear #(
            .FEATURE_WIDTH(FEATURE_WIDTH)
        )ReLu(
            .clk(clk),
            .rst(rst),
            .function_in(function_in[i]),
            .function_out(function_out[i])
            );
    end
endgenerate

wire        [ 3 : 0 ]                                                                   ctr_p;
wire                                                                                    out_valid_scaler_out;
wire                                                                                    out_valid_function_out;
wire                                                                                    pooling_enable_scaler_out;
wire                                                                                    pooling_enable_function_out;
wire                                                                                    pooling_enable_storage_function_out;


reg                                                                                     addr_clear_p;

reg signed  [FEATURE_WIDTH - 1 : 0 ]                                                    pooling_in[Tm - 1 : 0];
reg signed  [FEATURE_WIDTH - 1 : 0 ]                                                    IP_output[Tm - 1 : 0];
reg signed  [FEATURE_WIDTH - 1 : 0 ]                                                    IP_temp_result[Tm - 1 : 0];
wire                                                                                    result_read_enable_for_IP;

reg     [ Tm * FEATURE_WIDTH - 1 : 0 ]              temp_result_mem_write_data;
reg     [ 9 : 0 ]                                   temp_result_mem_write_addr;
wire                                                temp_result_mem_write_enable_ctr;
wire                                                temp_result_mem_write_enable_ctr2;
wire                                                temp_result_mem_write_enable;

wire    [ Tm * FEATURE_WIDTH - 1 : 0 ]              temp_result_mem_read_data;
reg     [ 9 : 0 ]                                   temp_result_mem_read_addr;
wire                                                temp_result_mem_read_enable_ctr;
wire                                                temp_result_mem_read_enable;

generate
    for(i = 0; i < Tm;i = i + 1) begin:function_in_wire_i
        assign function_in[i] = ((ctr_p == 4'b0010) || (ctr_p == 4'b1000)) ? scaler_out[i] : accumulate_out[i];
    end
endgenerate


register #(      //!!!!!!!!!!!!!!!!!!!!!!!!
     .NUM_STAGES(11),
     .DATA_WIDTH(4)
     )ctr_delay(
     .CLK(clk),
     .RESET(rst),
     .DIN(ctr),
     .DOUT(ctr_p)           
     );
     
register #(
  .NUM_STAGES(11+8),
  .DATA_WIDTH(1)
  )enable_delay_pooling_scaler_out(
  .CLK(clk),
  .RESET(rst),
  .DIN(enable),
  .DOUT(pooling_enable_scaler_out)           
  );

register #(
  .NUM_STAGES(12+8),
  .DATA_WIDTH(1)
  )enable_delay_pooling_function_out(
  .CLK(clk),
  .RESET(rst),
  .DIN(enable),
  .DOUT(pooling_enable_function_out)           
  );
register #(
    .NUM_STAGES(13+8),
    .DATA_WIDTH(1)
    )enable_delay_pooling_storage_function_out(
    .CLK(clk),
    .RESET(rst),
    .DIN(enable),
    .DOUT(pooling_enable_storage_function_out)           
    );
register #(
   .NUM_STAGES(11+8),
   .DATA_WIDTH(1)
   )temp_result_mem_write_enable_delay(
   .CLK(clk),
   .RESET(rst),
   .DIN(enable),
   .DOUT(temp_result_mem_write_enable_ctr)           
   );

register #(
     .NUM_STAGES(9+8),
     .DATA_WIDTH(1)
     )temp_result_mem_read_enable_delay(
     .CLK(clk),
     .RESET(rst),
     .DIN(enable),
     .DOUT(temp_result_mem_read_enable_ctr)           
     );


assign pooling_enable = (ctr_p == 4'b0001) ? pooling_enable_scaler_out : 
                        ((ctr_p == 4'b0010) ? pooling_enable_function_out :
                        ((ctr_p == 4'b0110) ? pooling_enable_storage_function_out : 1'dz));


generate
    for(i = 0 ; i < Tm; i = i + 1) begin:ctr_i
        always@(posedge clk)
                case(ctr_p)
                    4'b0001:begin
                        pooling_in[i] <= scaler_out[i];
                    end
                    4'b0010:begin
                        pooling_in[i] <= function_out[i];
                    end
                    4'b0011:begin
                        temp_result_mem_write_data[ i * FEATURE_WIDTH + FEATURE_WIDTH - 1 : i * FEATURE_WIDTH ] <= scaler_out[i];
                    end
                    4'b0100:begin
                        temp_result_mem_write_data[ i * FEATURE_WIDTH + FEATURE_WIDTH - 1 : i * FEATURE_WIDTH ] <= scaler_out[i] + temp_result_mem_read_data[ i * FEATURE_WIDTH + FEATURE_WIDTH - 1 : i * FEATURE_WIDTH ];
                    end
                    4'b0110:begin
                        accumulate_out[i] <= scaler_out[i] + temp_result_mem_read_data[ i * FEATURE_WIDTH + FEATURE_WIDTH - 1 : i * FEATURE_WIDTH ];
                        pooling_in[i] <= function_out[i];
                    end                   
                    default:
                        ;
                endcase                   
    end
endgenerate

always@(posedge clk)
    if(rst)
        temp_result_mem_write_addr <= 0;
    else
        if((addr_clear == 1) && (addr_clear_p == 0))
            temp_result_mem_write_addr <= 0;   
        else
            if(temp_result_mem_write_enable)
                temp_result_mem_write_addr <= temp_result_mem_write_addr + 1;
            else
                temp_result_mem_write_addr <= temp_result_mem_write_addr;    

always@(posedge clk)
    if(rst)
        temp_result_mem_read_addr <= 0;
    else
        if((addr_clear == 1) && (addr_clear_p == 0))
            temp_result_mem_read_addr <= 0;    
        else
            if(temp_result_mem_read_enable)
                temp_result_mem_read_addr <= temp_result_mem_read_addr + 1;
            else 
                temp_result_mem_read_addr <= temp_result_mem_read_addr;    



always@(posedge clk)
    if(rst)
        addr_clear_p <= 0;
    else 
        addr_clear_p <= addr_clear;


assign temp_result_mem_write_enable = temp_result_mem_write_enable_ctr && ((ctr_p == 4'b0011)||(ctr_p == 4'b0100));
assign temp_result_mem_read_enable = temp_result_mem_read_enable_ctr && ((ctr_p == 4'b0100)||(ctr_p == 4'b0110));


temp_result_mem_gen temp_result_mem (
  .clka(clk),    // input wire clka
  .ena(temp_result_mem_write_enable),      // input wire ena
  .wea(1'b1),      // input wire [0 : 0] wea
  .addra(temp_result_mem_write_addr),  // input wire [9 : 0] addra
  .dina(temp_result_mem_write_data),    // input wire [63 : 0] dina
  .clkb(clk),    // input wire clkb
  .enb(temp_result_mem_read_enable),      // input wire enb
  .addrb(temp_result_mem_read_addr),  // input wire [9 : 0] addrb
  .doutb(temp_result_mem_read_data)  // output wire [63 : 0] doutb
);


reg [ FEATURE_WIDTH - 1 : 0 ]   pooling_temp_3[Tm - 1 : 0];
reg [ FEATURE_WIDTH - 1 : 0 ]   pooling_temp1[Tm - 1 : 0];
reg [ FEATURE_WIDTH - 1 : 0 ]   pooling_temp2[Tm - 1 : 0];
reg [ FEATURE_WIDTH - 1 : 0 ]   pooling_temp3[Tm - 1 : 0];
reg [ FEATURE_WIDTH - 1 : 0 ]   pooling_temp4[Tm - 1 : 0];
wire                            pooling_data_ready;
wire[ FEATURE_WIDTH - 1 : 0 ]   pooling_out[Tm - 1 : 0];


wire                                pooling_buf_wr_en;
wire                                pooling_buf_rd_en;
wire[ FEATURE_WIDTH * 2 - 1 : 0 ]   pooling_buf_dout[Tm - 1 : 0];
reg                                 pooling_buf_wr_ctr;
wire                                pooling_process_enable;
reg                                 pooling_process_ctr;


generate
    for(i = 0 ; i < Tm ; i = i + 1 ) begin:pooling_buf_i    
        pooling_buf_by_fifo_gen pooling_buf (
          .clk(clk),      // input wire clk
          .din(pooling_in[i]),      // input 
          .wr_en(pooling_buf_wr_en),  // input wire wr_en
          .rd_en(pooling_buf_rd_en),  // input wire rd_en
          .dout(pooling_buf_dout[i]),    // output
          .full(),    // output wire full
          .empty()  // output wire empty
        ); 
    end
endgenerate

always@(posedge clk)
    if(rst)
        pooling_enable_p <= 0;
    else
        pooling_enable_p <= pooling_enable;   
        
always@(posedge clk)
    if(rst)
        pooling_buf_wr_ctr <= 0;
    else
        if((pooling_enable == 0) && (pooling_enable_p == 1))
            pooling_buf_wr_ctr <= 1 - pooling_buf_wr_ctr;    
            
assign  pooling_buf_wr_en = (pooling_buf_wr_ctr == 0)? pooling_enable : 1'd0;
assign  pooling_process_enable = (pooling_buf_wr_ctr == 1) ? pooling_enable : 1'd0;
assign  pooling_buf_rd_en = (pooling_process_enable == 1) && (pooling_process_ctr == 0);
always@(posedge clk)
    if(rst)
        pooling_process_ctr <= 0;
    else
        if(pooling_process_enable)
            pooling_process_ctr <= 1-pooling_process_ctr;
        else
            pooling_process_ctr <= pooling_process_ctr;       

generate
    for(i = 0 ; i < Tm ; i = i + 1) begin:pooling_process_i
        always@(posedge clk)
            if(rst)
                begin
                ;
//                    pooling_temp_3[i] <= 0;
//                    pooling_temp1[i] <= 0;
//                    pooling_temp2[i] <= 0;
//                    pooling_temp3[i] <= 0;
//                    pooling_temp4[i] <= 0;
                end
            else 
                begin
                    if((pooling_process_enable == 1) &&(pooling_process_ctr == 0))
                        begin
                            pooling_temp_3[i] <= pooling_in[i];
                        end
                    else if((pooling_process_enable == 1) &&(pooling_process_ctr == 1))
                        begin
                            {pooling_temp1[i],pooling_temp2[i]} <= pooling_buf_dout[i];
                            pooling_temp3[i] <=  pooling_temp_3[i];
                            pooling_temp4[i] <= pooling_in[i];
                        end
                end    
    end
endgenerate

generate
    for(i = 0 ; i < Tm; i = i + 1) begin:compare_tree_wire_i
        assign compare_tree_wire[i * COMPARE_TREE_CELL + 3] = pooling_temp1[i]; 
        assign compare_tree_wire[i * COMPARE_TREE_CELL + 4] = pooling_temp2[i]; 
        assign compare_tree_wire[i * COMPARE_TREE_CELL + 5] = pooling_temp3[i];
        assign compare_tree_wire[i * COMPARE_TREE_CELL + 6] = pooling_temp4[i];
    end
endgenerate

generate
    for(i = 0 ; i < Tm ; i = i + 1) begin:compare_tree_i
        for(j = COMPARE_TREE_CELL - 1 ; j >= 1;j = j - 2) begin:compare_tree_j
            comparator_unit #(
            .FEATURE_WIDTH(FEATURE_WIDTH)    
        )comparator_tree(
                .clk(clk),
                .rst(rst),
                .data_in_a(compare_tree_wire[i * COMPARE_TREE_CELL  + (j - 1)]),
                .data_in_b(compare_tree_wire[i * COMPARE_TREE_CELL  + j]),
                .data_out(compare_tree_wire[i * COMPARE_TREE_CELL  + ( j / 2 ) - 1])
            );
        end
    end
endgenerate

generate
    for(i = 0; i < Tm; i = i + 1) begin:pooling_out_wire_i
        assign pooling_out[i] = compare_tree_wire[i * COMPARE_TREE_CELL];
    end
endgenerate

generate
    for(i = 0 ; i < Tm ; i = i + 1) begin:feature_out_i
         assign feature_out[i * FEATURE_WIDTH + FEATURE_WIDTH - 1 : i * FEATURE_WIDTH] =  ((ctr_p == 4'b0001) ||(ctr_p == 4'b0010) || (ctr_p == 4'b0110)) ? pooling_out[i] :
                                                                                         ((ctr_p==4'b0111) ? scaler_out[i]:
                                                                                         ((ctr_p==4'b1000) ? function_out[i]:32'dz));
    end
endgenerate

register #(
            .NUM_STAGES(3),
            .DATA_WIDTH(1)
            )data_ready_delay(
            .CLK(clk),
            .RESET(rst),
            .DIN(pooling_process_ctr),
            .DOUT(pooling_data_ready)           
            );
register #(
            .NUM_STAGES(10+8),
            .DATA_WIDTH(1)
            )enable_delay_scaler_out(
            .CLK(clk),
            .RESET(rst),
            .DIN(enable),
            .DOUT(out_valid_scaler_out)           
            );
register #(
            .NUM_STAGES(11+8),
            .DATA_WIDTH(1)
            )enable_delay_function_out(
            .CLK(clk),
            .RESET(rst),
            .DIN(enable),
            .DOUT(out_valid_function_out)           
            );

assign out_valid = ((ctr_p == 4'b0001) ||(ctr_p == 4'b0010)||(ctr_p == 4'b0110)) ? pooling_data_ready :
                   ((ctr_p==4'b0111) ? out_valid_scaler_out :
                   ((ctr_p==4'b1000) ? out_valid_function_out:1'dz)) ;

endmodule