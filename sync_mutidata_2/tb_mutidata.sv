`include "mutidata_2.v"
`timescale 1ns/1ps

module tb_mutidata (); /* this is automatically generated */

	// clock
	logic clk1;
	initial begin
		clk1 = '0;
		forever #(1) clk1 = ~clk1;
	end
	logic clk2;
	initial begin
		clk2 = '0;
		forever #(0.5) clk2 = ~clk2;
	end

	// (*NOTE*) replace reset, clock, others

	logic       rst_i;
	logic       in_vld;
	logic [7:0] din;
	logic       rst_o;
	logic       r_ack;
	logic [7:0] dout;

	mutidata inst_mutidata
		(
			.clk_i  (clk1),
			.rst_i  (rst_i),
			.in_vld (in_vld),
			.din    (din),
			.clk_o  (clk2),
			.rst_o  (rst_o),
			.r_ack  (r_ack),
			.dout   (dout)
		);

	task init();
		rst_i <= '0;
		din   <= '0;
		rst_o <= '0;
	endtask

	initial begin
		// do something

		init();
		repeat(2)@(posedge clk1);
		rst_o <= 1;
		rst_i <= 1;
		repeat(5)@(posedge clk1);
		din <= 8'd4;
		repeat(5)@(posedge clk1);
		din <= 8'd10;
		repeat(5)@(posedge clk1);
		din <= 8'd5;	
		repeat(5)@(posedge clk1);
		din <= 8'd8;
		repeat(100)@(posedge clk1);	
		$finish;
	end

	// dump wave
	initial
	begin            
	    $dumpfile("wave.vcd");        //生成的vcd文件名称
	    $dumpvars(0, tb_mutidata);    //tb模块名称
	end

endmodule
