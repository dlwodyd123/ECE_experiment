`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/22 02:17:24
// Design Name: 
// Module Name: JK_flip_flop
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


module JK_flip_flop(clk,rst,J,K,Q);

input J,K,clk,rst;
output reg Q;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        Q<=1'b0;
    end 
    else begin
        if (J&~K) begin
            Q<=1'b1;
            end
        else if (~J&K) begin
            Q<=1'b0;
            end
        else if (J&K) begin
            Q<=~Q;
            end
        end
end
 
endmodule
