`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.09.2018 14:31:12
// Design Name: 
// Module Name: adder_unit_by_DSP_pri
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


module adder_unit_by_DSP_pri(CLK, RST,AIN1, BIN1, AIN2, BIN2,AIN3, BIN3, AIN4, BIN4,OUT1,OUT2,OUT3,OUT4);

        
input [7:0] AIN1, BIN1;
input [7:0] AIN2, BIN2;
input [7:0] AIN3, BIN3;
input [7:0] AIN4, BIN4;

//reg [11:0] AIN1_reg,BIN1_reg;
//reg [11:0] AIN2_reg,BIN2_reg;
//reg [11:0] AIN3_reg,BIN3_reg;
//reg [11:0] AIN4_reg,BIN4_reg;

input CLK;
input RST;
output[7:0] OUT1,OUT2,OUT3,OUT4;

wire [47:0] POUT_1;


//always@(posedge CLK)
//    if(RST)
//        begin
//            AIN1_reg <= 0;
//            BIN1_reg <= 0;
//            AIN2_reg <= 0;
//            BIN2_reg <= 0;
//            AIN3_reg <= 0;
//            BIN3_reg <= 0;
//            AIN4_reg <= 0;
//            BIN4_reg <= 0;
//        end
//    else
//        begin
//            AIN1_reg <= AIN1;
//            BIN1_reg <= BIN1;
//            AIN2_reg <= AIN2;
//            BIN2_reg <= BIN2;
//            AIN3_reg <= AIN3;
//            BIN3_reg <= BIN3;
//            AIN4_reg <= AIN4;
//            BIN4_reg <= BIN4;            
//        end


// Instantiation block 1
//
DSP48E1 #(
     .ACASCREG(1),       
     .ALUMODEREG(1),     
     .AREG(1),           
     //.AUTORESET_PATTERN_DETECT("FALSE"), //DSP CHAGNE 1 AUTORESET_PATTERN_DETECT
     //.AUTORESET_PATTERN_DETECT_OPTINV("MATCH"), 
     .A_INPUT("DIRECT"), 
     .BCASCREG(1),       
     .BREG(1),           
     .B_INPUT("DIRECT"), 
     .CARRYINREG(0),     
     .CARRYINSELREG(0),  
     .CREG(1),           
     .MASK(48'h3FFFFFFFFFFF), 
     .MREG(0),           
     //.MULTCARRYINREG(0), 
     .OPMODEREG(0),      
     .PATTERN(48'h000000000000), 
     .PREG(1),           
     .SEL_MASK("MASK"),  
     .SEL_PATTERN("PATTERN"), 
     //.SEL_ROUNDING_MASK("SEL_MASK"),
     .USE_MULT("NONE"), 
     .USE_PATTERN_DETECT("NO_PATDET"), 
     .USE_SIMD("FOUR12") 
  ) 
  DSP48E_1 (
     .ACOUT(),   
     .BCOUT(),  
     .CARRYCASCOUT(), 
     .CARRYOUT(), 
     .MULTSIGNOUT(), 
     .OVERFLOW(), 
    // .INMODE(5'b10001),
     .P(POUT_1),          
     .PATTERNBDETECT(), 
     .PATTERNDETECT(), 
     .PCOUT(),  
     .UNDERFLOW(), 
     .A({4'd0,AIN4,4'd0,AIN3,4'd0,AIN2[7:6]}),          
     .ACIN(30'b0),    
     .ALUMODE(4'b0000), 
     .B({AIN2[5:0],4'd0,AIN1[7:0]}),          
     .BCIN(18'b0),    
     .C({4'd0,BIN4,4'd0,BIN3,4'd0,BIN2,4'd0,BIN1}),          
     .CARRYCASCIN(1'b0), 
     .CARRYIN(1'b0), 
     .CARRYINSEL(3'b0), 
     .CEA1(1'b0),      
     .CEA2(1'b1),      
     .CEALUMODE(1'b1), 
     .CEB1(1'b0),      
     .CEB2(1'b1),      
     .CEC(1'b1),      
     .CECARRYIN(1'b0), 
     .CECTRL(1'b1), 
     .CEM(1'b0),       
     //DSP1 change.CEMULTCARRYIN(1'b0),
     .CEP(1'b1),       
     .CLK(CLK),       
     .MULTSIGNIN(1'b0), 
     .OPMODE(7'b0110011), 
     .PCIN(48'b0),      
     .RSTA(RST),     
     .RSTALLCARRYIN(RST), 
     .RSTALUMODE(RST), 
     .RSTB(RST),     
     .RSTC(RST),     
     .RSTCTRL(RST), 
     .RSTM(RST), 
     .RSTP(RST) 
  );

// End of DSP48E_1 instantiation



//always@(posedge CLK)
//    if(RST)
//        begin
//            OUT1 <= 0;
//            OUT2 <= 0;
//            OUT3 <= 0;
//            OUT4 <= 0;
//        end
//    else
//        begin
//            OUT1 <= POUT_1[7:0];
//            OUT2 <= POUT_1[19:12];
//            OUT3 <= POUT_1[31:24];
//            OUT4 <= POUT_1[43:36];
//        end
assign OUT1 = POUT_1[7:0];
assign OUT2 = POUT_1[19:12];
assign OUT3 = POUT_1[31:24];
assign OUT4 = POUT_1[43:36];

endmodule

