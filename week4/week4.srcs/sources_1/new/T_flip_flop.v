`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/22 02:19:27
// Design Name: 
// Module Name: T_flip_flop
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


module T_flip_flop(clk, rst, T, Q);

input T, clk, rst;
output reg Q;

always @(posedge clk or negedge rst) begin
    if (!rst)
        Q<=1'b0;
    else if(T)
        Q<=~Q;
end

endmodule
