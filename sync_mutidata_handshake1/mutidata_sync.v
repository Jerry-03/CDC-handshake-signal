// -----------------------------------------------------------------------------
// Copyright (c) 2014-2022 All rights reserved
// -----------------------------------------------------------------------------
// Author : jason jason_xx0@qq.com
// File   : mutidata_sync.v
// Create : 2022-09-29 12:02:53
// Revise : 2022-09-29 17:36:01
// Editor : sublime text4, tab size (4)
// discrimination: 完全握手信号同步方式
// -----------------------------------------------------------------------------

module mutidata (clk_i, rst_i,in_vld,din,
    clk_o,rst_o,out_vld,dout);

    input clk_i;
    input rst_i;
    input [7:0] din;
    //input out_ack;
    input rst_o;
    input clk_o;
    output reg in_vld;
    output reg [7:0] dout;
    //output reg r_ack; //r_ack
    output  reg out_vld;
   //reg [7:0] buffer;
    //reg in_vld_lev;
    //reg shake0,shake1,shake2,shake3;
    reg [7:0] din_temp;

    reg flag;
//in_acknowledge信号，这是一个跨时钟域信号单比特脉冲信号
//在完全握手信号中，没有这个脉冲信号
always @(din) begin
    if (rst_i == 0) begin
        // reset
        in_vld = 0;
        flag = 0;
    end
    else 
        flag = 1;
end

// reg flag_q;
// always @(posedge clk_i) begin
//     if (rst_i == 0) begin
//         flag_q <= 'b0;
//     end
//     else begin
//         flag_q <= flag;
//     end
// end

always @(posedge clk_i) begin
    if (rst_i == 0) begin
        // reset
        in_vld = 0;
    end
    else if (flag == 1) begin
        in_vld <= 1;
        flag <= 0;
    end
end
always @(posedge clk_i) begin
    if (rst_i == 0) begin
        // reset
        din_temp = 8'b0;
    end
    else if (in_vld == 1) begin
        din_temp <= din;
    end
end

//in_vld信号同步到clk out
reg out_vld_q1;
reg out_vld_q2;
always @ (posedge clk_o) begin
    if(rst_o == 0)begin
        out_vld_q1 <= 0;
        out_vld_q2 <= 0;
    end
    else begin
        out_vld_q1 <= in_vld;
        out_vld_q2 <= out_vld_q1;
        out_vld <= out_vld_q2;
    end
end

//处理out_vld信号,生成输出
always @(posedge clk_o) begin
    if (rst_o == 0) begin
        // reset
        dout <= 0;
    end
    else if (out_vld == 1) begin
        dout <= din_temp;      
    end
end

reg in_vld_q1;
reg in_vld_q2;
//将out_vld信号同步到clk_in
always @(posedge clk_i) begin
    if (rst_i == 0) begin
        // reset
        in_vld_q1 <= 1'b0;
        in_vld_q2 <= 1'b0;
    end
    else begin
        in_vld_q1 <= out_vld_q2;
        in_vld_q2 <= in_vld_q1;
    end
end

//拉低in_vld信号
always @(posedge clk_i) begin
    if (rst_i == 0) begin
        // reset
        in_vld <= 1'b0;
    end
    else if (in_vld_q2 == 1) begin
        in_vld <= 1'b0;
    end
end

//拉低r_ack信号
// always @(posedge clk_o) begin
//     if (rst_o == 0) begin
//         // reset
//         out_vld <= 0;
//     end
//     else if (out_vld_q2 == 0) begin
//         out_vld <= 0;
//     end
// end

endmodule
    