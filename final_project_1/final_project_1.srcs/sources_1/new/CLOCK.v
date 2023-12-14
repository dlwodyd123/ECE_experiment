`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/27 09:14:54
// Design Name: 
// Module Name: CLOCK
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


module CLOCK(clk, rst, btn_t, state, hours_out, minutes_out, seconds_out, bcd_hours_out, bcd_minutes_out, bcd_seconds_out);

input clk, rst;
input [5:0] btn_t;

output reg [5:0] hours_out;
output reg [5:0] minutes_out;
output reg [5:0] seconds_out;
output reg [7:0] bcd_hours_out;
output reg [7:0] bcd_minutes_out;
output reg [7:0] bcd_seconds_out;

reg [7:0] rate;
output reg [1:0] state;
parameter x1 = 2'b00,
          x10 = 2'b01,
          x100 = 2'b10,
          x200 = 2'b11;

reg [5:0] hours;
reg [5:0] minutes;
reg [5:0] seconds;
wire [7:0] bcd_hours;
wire [7:0] bcd_minutes;
wire [7:0] bcd_seconds;
BIN2BCD b1(clk, rst, hours, bcd_hours);
BIN2BCD b2(clk, rst, minutes, bcd_minutes);
BIN2BCD b3(clk, rst, seconds, bcd_seconds);

reg [19:0] cnt;

always @(posedge clk or negedge rst) begin  //배속 버튼 할당, 배속별 cnt 증가량 설정
    if(!rst) begin
        state <= 2'b00;
        rate <= 8'b0000_0001;
    end
    else begin
        case(btn_t)
            6'b000100 : begin
                state <= x1;
                rate <= 8'b0000_0001;
            end
            6'b001000 : begin
                state <= x10;
                rate <= 8'b0000_1010;
            end
            6'b010000 : begin
                state <= x100;
                rate <= 8'b0110_0100;
            end
            6'b100000 : begin
                state <= x200;
                rate <= 8'b1100_1000;
            end
        endcase
    end
end

always @(posedge clk or negedge rst) begin  //시계동작
    if(!rst) begin
        cnt <= 0;
        hours <= 6'b000001;
        minutes <= 6'b000110;
        seconds <= 6'b000000;
    end
    else begin
        cnt <= cnt + rate;
        if(btn_t == 6'b000010) begin
            if(hours == 6'b010111) hours <= 0;
            else hours <= hours + 1;
        end
        
        case(state)
            x1 : begin
                if(cnt == 9999) begin
                    cnt <= 0;   
                    seconds <= seconds + 1;
                    if (seconds == 6'b111011) begin
                        seconds <= 6'b000000;
                        minutes <= minutes + 1;
                        if (minutes == 6'b111011) begin
                            minutes <= 6'b000000;
                            hours <= hours + 1;
                            if (hours == 6'b010111) begin
                                hours <= 6'b000000;
                            end
                        end
                    end
                end
            end    
            x10 : begin
                if(cnt >= 9990) begin
                    cnt <= cnt - 9990;   
                    seconds <= seconds + 1;
                    if (seconds == 6'b111011) begin
                        seconds <= 6'b000000;
                        minutes <= minutes + 1;
                        if (minutes == 6'b111011) begin
                            minutes <= 6'b000000;
                            hours <= hours + 1;
                            if (hours == 6'b010111) begin
                                hours <= 6'b000000;
                            end
                        end
                    end
                end
            end
            x100 : begin
                if(cnt >= 9900) begin
                    cnt <= cnt - 9900;   
                    seconds <= seconds + 1;
                    if (seconds == 6'b111011) begin
                        seconds <= 6'b000000;
                        minutes <= minutes + 1;
                        if (minutes == 6'b111011) begin
                            minutes <= 6'b000000;
                            hours <= hours + 1;
                            if (hours == 6'b010111) begin
                                hours <= 6'b000000;
                            end
                        end
                    end
                end
            end
            x200 : begin
                if(cnt >= 9800) begin
                    cnt <= cnt - 9800;   
                    seconds <= seconds + 1;
                    if (seconds == 6'b111011) begin
                        seconds <= 6'b000000;
                        minutes <= minutes + 1;
                        if (minutes == 6'b111011) begin
                            minutes <= 6'b000000;
                            hours <= hours + 1;
                            if (hours == 6'b010111) begin
                                hours <= 6'b000000;
                            end
                        end
                    end
                end
            end
        endcase    
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst) begin
        hours_out <= 6'b0;
        minutes_out <= 6'b0;
        seconds_out <= 6'b0;
        bcd_hours_out <= {4'd0, 4'd0};
        bcd_minutes_out <= {4'd0, 4'd0};
        bcd_seconds_out <= {4'd0, 4'd0};
    end
    else begin
        hours_out <= hours;
        minutes_out <= minutes;
        seconds_out <= seconds;
        bcd_hours_out <= bcd_hours;
        bcd_minutes_out <= bcd_minutes;
        bcd_seconds_out <= bcd_seconds;
    end
end

endmodule
