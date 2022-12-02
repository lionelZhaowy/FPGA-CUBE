set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]

set_property IOSTANDARD LVCMOS33 [get_ports {key_n[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {key_n[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {key_n[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {key_n[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {key_n[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {key_n[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {rotate_mode[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rotate_mode[0]}]

set_property PACKAGE_PIN K17 [get_ports clk]
set_property PACKAGE_PIN T16 [get_ports rst_n]

set_property PACKAGE_PIN V12 [get_ports {key_n[5]}]
set_property PACKAGE_PIN W16 [get_ports {key_n[4]}]
set_property PACKAGE_PIN J15 [get_ports {key_n[3]}]
set_property PACKAGE_PIN V13 [get_ports {key_n[2]}]
set_property PACKAGE_PIN U17 [get_ports {key_n[1]}]
set_property PACKAGE_PIN T17 [get_ports {key_n[0]}]

set_property PACKAGE_PIN P15 [get_ports {rotate_mode[1]}]
set_property PACKAGE_PIN G15 [get_ports {rotate_mode[0]}]

set_property -dict {PACKAGE_PIN H17 IOSTANDARD TMDS_33} [get_ports HDMI_CLK_N]
set_property -dict {PACKAGE_PIN H16 IOSTANDARD TMDS_33} [get_ports HDMI_CLK_P]
set_property -dict {PACKAGE_PIN D20 IOSTANDARD TMDS_33} [get_ports HDMI_D0_N]
set_property -dict {PACKAGE_PIN D19 IOSTANDARD TMDS_33} [get_ports HDMI_D0_P]
set_property -dict {PACKAGE_PIN B20 IOSTANDARD TMDS_33} [get_ports HDMI_D1_N]
set_property -dict {PACKAGE_PIN C20 IOSTANDARD TMDS_33} [get_ports HDMI_D1_P]
set_property -dict {PACKAGE_PIN A20 IOSTANDARD TMDS_33} [get_ports HDMI_D2_N]
set_property -dict {PACKAGE_PIN B19 IOSTANDARD TMDS_33} [get_ports HDMI_D2_P]
