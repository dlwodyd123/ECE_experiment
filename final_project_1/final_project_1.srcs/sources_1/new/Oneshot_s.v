`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/09 13:30:49
// Design Name: 
// Module Name: Oneshot_s
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


module Oneshot_s(clk, rst, s, s_trig);

input clk, rst;
input [4:0] s;

reg T;
reg T_reg1;
reg T_reg2;

output reg s_trig;

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        T <= 0;
        T_reg1 <= 0;
        T_reg2 <= 0;
        s_trig <= 0;
    end
    else begin
        if(s == 5'b00000) begin
            T <= 1;
            T_reg1 <= T;
            T_reg2 <= T_reg1;
            s_trig <= T_reg1 & ~T_reg2;
        end
        else begin
            T <= 0;
            T_reg1 <= T;
            T_reg2 <= T_reg1;
        end
    end
end

endmodule
