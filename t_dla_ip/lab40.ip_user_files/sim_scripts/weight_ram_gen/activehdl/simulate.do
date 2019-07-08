onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+weight_ram_gen -L xil_defaultlib -L xpm -L blk_mem_gen_v8_4_1 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.weight_ram_gen xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {weight_ram_gen.udo}

run -all

endsim

quit -force
