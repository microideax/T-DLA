onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+pooling_buf_by_fifo_gen -L xil_defaultlib -L xpm -L fifo_generator_v13_2_2 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.pooling_buf_by_fifo_gen xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {pooling_buf_by_fifo_gen.udo}

run -all

endsim

quit -force
