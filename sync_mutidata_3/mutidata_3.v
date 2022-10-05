//==================================================================================================
//  Filename      : mutidata_3.v
//  Created On    : 2022-10-05 16:20:53
//  Last Modified : 2022-10-05 17:16:56
//  Revision      : 
//  Author        : Jason
//  Company       : HKUST
//  Email         : Jasonxx075@gmail.com
//
//  Description   : 部分握手信号，脉冲响应
//
//
//==================================================================================================
module mutidata3 (clk_i, rst_i,in_pulse,din,
    clk_o,rst_o,out_pulse,dout);

    input clk_i;
    input rst_i;
    input [7:0] din;
    input rst_o;
    input clk_o;
    input in_pulse;
    output reg [7:0] dout;
    output  reg out_pulse;

    reg [7:0] din_temp;
    reg in_request;//电平信号，跨时钟传输

always @(posedge clk_i) begin
    if (rst_i == 0) begin
        // reset
        in_request <= 0;
    end
    else if (in_pulse == 1) begin
        in_request <= 1;
    end
end

always @(posedge clk_i) begin
    if (rst_i == 0) begin
        // reset
        din_temp = 8'b0;
    end
    else if (in_pulse== 1) begin
        din_temp <= din;
    end
end

//in_request信号同步到clk out
reg out_vld_q1;
reg out_vld_q2;
always @ (posedge clk_o) begin
    if(rst_o == 0)begin
        out_vld_q1 <= 0;
        out_vld_q2 <= 0;
    end
    else begin
        out_vld_q1 <= in_request;
        out_vld_q2 <= out_vld_q1;
        out_pulse <= out_vld_q1 && ~out_vld_q2;
    end
end

//处理out_vld信号,生成输出
always @(posedge clk_o) begin
    if (rst_o == 0) begin
        // reset
        dout <= 0;
    end
    else if (out_pulse == 1) begin
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
        in_request <= 1'b0;
    end
    else if (in_vld_q2 == 1) begin
        in_request <= 1'b0;
    end
end

endmodule