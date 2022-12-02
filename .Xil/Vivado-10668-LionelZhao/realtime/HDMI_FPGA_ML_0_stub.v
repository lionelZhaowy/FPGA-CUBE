// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "HDMI_FPGA_ML,Vivado 2020.2" *)
module HDMI_FPGA_ML_0(PXLCLK_I, PXLCLK_5X_I, LOCKED_I, RST_N, VGA_HS, 
  VGA_VS, VGA_DE, VGA_RGB, HDMI_CLK_P, HDMI_CLK_N, HDMI_D2_P, HDMI_D2_N, HDMI_D1_P, HDMI_D1_N, 
  HDMI_D0_P, HDMI_D0_N);
  input PXLCLK_I;
  input PXLCLK_5X_I;
  input LOCKED_I;
  input RST_N;
  input VGA_HS;
  input VGA_VS;
  input VGA_DE;
  input [23:0]VGA_RGB;
  output HDMI_CLK_P;
  output HDMI_CLK_N;
  output HDMI_D2_P;
  output HDMI_D2_N;
  output HDMI_D1_P;
  output HDMI_D1_N;
  output HDMI_D0_P;
  output HDMI_D0_N;
endmodule
