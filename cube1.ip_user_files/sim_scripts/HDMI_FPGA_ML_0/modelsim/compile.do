vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vcom -work xil_defaultlib  -93 \
"../../../ipstatic/src/TMDSEncoder.vhd" \
"../../../ipstatic/src/SerializerN_1.vhd" \
"../../../ipstatic/src/DVITransmitter.vhd" \
"../../../ipstatic/src/hdmi_tx.vhd" \
"../../../../cube1.gen/sources_1/ip/HDMI_FPGA_ML_0/sim/HDMI_FPGA_ML_0.vhd" \


