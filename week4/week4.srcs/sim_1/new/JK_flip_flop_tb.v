`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/22 02:18:37
// Design Name: 
// Module Name: JK_flip_flop_tb
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


module JK_flip_flop_tb();

reg clk, rst, J, K;
wire Q;

JK_flip_flop FF(clk, rst, J, K, Q);

initial begin
    clk<=0;
    rst<=0;
    #10 rst<=1;
    #10 rst<=0;
    #80 J=0; K=0;
    #100 J=0; K=1;
    #100 J=0; K=0;
    #100 J=1; K=0;
    #100 J=0; K=0;
    #100 J=1; K=1;
    #100 J=0; K=0;
end

always begin
    #5 clk<=~clk;
end

endmodule
