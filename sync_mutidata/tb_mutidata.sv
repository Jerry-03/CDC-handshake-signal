`include "mutidata_sync.v"

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
	logic rst_i;
	logic rst_o;
	logic       in_vld;
	logic [7:0] din;
	//logic       in_ack;
	logic       out_vld;
	logic [7:0] dout;

	mutidata inst_mutidata
		(
			.clk_i   (clk1),
			.rst_i   (rst_i),
			.in_vld  (in_vld),
			.din     (din),
			.clk_o   (clk2),
			.rst_o   (rst_o),
			.out_vld (out_vld),
			.dout    (dout)
		);

	task init();
		rst_i  <= '0;
		//in_vld <= '0;
		din    <= '0;
		//in_ack <= '0;
		rst_o  <= '0;
	endtask

	initial begin
		// do something

		init();
		repeat(2)@(posedge clk1);
		rst_i<= '1;
		rst_o<= '1;
		repeat(5)@(posedge  clk1);
		//in_vld <= 1;
		din<=8'd4;
		repeat(5)@(posedge  clk1);
		din <= 8'd5;
		repeat(4)@(posedge clk1);
		din <= 8'd10;
		
		repeat(10)@(posedge clk1); 
		din <= 0;
		//drive(20);
		repeat(20)@(posedge clk2);
		$finish;
	end

	// dump wave
	initial begin
			$dumpfile("wave.vcb");
			$dumpvars(0, tb_mutidata);
	end

endmodule
