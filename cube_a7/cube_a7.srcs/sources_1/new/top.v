`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/07 17:16:23
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input clk,
    input rst_n,
    input [1:0]rotate_mode,//00->顺90度,01->180度,11->逆90度
    input [5:0]key_n,
    output HDMI_CLK_P,
    output HDMI_CLK_N,
    output HDMI_D2_P,
    output HDMI_D2_N,
    output HDMI_D1_P,
    output HDMI_D1_N,
    output HDMI_D0_P,
    output HDMI_D0_N
    );
    wire [4:0]KEY_Value;
    //模块实例化
    cube_ctrl C_C(
        .clk(pixclk),
        .rst_n(rst_n),
        .rotate_mode(rotate_mode),
        .key_n(key_n),
        .KEY_Value(KEY_Value)
    );
    HDMI_display H_D(
        .clk_100M(clk),
        .rst_n(rst_n),
        .KEY_Value(KEY_Value),
        .HDMI_CLK_P(HDMI_CLK_P),
        .HDMI_CLK_N(HDMI_CLK_N),
        .HDMI_D2_P(HDMI_D2_P),
        .HDMI_D2_N(HDMI_D2_N),
        .HDMI_D1_P(HDMI_D1_P),
        .HDMI_D1_N(HDMI_D1_N),
        .HDMI_D0_P(HDMI_D0_P),
        .HDMI_D0_N(HDMI_D0_N),
        .pixclk(pixclk)
);
endmodule

