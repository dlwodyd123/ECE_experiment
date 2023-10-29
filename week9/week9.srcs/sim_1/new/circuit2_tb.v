`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/29 18:12:08
// Design Name: 
// Module Name: circuit2_tb
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


module circuit2_tb(state,y);

reg clk, rst;
reg A,B,C;
reg A_reg, B_reg, C_reg;
reg A_trig, B_trig, C_trig;
output reg [2:0] state;
output reg y;

parameter S0=3'b000;
parameter S50=3'b001;
parameter S100=3'b010;
parameter S150=3'b011;
parameter S200=3'b100;

always @(negedge rst or posedge clk) begin
    if(!rst) begin
        {A_reg,B_reg,C_reg}<=3'b000;
        {A_trig,B_trig,C_trig}<=3'b000;
    end
    else begin
        {A_reg,B_reg,C_reg}<={A,B,C};
        {A_trig,B_trig,C_trig}<={A,B,C}&~{A_reg,B_reg,C_reg};
    end
end

always @(negedge rst or posedge clk) begin
    if(!rst) state<=S0;
    else begin
        case(state)
            S0:state<=A_trig?S50:B_trig?S100:S0;
            S50:state<=A_trig?S100:B_trig?S150:S50;
            S100:state<=A_trig?S150:B_trig?S200:S100;
            S150:state<=A_trig?S200:B_trig?S200:S150;
            S200:state<=A_trig?S200:B_trig?S200:C_trig?S0:S200;
        endcase
    end
end

always @(negedge rst or posedge clk) begin
    if(!rst) y<=0;
    else begin
        case(state)
            S200:y<=C_trig?1:0;
        endcase
    end
end

initial begin
    clk<=0;
    rst<=1;
    #10; rst<=0;
    #10; rst<=1; A=1;B=0;C=0;
    #10; A=0;B=1;C=0;
    #10; A=1;B=0;C=0;
    #10; A=0;B=1;C=0;
    #10; A=0;B=0;C=1;
    #10; A=0;B=0;C=0;
    #10; rst<=0;
    #10; rst<=1;
    #10; A=1;B=0;C=0;
    #10; A=0;B=1;C=0;
    #10; A=0;B=0;C=1;
end

always begin
    #5 clk<=~clk;
end

endmodule