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

        
input [11:0] AIN1, BIN1;
input [11:0] AIN2, BIN2;
input [11:0] AIN3, BIN3;
input [11:0] AIN4, BIN4;
input CLK;
input RST;
output [11:0] OUT1,OUT2,OUT3,OUT4;

wire [47:0] POUT_1;


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
     .A({AIN4,AIN3,AIN2[11:6]}),          
     .ACIN(30'b0),    
     .ALUMODE(4'b0000), 
     .B({AIN2[5:0],AIN1[11:0]}),          
     .BCIN(18'b0),    
     .C({BIN4,BIN3,BIN2,BIN1}),          
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


assign OUT1 = POUT_1[11:0];
assign OUT2 = POUT_1[23:12];
assign OUT3 = POUT_1[35:24];
assign OUT4 = POUT_1[47:36];

endmodule

