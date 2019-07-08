onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib i_memory_gen_opt

do {wave.do}

view wave
view structure
view signals

do {i_memory_gen.udo}

run -all

quit -force
