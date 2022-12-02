onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib HDMI_FPGA_ML_0_opt

do {wave.do}

view wave
view structure
view signals

do {HDMI_FPGA_ML_0.udo}

run -all

quit -force
