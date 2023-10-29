`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/28 14:18:05
// Design Name: 
// Module Name: circuit1_tb
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

module circuit1_tb(y, state);

reg clk, rst;
reg x;
output reg [1:0] state;
output reg y;

always @(negedge rst or posedge clk) begin
    if(!rst) state<=2'b00;
    else begin
        case(state)
            2'b00: {state,y}<=x?3'b010:3'b000;
            2'b01: {state,y}<=x?3'b110:3'b001;
            2'b10: {state,y}<=x?3'b100:3'b001;
            2'b11: {state,y}<=x?3'b100:3'b001;
        endcase
    end
end

initial begin
clk<=0;
rst<=1;
#10
state=2'b00; x=1; #10;
state=2'b01; x=0; #10;
state=2'b01; x=1; #10;
state=2'b10; x=0; #10;
state=2'b10; x=1; #10;
state=2'b11; x=0; #10;
end

always begin
    #5 clk<=~clk;
end

endmodule
