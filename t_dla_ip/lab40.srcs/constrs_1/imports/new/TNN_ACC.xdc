#set_property IOSTANDARD LVCMOS33 [get_ports clk]
#set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
#set_property PACKAGE_PIN W5 [get_ports clk]
#set_property PACKAGE_PIN U18 [get_ports rst_n]

#create_clock -period 8  -waveform {0.000 4} [get_ports clk]
#create_clock -period 4  -waveform {0.000 2} [get_ports fast_clk]

#set_clock_uncertainty 0  
#set_input_delay -clock [get_clocks clk_pin] 0.000 [get_ports rst_n]
#set_input_delay -clock [get_clocks clk_pin] -min -0.500 [get_ports rst]
#set_output_delay -clock [get_clocks clk_pin] 0.000 [get_ports -filter { NAME =~  "*" && DIRECTION == "OUT" }]
#set_output_delay -clock [get_clocks clk_pin] 0.000 [get_ports -filter { NAME =~  "*" && DIRECTION == "OUT" }]
#set_output_delay -clock [get_clocks clk_pin] -add_delay 0.000 [get_ports -filter { NAME =~  "*" && DIRECTION == "OUT" }]
