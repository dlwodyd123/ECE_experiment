`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/09 13:31:54
// Design Name: 
// Module Name: LCD
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


module LCD(clk, rst, state2, hours, bcd_hours, bcd_minutes, bcd_seconds, LCD_E, LCD_RS, LCD_RW, LCD_DATA);

input clk, rst;
input [3:0] state2;
input [5:0] hours;
input [7:0] bcd_hours, bcd_minutes, bcd_seconds;

output wire LCD_E;
output reg LCD_RS, LCD_RW;
output reg [7:0] LCD_DATA;

reg [2:0] state;
parameter DELAY = 3'b000,
          FUNCTION_SET = 3'b001,
          ENTRY_MODE = 3'b010,
          DISP_ONOFF = 3'b011,
          LINE1 = 3'b100,
          LINE2 = 3'b101,
          DELAY_T = 3'b110,
          CLEAR_DISP = 3'b111;

integer cnt;

always @(posedge clk or negedge rst) begin                      //LCD 동작
    if(!rst) begin
        state=DELAY;
        cnt=0;
    end
    else begin
        case(state)
            DELAY : begin
                cnt=cnt+1;
                if(cnt==1) begin
                    cnt=0;
                    state = FUNCTION_SET;
                end
            end
            FUNCTION_SET : begin
                cnt=cnt+1;
                if(cnt==1) begin
                    cnt=0;
                    state = DISP_ONOFF;
                end
            end
            DISP_ONOFF : begin
                cnt=cnt+1;
                if(cnt==1) begin
                    cnt=0;
                    state = ENTRY_MODE;
                end
            end
            ENTRY_MODE : begin
                cnt=cnt+1;
                if(cnt==1) begin
                    cnt=0;
                    state = LINE1;
                end
            end
            LINE1 : begin
                cnt=cnt+1;
                if(cnt==32) begin
                cnt = 0;
                state = LINE2;
                end
            end
            LINE2 : begin
                cnt=cnt+1;
                if(cnt==17) begin
                cnt=0;
                state = DELAY_T;
                end
            end
            DELAY_T : begin
                cnt=cnt+1;
                if(cnt==150) begin
                cnt=0;
                state = CLEAR_DISP;
                end
            end
            CLEAR_DISP : begin
                cnt=cnt+1;
                if(cnt==1) begin
                cnt=0;
                state = LINE1;
                end
            end
            default : state = DELAY;
        endcase
    end
end

always @(posedge clk or negedge rst) begin                      //LCD 시간 및 주야간 표시
    if(!rst)
        {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_1_00000000;
    else begin
        case(state)
            FUNCTION_SET :
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0011_1000;
            DISP_ONOFF :
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_1100;   
            ENTRY_MODE :
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0110;
            LINE1 :
                begin
                    case(cnt) 
                        15 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_1000_0000;//첫번째줄
                        16 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0101_0100;//T
                        17 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1001;//I
                        18 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1101;//M
                        19 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0101;//E
                        20 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000;//
                        21 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1010;//:
                        22 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000;//
                        23 : begin
                            if(bcd_hours[7:4] == 4'b0000)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000;//0
                            else if(bcd_hours[7:4] == 4'b0001)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0001;//1
                            else if(bcd_hours[7:4] == 4'b0010)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0010;//2
                        end                   
                        24 : begin
                            if(bcd_hours[3:0] == 4'b0000)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000;//0
                            else if(bcd_hours[3:0] == 4'b0001)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0001;//1
                            else if(bcd_hours[3:0] == 4'b0010)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0010;//2
                            else if(bcd_hours[3:0] == 4'b0011)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0011;//3
                            else if(bcd_hours[3:0] == 4'b0100)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0100;//4
                            else if(bcd_hours[3:0] == 4'b0101)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0101;//5
                            else if(bcd_hours[3:0] == 4'b0110)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0110;//6
                            else if(bcd_hours[3:0] == 4'b0111)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0111;//7
                            else if(bcd_hours[3:0] == 4'b1000)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1000;//8
                            else if(bcd_hours[3:0] == 4'b1001)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1001;//9
                        end  
                        25 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1010;//:
                        26 : begin
                            if(bcd_minutes[7:4] == 4'b0000)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000;//0
                            else if(bcd_minutes[7:4] == 4'b0001)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0001;//1
                            else if(bcd_minutes[7:4] == 4'b0010)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0010;//2
                            else if(bcd_minutes[7:4] == 4'b0011)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0011;//3
                            else if(bcd_minutes[7:4] == 4'b0100)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0100;//4
                            else if(bcd_minutes[7:4] == 4'b0101)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0101;//5
                        end
                        27 : begin
                            if(bcd_minutes[3:0] == 4'b0000)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000;//0
                            else if(bcd_minutes[3:0] == 4'b0001)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0001;//1
                            else if(bcd_minutes[3:0] == 4'b0010)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0010;//2
                            else if(bcd_minutes[3:0] == 4'b0011)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0011;//3
                            else if(bcd_minutes[3:0] == 4'b0100)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0100;//4
                            else if(bcd_minutes[3:0] == 4'b0101)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0101;//5
                            else if(bcd_minutes[3:0] == 4'b0110)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0110;//6
                            else if(bcd_minutes[3:0] == 4'b0111)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0111;//7
                            else if(bcd_minutes[3:0] == 4'b1000)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1000;//8
                            else if(bcd_minutes[3:0] == 4'b1001)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1001;//9
                        end
                        28 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1010;//:
                        29 : begin
                            if(bcd_seconds[7:4] == 4'b0000)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000;//0
                            else if(bcd_seconds[7:4] == 4'b0001)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0001;//1
                            else if(bcd_seconds[7:4] == 4'b0010)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0010;//2
                            else if(bcd_seconds[7:4] == 4'b0011)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0011;//3
                            else if(bcd_seconds[7:4] == 4'b0100)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0100;//4
                            else if(bcd_seconds[7:4] == 4'b0101)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0101;//5
                        end
                        30 : begin
                            if(bcd_seconds[3:0] == 4'b0000)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000;//0
                            else if(bcd_seconds[3:0] == 4'b0001)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0001;//1
                            else if(bcd_seconds[3:0] == 4'b0010)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0010;//2
                            else if(bcd_seconds[3:0] == 4'b0011)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0011;//3
                            else if(bcd_seconds[3:0] == 4'b0100)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0100;//4
                            else if(bcd_seconds[3:0] == 4'b0101)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0101;//5
                            else if(bcd_seconds[3:0] == 4'b0110)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0110;//6
                            else if(bcd_seconds[3:0] == 4'b0111)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0111;//7
                            else if(bcd_seconds[3:0] == 4'b1000)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1000;//8
                            else if(bcd_seconds[3:0] == 4'b1001)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1001;//9
                        end
                        31 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000;//
                        default : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000;
                    endcase
                end
            LINE2 :
                begin
                    case(cnt) 
                        00 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_1100_0000;//두번째줄
                        01 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0101_0011;//S
                        02 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0101_0100;//T
                        03 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0001;//A
                        04 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0101_0100;//T
                        05 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0101;//E
                        06 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000;//
                        07 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_1010;//:
                        08 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000;//
                        09 : begin
                            if(state2 == 4'b0001)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0001;//A
                            if(state2 == 4'b0010)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0010;//B
                            if(state2 == 4'b0011)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0011;//C
                            if(state2 == 4'b0100)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0100;//D
                            if(state2 == 4'b0101)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0101;//E
                            if(state2 == 4'b0110)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0110;//F
                            if(state2 == 4'b0111)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0111;//G
                            if(state2 == 4'b1000)
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1000;//H
                        end
                        10 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_1000;//(
                        11 : begin
                            if(hours==6'b010111 || (hours>=6'b000000 && hours<6'b001000))
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1110;//N(야간)
                            else
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000;//
                        end     
                        12 : begin
                            if(hours==6'b010111 || (hours>=6'b000000 && hours<6'b001000))
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1001;//I(야간)     
                            else
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0100;//D(주간)
                        end
                        13 : begin
                            if(hours==6'b010111 || (hours>=6'b000000 && hours<6'b001000))
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0111;//G(야간)     
                            else
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0001;//A(주간)
                        end
                        14 : begin
                            if(hours==6'b010111 || (hours>=6'b000000 && hours<6'b001000))
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1000;//H(야간)     
                            else
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0101_1001;//Y(주간)
                        end
                        15 : begin 
                            if(hours==6'b010111 || (hours>=6'b000000 && hours<6'b001000))
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0101_0100;//T(야간)     
                            else
                                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000;//
                        end
                        16 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_1001;//)
                        default : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000;
                    endcase
                end
            DELAY_T :
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0010;
            CLEAR_DISP :
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0001;
            default :
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_1_0000_0000;
        endcase
    end
end

assign LCD_E = clk;

endmodule
