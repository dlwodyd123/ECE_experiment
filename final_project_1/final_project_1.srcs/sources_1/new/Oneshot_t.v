`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/09 13:31:11
// Design Name: 
// Module Name: Oneshot_t
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


module Oneshot_t(clk, rst, t, state1, T_trig, T0_trig);

input clk, rst;
input [4:0] t;
input [2:0] state1;

reg R;
reg R_reg;
reg K;
reg K_reg;

output reg T_trig;
output reg T0_trig;

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        R <= 0;
        R_reg <= 0;
        K <= 0;
        K_reg <= 0;
        T_trig <= 0;
        T0_trig <= 0;
    end
    else begin
        if(t==5'b00000 && state1==3'b100) begin
            R = 1;
            R_reg <= R;
            T_trig <= R & ~R_reg;
        end
        else if(t==5'b11110 && state1==3'b100)begin
            K = 1;
            K_reg <= K;
            T0_trig <= K & ~K_reg;
        end
        else if(t == 5'b00001) begin
            R <= 0;
            R_reg <= R;
            K <= 0;
            K_reg <= K;
        end
    end
end

endmodule
