`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/05 21:35:47
// Design Name: 
// Module Name: piezo_tb
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


module piezo_tb(piezo);

reg clk, rst;
reg [7:0] btn;
output reg piezo;

parameter C2=12'd3830;
parameter D2=12'd3400;
parameter E2=12'd3038;
parameter F2=12'd1864;
parameter G2=12'd2550;
parameter A2=12'd2272;
parameter B2=12'd2028;
parameter C3=12'd1912;

reg [11:0] cnt;
reg [11:0] cnt_limit;

always @(btn) begin
    if(!rst) cnt_limit=0;
    else begin
        case(btn)
            8'b00000001: cnt_limit=C2;
            8'b00000010: cnt_limit=D2;
            8'b00000100: cnt_limit=E2;
            8'b00001000: cnt_limit=F2;
            8'b00010000: cnt_limit=G2;
            8'b00100000: cnt_limit=A2;
            8'b01000000: cnt_limit=B2;
            8'b10000000: cnt_limit=C3;
        endcase
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        cnt=0;
        piezo=0;
    end
    else if(cnt >= cnt_limit/2) begin
        piezo=~piezo;
        cnt=0; 
    end
    else cnt=cnt+1;
end

initial begin
    clk<=0;
    rst<=1;
    btn<=8'b00000000;
    #1e+6; rst<=0;
    #1e+6; rst<=1;
    #1e+6; btn<=8'b00000010;
    #1e+6; btn<=8'b00100000;
end

always begin
    #1 clk<=~clk;
end
    
endmodule