`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/13 21:58:52
// Design Name: 
// Module Name: KeyPress
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


module KeyPress(
	input clk,
	input rst_n,
	input KEY_IN,
	output reg KEY_FLAG,
	output reg KEY_STATE
);
	reg key_reg_0, key_reg_1;//打两拍异步转同步
	reg en_cnt, cnt_full;
	reg [3:0]state;
	reg [19:0]cnt;
	wire flag_H2L, flag_L2H;
	
	localparam
		Key_up			=	4'b0001,
		Filter_Up2Down	=	4'b0010,
		Key_down		=	4'b0100,
		Filter_Down2Up	=	4'b1000;
		
	//======判断按键输入信号跳变沿========//
	always @(posedge clk or negedge rst_n)
		if(!rst_n)
			begin
				key_reg_0 <= 1'b0;
				key_reg_1 <= 1'b0;
			end
		else
			begin
				key_reg_0 <= KEY_IN;
				key_reg_1 <= key_reg_0;
			end
	assign flag_H2L = key_reg_1 && (!key_reg_0);
	assign flag_L2H = (!key_reg_1) && key_reg_0;
	
	//============计数使能模块==========//
	always @(posedge clk or negedge rst_n)
		if(!rst_n)
			cnt <= 1'b0;
		else if(en_cnt)
			cnt <= cnt + 1'b1;
		else
			cnt <= 1'b0;
			
	//=============计数模块=============//
	always @(posedge clk or negedge rst_n)
		if(!rst_n)
			cnt_full <= 1'b0;
		else if(cnt == 20'd999_999)
			cnt_full <= 1'b1;
		else
			cnt_full <= 1'b0;
	
	//=============有限状态机============//
	always @(posedge clk or negedge rst_n)
		if(!rst_n)
			begin
				en_cnt <= 1'b0;
				state <= Key_up;
				KEY_FLAG <= 1'b0;
				KEY_STATE <= 1'b1;
			end
		else
			case(state)
				//保持没按
				Key_up: begin 
					KEY_FLAG <= 1'b0;
					if(flag_H2L) begin
						state <= Filter_Up2Down;
						en_cnt <= 1'b1;
					end
					else
						state <= Key_up;							
				end
				//正在向下按	
				Filter_Up2Down: begin
					if(cnt_full) begin
						en_cnt <= 1'b0;
						state <= Key_down;
						KEY_STATE <= 1'b0;
						KEY_FLAG <= 1'b1;
					end
					else if(flag_L2H) begin
						en_cnt <= 1'b0;
						state <= Key_up;
					end
					else
						state <= Filter_Up2Down;
				end
				//保持按下状态
				Key_down: begin
					KEY_FLAG <= 1'b0;
					if(flag_L2H) begin
						state <= Filter_Down2Up;
						en_cnt <= 1'b1;
					end
					else 
						state <= Key_down;
				end
				//正在释放按键
				Filter_Down2Up: begin
					if(cnt_full) begin
						en_cnt <= 1'b0;
						state <= Key_up;
						KEY_FLAG <= 1'b1;
						KEY_STATE <= 1'b1;
					end
					else if(flag_H2L) begin
						en_cnt <= 1'b0;
						state <= Key_down;
					end						
					else
						state <= Filter_Down2Up;
				end
				//其他未定义状态
				default: begin
					en_cnt <= 1'b0;
					state <= Key_up;
					KEY_FLAG <= 1'b0;
					KEY_STATE <= 1'b1;
				end
			endcase	
            
endmodule