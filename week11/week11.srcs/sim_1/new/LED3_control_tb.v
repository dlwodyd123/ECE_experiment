`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/12 14:45:18
// Design Name: 
// Module Name: LED3_control_tb
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


module LED3_control_tb(R,G,B);

reg clk, rst;
reg [7:0] btn;

wire [7:0] cnt;
reg [23:0] state;

output reg [3:0] R;
output reg [3:0] G;
output reg [3:0] B;

parameter red       ={8'd225,   8'd0,   8'd0}; 
parameter orange    ={8'd225,   8'd102, 8'd0}; 
parameter yellow    ={8'd225,   8'd255, 8'd0}; 
parameter green     ={8'd0,     8'd255, 8'd0}; 
parameter blue      ={8'd0,     8'd0,   8'd255}; 
parameter indigo    ={8'd0,     8'd0,   8'd128}; 
parameter purple    ={8'd128,   8'd0,   8'd128}; 
parameter white     ={8'd225,   8'd255, 8'd255};  

counter_8bit c1(clk, rst, cnt);

always @(posedge clk or posedge rst) begin
    if(rst) state<=24'd0;
    else begin
        case(btn)
            8'b00000001 : state<= red;
            8'b00000010 : state<= orange;
            8'b00000100 : state<= yellow;
            8'b00001000 : state<= green;
            8'b00010000 : state<= blue;
            8'b00100000 : state<= indigo;
            8'b01000000 : state<= purple;
            8'b10000000 : state<= white;
        endcase
    end
end

always @(posedge clk or posedge rst) begin
    if(rst) begin
        R <= 4'b0000;
        G <= 4'b0000;
        B <= 4'b0000;
    end
    else begin
        if(cnt<state[23:16]) R<= 4'b1111;
        else R<= 4'b0000;
        
        if(cnt<state[15:8]) G<= 4'b1111;
        else G<= 4'b0000;
        
        if(cnt<state[7:0]) B<= 4'b1111;
        else B<= 4'b0000;
    end
end

initial begin
clk<=0; rst<=0;
#10 rst<=1;
#10 rst<=0; btn=8'b00000001;
#10000; btn=8'b00000010;
#10000; btn=8'b00000100;
#10000;
$finish;
end

always begin
    #0.5 clk<=~clk;
end

endmodule
