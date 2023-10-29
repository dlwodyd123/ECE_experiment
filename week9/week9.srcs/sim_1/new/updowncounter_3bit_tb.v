`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/29 20:17:57
// Design Name: 
// Module Name: updowncounter_3bit_tb
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


module updowncounter_3bit_tb(state);

reg clk, rst;
reg x;
reg x_reg, x_trig;
output reg [2:0] state;

always @(negedge rst or posedge clk) begin
    if(!rst) begin
        {x_reg, x_trig}<=2'b00;
    end
    else begin
        x_reg<=x;
        x_trig<=x&~x_reg;
    end
end

always @(negedge rst or posedge clk) begin
    if(!rst) state<=3'b000;
    else begin
        case(state)
            3'b000: state <= x_trig ? 3'b001 : x ? 3'b000 : 3'b000;
            3'b001: state <= x_trig ? 3'b010 : x ? 3'b001 : 3'b000;
            3'b010: state <= x_trig ? 3'b011 : x ? 3'b010 : 3'b001;
            3'b011: state <= x_trig ? 3'b100 : x ? 3'b011 : 3'b010;
            3'b100: state <= x_trig ? 3'b101 : x ? 3'b100 : 3'b011;
            3'b101: state <= x_trig ? 3'b110 : x ? 3'b101 : 3'b100;
            3'b110: state <= x_trig ? 3'b111 : x ? 3'b110 : 3'b101;
            3'b111: state <= x_trig ? 3'b110 : x ? 3'b110 : 3'b110;
        endcase
    end
end

initial begin
clk<=0;
rst<=1;
x<=0;
#10; rst<=0;
#10; rst<=1; x=1;
#10; x=0;
#10; x=1;
#10; x=0;
#10; x=1;
#10; x=0;
#10; x=1;
#10; x=0;
#10; x=1;
#10; x=0;
#10; x=1;
#10; x=0;
#10; x=1;
#10; x=0;
end

always begin
    #5 clk<=~clk;
end

endmodule
