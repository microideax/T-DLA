


// Re-customize supported parameters
`define Tm                              8
`define Tn                              4
`define FEATURE_WIDTH                   12
`define BIAS_WIDTH                      12
`define SCALER_WIDTH                    12
`define KERNEL_WIDTH                    2
`define KERNEL_SIZE                     5

// Unsupported parameters -- fixed to exact number

`define FEATURE_IN_MEM_READ_WIDTH_COF   8
`define WEIGHT_MEM_READ_WIDTH_COF       2




//`define cpu_width Tm*Scaler*