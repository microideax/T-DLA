onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib var_len_shift_ram_opt

do {wave.do}

view wave
view structure
view signals

do {var_len_shift_ram.udo}

run -all

quit -force
