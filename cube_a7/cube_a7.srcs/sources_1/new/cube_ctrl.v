module cube_ctrl(
    input clk,
    input rst_n,
    input [1:0]rotate_mode,//00->顺90度,01->180度,11->逆90度
    input [5:0]key_n,
    output reg[4:0]KEY_Value
    );
    wire [5:0]KEY_STATE,KEY_FLAG;
    //模块例化
    KeyPress k0(
        .clk(clk),
        .rst_n(rst_n),
        .KEY_IN(key_n[0]),
        .KEY_FLAG(KEY_FLAG[0]),
        .KEY_STATE(KEY_STATE[0])
    );
    KeyPress k1(
        .clk(clk),
        .rst_n(rst_n),
        .KEY_IN(key_n[1]),
        .KEY_FLAG(KEY_FLAG[1]),
        .KEY_STATE(KEY_STATE[1])
    );
    KeyPress k2(
        .clk(clk),
        .rst_n(rst_n),
        .KEY_IN(key_n[2]),
        .KEY_FLAG(KEY_FLAG[2]),
        .KEY_STATE(KEY_STATE[2])
    );
    KeyPress k3(
        .clk(clk),
        .rst_n(rst_n),
        .KEY_IN(key_n[3]),
        .KEY_FLAG(KEY_FLAG[3]),
        .KEY_STATE(KEY_STATE[3])
    );
    KeyPress k4(
        .clk(clk),
        .rst_n(rst_n),
        .KEY_IN(key_n[4]),
        .KEY_FLAG(KEY_FLAG[4]),
        .KEY_STATE(KEY_STATE[4])
    );
    KeyPress k5(
        .clk(clk),
        .rst_n(rst_n),
        .KEY_IN(key_n[5]),
        .KEY_FLAG(KEY_FLAG[5]),
        .KEY_STATE(KEY_STATE[5])
    );
    //KEY_VALUE译码
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            KEY_Value <= 5'd18;
        end
        else if(KEY_FLAG != 6'b000000)begin
            case({rotate_mode,KEY_STATE})
                8'b00_111110:KEY_Value <= 5'd0; //U
                8'b00_111101:KEY_Value <= 5'd1; //D
                8'b00_111011:KEY_Value <= 5'd2; //F
                8'b00_110111:KEY_Value <= 5'd3; //B
                8'b00_101111:KEY_Value <= 5'd4; //L
                8'b00_011111:KEY_Value <= 5'd5; //R
                
                8'b01_111110:KEY_Value <= 5'd6; //2U
                8'b01_111101:KEY_Value <= 5'd7; //2D
                8'b01_111011:KEY_Value <= 5'd8; //2F
                8'b01_110111:KEY_Value <= 5'd9; //2B
                8'b01_101111:KEY_Value <= 5'd10;//2L
                8'b01_011111:KEY_Value <= 5'd11;//2R
                
                8'b11_111110:KEY_Value <= 5'd12;//U'
                8'b11_111101:KEY_Value <= 5'd13;//D'
                8'b11_111011:KEY_Value <= 5'd14;//F'
                8'b11_110111:KEY_Value <= 5'd15;//B'
                8'b11_101111:KEY_Value <= 5'd16;//L'
                8'b11_011111:KEY_Value <= 5'd17;//R'
                
                default:KEY_Value <= 5'd18;
            endcase
        end
        else begin
            KEY_Value <= 5'd18;
        end
    end
endmodule