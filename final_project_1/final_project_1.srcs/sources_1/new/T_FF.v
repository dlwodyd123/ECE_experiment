`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/09 13:31:38
// Design Name: 
// Module Name: T_FF
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


module T_FF(clk, rst, Q);

input clk, rst;

output reg Q;

reg [19:0] cnt;

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        cnt <= 0;
        Q <= 0;
    end
    else begin
        if(cnt == 4999) begin
            Q <= ~Q;
            cnt <= 0;
        end
        else cnt <= cnt+1;
    end
end

endmodule
