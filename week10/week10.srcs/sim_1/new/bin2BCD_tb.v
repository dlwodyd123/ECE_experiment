`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/05 19:05:41
// Design Name: 
// Module Name: bin2BCD_tb
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


module bin2BCD_tb(bcd);

reg clk, rst;
reg [3:0] bin;
output reg [7:0] bcd;

always @(negedge rst or posedge clk) begin
    if(!rst)begin
        bcd<={4'd0, 4'd0};
    end
    else begin
        case(bin)
            0: bcd<={4'd0, 4'd0};
            1: bcd<={4'd0, 4'd1};
            2: bcd<={4'd0, 4'd2};
            3: bcd<={4'd0, 4'd3};
            4: bcd<={4'd0, 4'd4};
            5: bcd<={4'd0, 4'd5};
            6: bcd<={4'd0, 4'd6};
            7: bcd<={4'd0, 4'd7};
            8: bcd<={4'd0, 4'd8};
            9: bcd<={4'd0, 4'd9};
            10: bcd<={4'd1, 4'd0};
            11: bcd<={4'd1, 4'd1};
            12: bcd<={4'd1, 4'd2};
            13: bcd<={4'd1, 4'd3};
            14: bcd<={4'd1, 4'd4};
            15: bcd<={4'd1, 4'd5};
            default: bcd<={4'd0, 4'd0};
        endcase
    end
end

initial begin
clk<=0;
rst<=1;
#10
bin='b0000;
#10
bin=4'b0001;
#10
bin=4'b0010;
#10
bin=4'b0011;
#10
bin=4'b0100;
#10
bin=4'b0101;
#10
bin=4'b0110;
#10
bin=4'b0111;
#10
bin=4'b1000;
#10
bin=4'b1001;
#10
bin=4'b1010;
#10
bin=4'b1011;
#10
bin=4'b1100;
#10
bin=4'b1101;
#10
bin=4'b1110;
#10
bin=4'b1111;
end

always begin
    #5 clk<=~clk;
end
              
endmodule
