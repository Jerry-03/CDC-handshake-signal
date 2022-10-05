`include "mutidata_3.v"
`timescale 1ns/1ps

module tb_mutidata3 (); /* this is automatically generated */

	// clock
	logic clk1;
	initial begin
		clk1 = '0;
		forever #(5) clk1 = ~clk1;
	end
	logic clk2;
	initial begin
		clk2 = '0;
		forever #(0.5) clk2 = ~clk2;
	end

	// (*NOTE*) replace reset, clock, others

	logic       rst_i;
	logic       in_pulse;
	logic [7:0] din;
	logic       rst_o;
	logic       out_pulse;
	logic [7:0] dout;

	mutidata3 inst_mutidata3
		(
			.clk_i     (clk1),
			.rst_i     (rst_i),
			.in_pulse  (in_pulse),
			.din       (din),
			.clk_o     (clk2),
			.rst_o     (rst_o),
			.out_pulse (out_pulse),
			.dout      (dout)
		);

	task init();
		rst_i    <= '0;
		in_pulse <= '0;
		din      <= '0;
		rst_o    <= '0;
	endtask

	task genpulse();
		in_pulse <= 1'b1;
		repeat(1)@(posedge clk2);
		in_pulse <= 1'b0;
	endtask

	initial begin
		// do something

		init();
		repeat(2)@(posedge clk2);
		rst_o <= '1;
		rst_i <= '1;

		repeat(10)@(posedge clk2);
		din <= 8'd5;
		genpulse();

		repeat(10)@(posedge clk2);
		din <= 8'd11;
		genpulse();

		repeat(10)@(posedge clk2);
		din <= 8'd4;
		genpulse();

		repeat(10)@(posedge clk2);
		din <= 8'd8;
		genpulse();

		repeat(10)@(posedge clk2);
		din <= 8'd14;
		genpulse();

		repeat(20)@(posedge clk1);
		$finish;
	end

	// dump wave
	initial
	begin            
	    $dumpfile("wave.vcd");        //生成的vcd文件名称
	    $dumpvars(0, tb_mutidata3);    //tb模块名称
	end

endmodule
