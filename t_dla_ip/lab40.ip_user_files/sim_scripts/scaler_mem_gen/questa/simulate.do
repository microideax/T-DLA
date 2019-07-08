onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib scaler_mem_gen_opt

do {wave.do}

view wave
view structure
view signals

do {scaler_mem_gen.udo}

run -all

quit -force
