//==================================================================================================
//  Filename      : mutidata_2.v
//  Created On    : 2022-10-03 12:10:58
//  Last Modified : 2022-10-03 21:00:45
//  Revision      : 
//  Author        : Jason
//  Company       : HKUST
//  Email         : Jasonxx075@gmail.com
//
//  Description   : 部分握手信号，r_ack脉冲响应
//
//==================================================================================================
module mutidata (clk_i, rst_i,in_vld,din,
    clk_o,rst_o,r_ack,dout);

    input clk_i;
    input rst_i;
    input [7:0] din;
    //input in_ack;
    input rst_o;
    input clk_o;
    output reg in_vld;
    output reg [7:0] dout;
    output reg r_ack; //r_ack
    //output  reg out_vld;

    reg [7:0] din_temp;
    reg flag;
//in_acknowledge信号，这是一个跨时钟域信号单比特脉冲信号
//检测数据变化的这个脉冲信号
always @(din) begin
    if (rst_i == 0) begin
        // reset
        in_vld <= 0;
        flag <= 0;
    end
    else 
        flag <= 1;
end

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
reg out_vld_q3;
reg out_vld;
always @ (posedge clk_o) begin
    if(rst_o == 0)begin
        out_vld_q1 <= 0;
        out_vld_q2 <= 0;
    end
    else begin
        out_vld_q1 <= in_vld;
        out_vld_q2 <= out_vld_q1;
        r_ack <= ~out_vld_q2 && out_vld_q1;
    end
end

//处理out_vld信号,生成输出
always @(posedge clk_o) begin
    if (rst_o == 0) begin
        // reset
        dout <= 0;
    end
    else if (r_ack == 1) begin
        dout <= din_temp;      
    end
end

//生成r_ack_level信号
reg r_ack_level;
always @(posedge clk_o) begin
	if (rst_o == 0) begin
		// reset
		r_ack_level <= 0;
	end
	else if ((r_ack == 1) && (out_vld_q2 == 1)) begin
		r_ack_level <= ~r_ack_level;
	end
end

reg in_vld_q1;
reg in_vld_q2;
//reg in_vld_q3;
reg in_ack_pluse;
//将r_ack_level信号同步到clk_in
always @(posedge clk_i) begin
    if (rst_i == 0) begin
        // reset
        in_vld_q1 <= 1'b0;
        //in_vld_q2 <= 1'b0;
    end
    else  begin
    	in_vld_q1 <= out_vld_q2;
    	in_vld_q2 <= in_vld_q1;
    	in_ack_pluse <= ~in_vld_q2 && in_vld_q1;
    end
end

//拉低in_vld信号
always @(posedge clk_i) begin
    if (rst_i == 0) begin
        // reset
        in_vld <= 1'b0;
    end
    else if ((in_ack_pluse == 1) && (flag ==0))begin
        in_vld <= 1'b0;
    end
end

endmodule
    