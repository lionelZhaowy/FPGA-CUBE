`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/01 21:32:03
// Design Name: 
// Module Name: color_encoder
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


module color_encoder(
    input [2:0]code,
    output reg[23:0]color_rgb
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
    always(*)begin
        case(code)
            3'b000:color_rgb = WHITE;
            3'b001:color_rgb = GREEN;
            3'b010:color_rgb = ORANGE;
            3'b011:color_rgb = BLUE;
            3'b100:color_rgb = RED;
            3'b101:color_rgb = YELLOW;
            default:color_rgb = BLACK;
        endcase
    end
endmodule
