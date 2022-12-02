`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/01 11:01:58
// Design Name: 
// Module Name: hdmi_data_gen
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

module hdmi_data_gen
	(
    // input clk,
    input rst_n,
	input pix_clk,
    input [4:0]KEY_Value,//矩阵键盘控制转动
	output [7:0]VGA_R,
	output [7:0]VGA_G,
	output [7:0]VGA_B,
	output VGA_HS,
	output VGA_VS,
	output VGA_DE
	);
    /*-------------------3bit色彩编码转RGB888编码---------------------*/
    function [23:0]color_rgb(
        input [2:0]code
        );
        //RGB色彩编码
        parameter WHITE = 24'hFFFFFF;
        parameter GREEN = 24'h008000;
        parameter ORANGE= 24'hFFA500;
        parameter BLUE  = 24'h0000FF;
        parameter RED   = 24'hFF0000;
        parameter YELLOW= 24'hFFFF00;
        parameter BLACK = 24'h000000;
        //编码转化
        case(code)
            3'b000: color_rgb = WHITE;
            3'b001: color_rgb = GREEN;
            3'b010: color_rgb = ORANGE;
            3'b011: color_rgb = BLUE;
            3'b100: color_rgb = RED;
            3'b101: color_rgb = YELLOW;
            default:color_rgb = BLACK;
        endcase
    endfunction
    //---------------------------------//
    // 水平扫描参数的设定1280*720  60HZ
    //--------------------------------//
    parameter H_Total		=	1680;//e
    parameter H_Sync		=	136; //a
    parameter H_Back		=	200; //b
    parameter H_Active		=	1280;//c
    parameter H_Front		=	64;  //d
    parameter H_Start		=	336;
    parameter H_End			=	1616;
    //-------------------------------//
    // 垂直扫描参数的设定1280*720	60HZ  	
    //-------------------------------//
    parameter V_Total		=	828;
    parameter V_Sync		=	3;
    parameter V_Back		=	24;
    parameter V_Active		=	800;
    parameter V_Front		=	1;
    parameter V_Start		=	27;
    parameter V_End			=	827;
    //行同步信号发生器
    reg[11:0]	x_cnt;
    always @(posedge pix_clk)
    begin
        if(x_cnt == H_Total)
            x_cnt <= 1;
        else
            x_cnt <= x_cnt + 1;
    end
    //场同步信号发生器
    reg[11:0]	y_cnt;
    always @(posedge pix_clk)
    begin
        if(y_cnt == V_Total)
            y_cnt <= 1;
        else if(x_cnt == H_Total)
            y_cnt <= y_cnt + 1;
    end
    
    reg [10:0]cur_x;
    reg [10:0]cur_y;
    
    always @(posedge pix_clk) begin
    cur_x <= (x_cnt < H_Sync + H_Back) ? 11'b0 : (x_cnt - H_Sync - H_Back);
    cur_y <= (y_cnt < V_Sync + V_Back) ? 11'b0 : (y_cnt - V_Sync - V_Back);
    end
    
    wire  hs_de = (x_cnt<H_Start)? 0:(x_cnt<=H_End)?1:0;//行消隐控制
    wire  vs_de = (y_cnt<V_Start)? 0:(y_cnt<=V_End)?1:0;//列消隐控制
    /*------------------------------虚拟魔方模块实例化----------------------------*/
    wire [2:0]cube[0:5][0:8];
    CUBE Cube(
        .clk(pix_clk),
        .rst_n(rst_n),
        .KEY_Value(KEY_Value),//矩阵键盘控制转动
        .cube_state({
            cube[5][8],cube[5][7],cube[5][6],cube[5][5],cube[5][4],cube[5][3],cube[5][2],cube[5][1],cube[5][0],//B
            cube[4][8],cube[4][7],cube[4][6],cube[4][5],cube[4][4],cube[4][3],cube[4][2],cube[4][1],cube[4][0],//D
            cube[3][8],cube[3][7],cube[3][6],cube[3][5],cube[3][4],cube[3][3],cube[3][2],cube[3][1],cube[3][0],//R
            cube[2][8],cube[2][7],cube[2][6],cube[2][5],cube[2][4],cube[2][3],cube[2][2],cube[2][1],cube[2][0],//F
            cube[1][8],cube[1][7],cube[1][6],cube[1][5],cube[1][4],cube[1][3],cube[1][2],cube[1][1],cube[1][0],//L
            cube[0][8],cube[0][7],cube[0][6],cube[0][5],cube[0][4],cube[0][3],cube[0][2],cube[0][1],cube[0][0] //U
            })//魔方状态:6*9*3
    );
    //寄存RGB颜色编码
    reg [7:0]O_red, O_green, O_blue;
    
    // 功能：画出魔方展开图和立体图1024*768---------------------------------
    parameter FLAT_LX     =   11'd906;//650;
    parameter FLAT_UY     =   11'd430;
    parameter BLOCK_SIZ   =   11'd25;
    parameter FACE_SIZ    =   11'd75;
    parameter FACE_SIZ_2  =   11'd150;
    parameter FACE_SIZ_3  =   11'd225;
    parameter FACE_SIZ_4  =   11'd300;
    parameter EDGE_COL    =   24'h73E68C;//灰边
    parameter FLAT_BGC    =   24'h000000;//黑色背景

    parameter REAL_LX     =   11'd356;
    parameter REAL_UY     =   11'd200;
    parameter REAL_SZ     =   11'd40;
    parameter REAL_SZ_2   =   2*REAL_SZ;
    parameter REAL_SZ_3   =   3*REAL_SZ;
    parameter REAL_SZ_4   =   4*REAL_SZ;
    parameter REAL_SZ_5   =   5*REAL_SZ;
    parameter REAL_SZ_6   =   6*REAL_SZ;
    parameter REAL_SZ_7   =   7*REAL_SZ;
    parameter REAL_SZ_8   =   8*REAL_SZ;
    parameter REAL_SZ_9   =   9*REAL_SZ;
    parameter REAL_SZ_11  =   11*REAL_SZ;
    parameter REAL_SZ_13  =   13*REAL_SZ;
    parameter REAL_SZ_15  =   15*REAL_SZ;
    parameter REAL_BGC    =   24'h000000;//黑色背景

    wire [10:0]tmp_rx;
    wire [10:0]tmp_ry;
    wire [10:0]tmp_rxy;
    assign tmp_rx   = cur_x - REAL_LX;
    assign tmp_ry   = cur_y - REAL_UY;
    assign tmp_rxy  = cur_x + cur_y - REAL_LX - REAL_UY;

    always @(posedge pix_clk) begin
        // 展开图
        if (cur_x >= FLAT_LX && cur_y >= FLAT_UY) begin
            // 大边框-行
            if (cur_y == (FLAT_UY) || cur_y == (FLAT_UY + FACE_SIZ_3) || cur_y == (FLAT_UY + FACE_SIZ_4)) begin
                {O_red, O_green, O_blue} <= (((cur_x >= FLAT_LX + FACE_SIZ) && (cur_x <= FLAT_LX + FACE_SIZ_2)) ? EDGE_COL : FLAT_BGC);    
            end
            else if (cur_y == (FLAT_UY + FACE_SIZ) || cur_y == (FLAT_UY + FACE_SIZ_2)) begin
                {O_red, O_green, O_blue} <= (((cur_x <= FLAT_LX + FACE_SIZ_3)) ? EDGE_COL : FLAT_BGC);
            end
            // 大边框-列
            else if (cur_x == (FLAT_LX) || cur_x == (FLAT_LX + FACE_SIZ_3)) begin
                {O_red, O_green, O_blue} <= (((cur_y >= FLAT_UY + FACE_SIZ) && (cur_y <= FLAT_UY + FACE_SIZ_2)) ? EDGE_COL : FLAT_BGC);
            end
            else if (cur_x == (FLAT_LX + FACE_SIZ) || cur_x == (FLAT_LX + FACE_SIZ_2)) begin
                {O_red, O_green, O_blue} <= (((cur_y <= FLAT_UY + FACE_SIZ_4)) ? EDGE_COL : FLAT_BGC);
            end
            // 内颜色
            else if (cur_y < FLAT_UY + FACE_SIZ) begin
                if (cur_x > FLAT_LX + FACE_SIZ && cur_x < FLAT_LX + FACE_SIZ_2) begin
                    {O_red, O_green, O_blue} <= color_rgb(cube[0][( (cur_x-(FLAT_LX+FACE_SIZ))/BLOCK_SIZ + (cur_y-(FLAT_UY))/BLOCK_SIZ*3 )]);//U
                end
                else begin
                    {O_red, O_green, O_blue} <= FLAT_BGC;
                end
            end
            else if (cur_y < FLAT_UY + FACE_SIZ_2) begin
                if (cur_x < FLAT_LX + FACE_SIZ) begin
                    {O_red, O_green, O_blue} <= color_rgb(cube[1][( (cur_x-(FLAT_LX))/BLOCK_SIZ + (cur_y-(FLAT_UY+FACE_SIZ))/BLOCK_SIZ*3 )]);//L
                end
                else if (cur_x < FLAT_LX + FACE_SIZ_2) begin
                    {O_red, O_green, O_blue} <= color_rgb(cube[2][( (cur_x-(FLAT_LX+FACE_SIZ))/BLOCK_SIZ + (cur_y-(FLAT_UY+FACE_SIZ))/BLOCK_SIZ*3 )]);//F
                end
                else if (cur_x < FLAT_LX + FACE_SIZ_3) begin
                    {O_red, O_green, O_blue} <= color_rgb(cube[3][( (cur_x-(FLAT_LX+FACE_SIZ_2))/BLOCK_SIZ + (cur_y-(FLAT_UY+FACE_SIZ))/BLOCK_SIZ*3 )]);//R
                end
                else begin
                    {O_red, O_green, O_blue} <= FLAT_BGC;
                end
            end
            else if (cur_y < FLAT_UY + FACE_SIZ_3) begin
                if (cur_x > FLAT_LX + FACE_SIZ && cur_x < FLAT_LX + FACE_SIZ_2) begin
                    {O_red, O_green, O_blue} <= color_rgb(cube[4][( (cur_x-(FLAT_LX+FACE_SIZ))/BLOCK_SIZ + (cur_y-(FLAT_UY+FACE_SIZ_2))/BLOCK_SIZ*3 )]);//D
                end
                else begin
                    {O_red, O_green, O_blue} <= FLAT_BGC;
                end        
            end
            else if (cur_y < FLAT_UY + FACE_SIZ_4) begin
                if (cur_x > FLAT_LX + FACE_SIZ && cur_x < FLAT_LX + FACE_SIZ_2) begin
                    {O_red, O_green, O_blue} <= color_rgb(cube[5][( (cur_x-(FLAT_LX+FACE_SIZ))/BLOCK_SIZ + (cur_y-(FLAT_UY+FACE_SIZ_3))/BLOCK_SIZ*3 )]);//B
                end
                else begin
                    {O_red, O_green, O_blue} <= FLAT_BGC;
                end        
            end
            else begin
                {O_red, O_green, O_blue} <= FLAT_BGC;
            end
        end
        
        // 立体图
        else if (cur_x >= REAL_LX && cur_x <= REAL_LX+REAL_SZ_9 && cur_y >= REAL_UY && cur_y <= REAL_UY+REAL_SZ_9) begin
            if (
                ((tmp_rx == 0 || tmp_rx == REAL_SZ_2 || tmp_rx == REAL_SZ_4 || tmp_rx == REAL_SZ_6) && tmp_ry >= REAL_SZ_3) ||
                ((tmp_rx == REAL_SZ_7 || tmp_rx == REAL_SZ_8 || tmp_rx == REAL_SZ_9) && tmp_rxy >= REAL_SZ_9 && tmp_rxy <= REAL_SZ_15) ||
                ((tmp_ry == 0 || tmp_ry == REAL_SZ || tmp_ry == REAL_SZ_2 || tmp_ry == REAL_SZ_3) && tmp_rxy >= REAL_SZ_3 && tmp_rxy <= REAL_SZ_9) ||
                ((tmp_ry == REAL_SZ_5 || tmp_ry == REAL_SZ_7 || tmp_ry == REAL_SZ_9) && tmp_rx <= REAL_SZ_6) ||
                ((tmp_rxy == REAL_SZ_3 || tmp_rxy == REAL_SZ_5 || tmp_rxy == REAL_SZ_7 || tmp_rxy == REAL_SZ_9) && tmp_ry <= REAL_SZ_3) ||
                ((tmp_rxy == REAL_SZ_11 || tmp_rxy == REAL_SZ_13 || tmp_rxy == REAL_SZ_15) && tmp_rx >= REAL_SZ_6)
            ) begin
                {O_red, O_green, O_blue} <= EDGE_COL;
            end
            else if (tmp_ry < REAL_SZ_3) begin
                if (tmp_rxy < REAL_SZ_3) begin
                    {O_red, O_green, O_blue} <= REAL_BGC;
                end
                else if (tmp_rxy < REAL_SZ_9) begin
                    {O_red, O_green, O_blue} <= color_rgb(cube[0][ (tmp_rxy-REAL_SZ_3)/REAL_SZ_2 + (tmp_ry/REAL_SZ)*3 ]);//U
                end
                else begin
                    {O_red, O_green, O_blue} <= color_rgb(cube[3][ (tmp_rx-REAL_SZ_6)/REAL_SZ + (tmp_rxy - REAL_SZ_9)/REAL_SZ_2*3 ]);//R
                end
            end
            else begin
                if (tmp_rx < REAL_SZ_6) begin
                    {O_red, O_green, O_blue} <= color_rgb(cube[2][ (tmp_rx)/REAL_SZ_2 + (tmp_ry-REAL_SZ_3)/REAL_SZ_2*3 ]);//F
                end
                else if (tmp_rxy < REAL_SZ_15) begin
                    {O_red, O_green, O_blue} <= color_rgb(cube[3][ (tmp_rx-REAL_SZ_6)/REAL_SZ + (tmp_rxy - REAL_SZ_9)/REAL_SZ_2*3 ]);//R
                    {O_red, O_green, O_blue} <= color_rgb(cube[3][ (tmp_rx-REAL_SZ_6)/REAL_SZ + (tmp_rxy - REAL_SZ_9)/REAL_SZ_2*3 ]);//R
                end
                else begin
                    {O_red, O_green, O_blue} <= REAL_BGC;
                end
            end
        end
        else begin
            {O_red, O_green, O_blue} <= REAL_BGC;
        end
    end

    // 功能：画出魔方展开图和立体图-----------------------------------------

    assign VGA_HS = (x_cnt==12'd0)? 1:(x_cnt<H_Sync)? 0 : 1;
    assign VGA_VS = (y_cnt==12'd0)? 1:(y_cnt<V_Sync)? 0 : 1;

    assign VGA_DE = hs_de &	vs_de;
    assign VGA_R  = (hs_de & vs_de) ? O_red  : 8'h0;
    assign VGA_G  = (hs_de & vs_de) ? O_green: 8'h0;
    assign VGA_B  = (hs_de & vs_de) ? O_blue : 8'h0;

endmodule
