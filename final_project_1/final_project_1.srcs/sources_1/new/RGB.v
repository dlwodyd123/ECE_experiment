`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/09 13:32:14
// Design Name: 
// Module Name: RGB
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


module RGB(clk, rst, state1, R, G, B);

input clk, rst;
input [2:0] state1;

output reg [3:0] R;
output reg [3:0] G;
output reg [3:0] B;

reg [17:0] state;
parameter red       ={6'd63 ,  6'd0  ,  6'd0}; 
parameter orange    ={6'd63 ,  6'd25 ,  6'd0}; 
parameter yellow    ={6'd63 ,  6'd63 ,  6'd0}; 
parameter green     ={6'd0  ,  6'd63 ,  6'd0}; 
parameter blue      ={6'd0  ,  6'd0  ,  6'd63}; 
parameter indigo    ={6'd0  ,  6'd0  ,  6'd32}; 
parameter purple    ={6'd32 ,  6'd0  ,  6'd32};

reg [2:0] state_color;
parameter RED = 3'b000,
          ORANGE = 3'b001,
          YELLOW = 3'b010,
          GREEN = 3'b011,
          BLUE = 3'b100,
          INDIGO = 3'b101,
          PURPLE = 3'b110,
          EMERGENCY = 3'b111;

reg [5:0] cnt;
reg [19:0] cnt_emr_500ms;
reg [19:0] cnt_emr_1s;

integer y;
integer z;

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        cnt <= 0;
        cnt_emr_500ms <= 0;
        cnt_emr_1s <= 0;
        y <= 0;
        z <= 0;
    end
    else begin
        cnt <= cnt + 1;
        if(state1 == 3'b100) begin
            cnt <= 0;
            cnt_emr_500ms <= cnt_emr_500ms + 1;
            cnt_emr_1s <= cnt_emr_1s + 1;
                if(cnt_emr_500ms == 4999) begin
                    cnt_emr_500ms <= 0;
                    y <= y + 1;
                        if(y == 29) y <= 0;
                end
                if(cnt_emr_1s == 9999) begin
                    cnt_emr_1s <= 0;
                    z <= z + 1;
                        if(z == 14) z <= 0;
                end
        end
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        state <= red;
        state_color <= RED;
    end
    else begin
        if(state1 == 3'b100) state_color <= EMERGENCY;
        
        case(state_color)
            EMERGENCY : begin
                if(state1 == 3'b100) begin
                    if(z*2 == y) state <= red;
                    else state <= {6'd0, 6'd0, 6'd0};
                end
                else begin
                    state <= red;
                    state_color <= RED;
                end
            end
            RED : begin
                if(cnt==6'b111_111) state[11:6] <= state[11:6] + 1;
                else if(state[11:6]==6'b011_001) state_color <= ORANGE;
            end    
            ORANGE : begin
                if(cnt==6'b111_111) state[11:6] <= state[11:6] + 1;
                else if(state[11:6]>=6'b111_111) state_color <= YELLOW;
            end
            YELLOW : begin
                if(cnt==6'b111_111) state[17:12] <= state[17:12] - 1;
                else if(state[17:12]==6'b000_000) state_color <= GREEN;
            end
            GREEN : begin
                if(cnt==6'b111_111) begin
                    state[11:6] <= state[11:6] - 1; 
                    state[5:0] <= state[5:0] + 1;
                end
                else if(state[11:6]==6'b000_000) state_color <= BLUE;
            end
            BLUE : begin
                if(cnt==6'b111_111) state[5:0] <= state[5:0] - 1;
                else if(state[5:0]==6'b100_000) state_color <= INDIGO;
            end
            INDIGO : begin
                if(cnt==6'b111_111) state[17:12] <= state[17:12] + 1;
                else if(state[17:12]==6'b100_000) state_color <= PURPLE;
            end
            PURPLE : begin
                if(cnt==6'b111_111) begin
                    state[17:12] <= state[17:12] + 1;
                    state[5:0] <= state[5:0] - 1;
                end
                else if(state[17:12]==6'b111_111) begin
                    state_color <= RED;
                    state <= red;
                end
            end
        endcase
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        R <= 4'b0000;
        G <= 4'b0000;
        B <= 4'b0000;
    end
    else begin
        if(cnt<state[17:12]) R<= 4'b1111;
        else R<= 4'b0000;
        
        if(cnt<state[11:6]) G<= 4'b1111;
        else G<= 4'b0000;
        
        if(cnt<state[5:0]) B<= 4'b1111;
        else B<= 4'b0000;
    end
end

endmodule
