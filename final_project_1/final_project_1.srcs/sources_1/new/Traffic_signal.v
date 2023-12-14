`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/09 13:25:21
// Design Name: 
// Module Name: Traffic_signal
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


module Traffic_signal(clk, rst, btn, S_W, N_W, W_W, E_W, SOUTH, NORTH, WEST, EAST, LCD_E, LCD_RS, LCD_RW, LCD_DATA, LED_R, LED_G, LED_B);

input clk, rst;
input [5:0] btn;

output reg [1:0] S_W;
output reg [1:0] N_W;
output reg [1:0] W_W;
output reg [1:0] E_W;
output reg [3:0] SOUTH;
output reg [3:0] NORTH;
output reg [3:0] WEST;
output reg [3:0] EAST;

output wire LCD_E;
output reg LCD_RS, LCD_RW;
output reg [7:0] LCD_DATA;

output reg [3:0] LED_R;
output reg [3:0] LED_G;
output reg [3:0] LED_B;

reg [2:0] state1;
parameter SET1 = 3'b000,
          DELAY = 3'b001,
          DAY = 3'b010,
          NIGHT = 3'b011,
          URGENCY = 3'b100;
          
reg [3:0] state2;
parameter SET2 = 4'b0000,
          A = 4'b0001,
          B = 4'b0010,
          C = 4'b0011,
          D = 4'b0100,
          E = 4'b0101,
          F = 4'b0110,
          G = 4'b0111,
          H = 4'b1000;

wire [5:0] btn_t;
Oneshot_btn #(.WIDTH(6)) o1(clk, rst, btn, btn_t);

wire [1:0] state_rate;
wire [5:0] hours;
wire [5:0] minutes;
wire [5:0] seconds;
wire [7:0] bcd_hours;
wire [7:0] bcd_minutes;
wire [7:0] bcd_seconds;
CLOCK c1(clk, rst, btn_t, state_rate, hours, minutes, seconds, bcd_hours, bcd_minutes, bcd_seconds);

reg [4:0] s;
reg [4:0] t;
wire s_state_t;
wire t_state_t;
wire t0_trig;
Oneshot_s o2(clk, rst, s, s_state_t);
Oneshot_t o3(clk, rst, t, state1, t_state_t, t0_trig);

wire W_TOGGLE;
T_FF t1(clk, rst, W_TOGGLE);

wire LCD_RS_out;
wire LCD_RW_out;
wire [7:0] LCD_DATA_out;
LCD l1(clk, rst, state2, hours, bcd_hours, bcd_minutes, bcd_seconds, LCD_E, LCD_RS_out, LCD_RW_out, LCD_DATA_out);

wire [3:0] R_out;
wire [3:0] G_out;
wire [3:0] B_out;
RGB r1(clk, rst, state1, R_out, G_out, B_out);

reg [2:0] s_state;
reg [1:0] emergency_state;

reg [19:0] cnt_s;
reg [19:0] cnt_t;

always @(posedge clk or negedge rst) begin  //주간: 0.5초마다 s 1증가(5초까지), 야간: 0.5초마다 s 1증가(10초까지), 긴급상황 : 0.5초마다 t 1증가(15초까지)
    if(!rst) begin
        cnt_s <= 0;
        cnt_t <= 0;
        s <= 0;
        t <= 5'b11110;
    end
    else begin
        if(cnt_s == 4999) begin
            cnt_s <= 0;
            s <= s + 1;
            case(state1)
                DAY : begin
                    if(s == 5'b01001)
                        s <= 0;
                end
                NIGHT : begin
                    if(s == 5'b10011)
                        s <= 0;
                end
            endcase
        end
        else if(state1 == URGENCY) begin
            if(t0_trig) t <= 0;
            if(cnt_t == 4999) begin
                cnt_t <= 0;
                t <= t + 1;
            end
            else begin
                cnt_t <= cnt_t + 1;
            end
        end
        else cnt_s <= cnt_s + 1;
    end
end

always @(posedge clk or negedge rst) begin  //DAY: s=10일 때(5초)마다 s_state 1증가, NIGHT: s=20일 때(10초)마다 s_state 1증가, 긴급상황: t=30일 때(15초)마다 초기화
    if(!rst) begin
        s_state <= 0;
        emergency_state <= 0;
    end
    else begin
        case(state1)
            DAY : begin
                if(s_state_t) s_state <= s_state+1;
                if(s_state==3'b110 && s_state_t==1) s_state <= 3'b001;    
            end
            NIGHT : begin
                if(s_state_t) s_state <= s_state+1;
                if(s_state==3'b110 && s_state_t==1) s_state <= 3'b001;
            end
            URGENCY : begin
                if(t_state_t) emergency_state <= emergency_state+1;
                if(emergency_state==2'b01 && t==5'b11110) emergency_state <= 2'b00;
            end 
        endcase
    end
end
                     
always @(posedge clk or negedge rst) begin  //주야간, 긴급상황 구분 동작(state1), 신호등 상태(state2)
    if(!rst) begin
        state1 <= SET1;
        state2 <= SET2;
        S_W <= 2'b00;
        N_W <= 2'b00;
        W_W <= 2'b00;
        E_W <= 2'b00;
        SOUTH <= 4'b0000;
        NORTH <= 4'b0000;
        WEST <= 4'b0000;
        EAST <= 4'b0000;
    end
    else begin
        case(state2)
            SET2 : begin
                S_W <= 2'b00;
                N_W <= 2'b00;
                W_W <= 2'b00;
                E_W <= 2'b00;
                SOUTH <= 4'b0000;
                NORTH <= 4'b0000;
                WEST <= 4'b0000;
                EAST <= 4'b0000;
            end
            A : begin
                S_W <= 2'b10;
                N_W <= 2'b10;
                W_W <= 2'b01;
                E_W <= 2'b01;
                SOUTH <= 4'b0010;
                NORTH <= 4'b0010;
                WEST <= 4'b1000;
                EAST <= 4'b1000;
            end
            B : begin
                S_W <= 2'b10;
                N_W <= 2'b10;
                W_W <= 2'b10;
                E_W <= 2'b01;
                SOUTH <= 4'b1000;
                NORTH <= 4'b0011;
                WEST <= 4'b1000;
                EAST <= 4'b1000;
            end
            C : begin
                S_W <= 2'b10;
                N_W <= 2'b10;
                W_W <= 2'b01;
                E_W <= 2'b10;
                SOUTH <= 4'b0011;
                NORTH <= 4'b1000;
                WEST <= 4'b1000;
                EAST <= 4'b1000;
            end
            D : begin
                S_W <= 2'b10;
                N_W <= 2'b10;
                W_W <= 2'b10;
                E_W <= 2'b10;
                SOUTH <= 4'b0001;
                NORTH <= 4'b0001;
                WEST <= 4'b1000;
                EAST <= 4'b1000;
            end
            E : begin
                S_W <= 2'b01;
                N_W <= 2'b01;
                W_W <= 2'b10;
                E_W <= 2'b10;
                SOUTH <= 4'b1000;
                NORTH <= 4'b1000;
                WEST <= 4'b0010;
                EAST <= 4'b0010;
            end
            F : begin
                S_W <= 2'b10;
                N_W <= 2'b01;
                W_W <= 2'b10;
                E_W <= 2'b10;
                SOUTH <= 4'b1000;
                NORTH <= 4'b1000;
                WEST <= 4'b0011;
                EAST <= 4'b1000;
            end
            G : begin
                S_W <= 2'b01;
                N_W <= 2'b10;
                W_W <= 2'b10;
                E_W <= 2'b10;
                SOUTH <= 4'b1000;
                NORTH <= 4'b1000;
                WEST <= 4'b1000;
                EAST <= 4'b0011;
            end
            H : begin
                S_W <= 2'b10;
                N_W <= 2'b10;
                W_W <= 2'b10;
                E_W <= 2'b10;
                SOUTH <= 4'b1000;
                NORTH <= 4'b1000;
                WEST <= 4'b0001;
                EAST <= 4'b0001;
            end
        endcase
        case(state1)
            SET1 : state1 <= DELAY;
            DELAY : begin
                if(hours>=6'b001000 && hours<6'b010111) state1 <= DAY;
                else state1 <= NIGHT;
            end
            DAY : begin
                    if(btn_t == 6'b000001) state1 <= URGENCY;
                    if(btn_t == 6'b000010) state1 <= SET1;
                    if(hours == 6'b010111) state1 <= NIGHT;
                    
                    case(s_state)
                        3'b001 : begin
                            state2 <= A;
                                if(s >= 5'b01001) begin
                                    SOUTH <= 4'b0100;
                                    NORTH <= 4'b0100;
                                end
                                else if(s >= 5'b00101) begin
                                    E_W[0] <= W_TOGGLE;
                                    W_W[0] <= W_TOGGLE;
                                end
                        end
                        3'b010 : begin
                            state2 <= D;
                                if(s >= 5'b01001) begin
                                    SOUTH <= 4'b0100;
                                    NORTH <= 4'b0100;
                                end
                        end
                        3'b011 : begin
                            state2 <= F;
                                if(s >= 5'b01001) begin
                                    WEST <= 4'b0110;
                                end
                        end
                        3'b100 : begin
                            state2 <= E;
                                if(s >= 5'b01001) begin
                                    WEST <= 4'b0100;
                                end
                                else if(s >= 0) begin
                                    N_W[0] <= W_TOGGLE;
                                end
                        end
                        3'b101 : begin
                            state2 <= G;
                                if(s >= 5'b01001) begin
                                    EAST <= 4'b0110;
                                end
                                else if(s >= 5'b00101) begin
                                    S_W[0] <= W_TOGGLE;
                                end
                        end
                        3'b110 : begin
                            state2 <= E;
                                if(s >= 5'b01001) begin
                                    WEST <= 4'b0100;
                                    EAST <= 4'b0100;
                                end
                                else if(s >= 0) begin
                                    S_W[0] <= W_TOGGLE;
                                    if(s >= 5'b00101) begin
                                        N_W[0] <= W_TOGGLE;
                                    end
                                end
                        end
                    endcase
            end 
            NIGHT : begin
                    if(btn_t == 6'b000001) state1 <= URGENCY;
                    if(btn_t == 6'b000010) state1 <= SET1;
                    if(hours == 6'b001000) state1 <= DAY;
                                                         
                    case(s_state)
                        3'b001 : begin
                            state2 <= B;
                                if(s >= 5'b10011) begin
                                    NORTH <= 4'b0110;
                                end
                        end
                        3'b010 : begin
                            state2 <= A;
                                if(s >= 5'b10011) begin
                                    NORTH <= 4'b0100;
                                end
                                else if(s >= 0) begin
                                    E_W[0] <= W_TOGGLE;
                                end
                        end
                        3'b011 : begin
                            state2 <= C;
                                if(s >= 5'b10011) begin
                                    SOUTH <= 4'b0110;
                                end
                                else if(s >= 5'b01010) begin
                                    W_W[0] <= W_TOGGLE;
                                end
                        end
                        3'b100 : begin
                            state2 <= A;
                                if(s >= 5'b10011) begin
                                    NORTH <= 4'b0100;
                                    SOUTH <= 4'b0100;
                                end
                                else if(s >= 0) begin
                                    W_W[0] <= W_TOGGLE;
                                        if(s >= 5'b01010) begin
                                            E_W[0] <= W_TOGGLE;
                                        end
                                end
                        end
                        3'b101 : begin
                            state2 <= E;
                                if(s >= 5'b10011) begin
                                    WEST <= 4'b0100;
                                    EAST <= 4'b0100;
                                end
                                else if(s >= 5'b01010) begin
                                    N_W[0] <= W_TOGGLE;
                                    S_W[0] <= W_TOGGLE;
                                end
                        end
                        3'b110 : begin
                            state2 <= H;
                                if(s >= 5'b10011) begin
                                    WEST <= 4'b0100;
                                    EAST <= 4'b0100;
                                end
                        end
                    endcase
            end                   
            URGENCY : begin
                case(t)
                    5'b000010 : state2 <= A;
                endcase
                if(emergency_state==2'b01 && t==5'b11110) state1 <= SET1;
            end
        endcase
    end
end

always @(posedge clk or negedge rst) begin  //LCD 출력 연결
    if(!rst) begin
        LCD_RS <= 0;
        LCD_RW <= 0;
        LCD_DATA <= 0;
    end
    else begin
        LCD_RS <= LCD_RS_out;
        LCD_RW <= LCD_RW_out;
        LCD_DATA <= LCD_DATA_out;
    end
end

always @(posedge clk or negedge rst) begin  //삼색 LED 출력 연결
    if(!rst) begin
        LED_R <= 0;
        LED_G <= 0;
        LED_B <= 0;
    end
    else begin
        LED_R <= R_out;
        LED_G <= G_out;
        LED_B <= B_out;
    end
end 

endmodule
