`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/12 13:02:22
// Design Name: 
// Module Name: counter_8bit
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


module counter_8bit(clk, rst, cnt);

input clk, rst;
output reg [7:0] cnt;

always @ (posedge clk or posedge rst) begin
    if(rst) begin
        cnt<= 8'b0000_0000;
    end
    else cnt<= cnt+1;
end

endmodule
