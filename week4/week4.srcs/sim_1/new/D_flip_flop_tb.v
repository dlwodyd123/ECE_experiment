`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/22 02:16:17
// Design Name: 
// Module Name: D_flip_flop_tb
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


module D_flip_flop_tb();

reg clk, D;
wire Q;

D_flip_flop FF(clk, D, Q);

initial begin
    clk<=0;
    #50 D<=0;
    #50 D<=1;
    #50 D<=0;
    #50 D<=1;
    #50 D<=0;
    #50 D<=1;
    #50 D<=0;
end

always begin
    #5 clk<=~clk;
end

endmodule
