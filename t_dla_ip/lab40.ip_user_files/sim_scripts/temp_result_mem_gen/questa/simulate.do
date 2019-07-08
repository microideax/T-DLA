onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib temp_result_mem_gen_opt

do {wave.do}

view wave
view structure
view signals

do {temp_result_mem_gen.udo}

run -all

quit -force
