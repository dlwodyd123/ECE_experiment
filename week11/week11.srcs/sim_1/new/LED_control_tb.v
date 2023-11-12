`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/12 13:33:38
// Design Name: 
// Module Name: LED_control_tb
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


module LED_control_tb(led_signal);

reg clk, rst;
reg [7:0] bin;

wire [7:0] cnt;

wire [7:0] seg_data;
wire [7:0] seg_sel;
output reg led_signal;

counter_8bit c1(clk, rst, cnt);
seg7_controller s1(clk, rst, bin, seg_data, seg_sel);

always @(posedge clk or posedge rst) begin
    if(rst) led_signal<=0;
    else begin
        if(cnt<=bin) led_signal<=1;
        else if(cnt>bin) led_signal<=0;
    end
end

initial begin
clk<=0;
rst<=0;
#10; rst<=1;
#10; rst<=0; bin=0;
#10000; bin=8'b01000000;
#10000; bin=8'b10000000;
#10000; bin=8'b11000000;
#10000; bin=8'b11111111;
end

always begin
    #0.5  clk<=~clk;
end

endmodule
