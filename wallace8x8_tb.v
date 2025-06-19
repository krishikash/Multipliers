`timescale 1ns / 1ps


module wallace_tb;

	// Inputs
	reg [7:0] m;
	reg [7:0] n;
	// Outputs
	wire [16:0] p;

	// Instantiate the Unit Under Test (UUT)
	wallace_8x8 uut (
		.m(m), 
		.n(n), 
		.p(p)
	);

	initial begin
	$dumpfile("power_test.vcd");
	$dumpvars(1,wallace_tb.uut);
		// Initialize Inputs
		m = 0;
		n = 0;

		#10;
      m = 8'd10;
      n = 8'd10;
 
		#10;
      m = 8'd50;
      n = 8'd20;

		#10;
      m = 8'd8;
      n = 8'd6;
		
		#10;
      m = 8'd18;
      n = 8'd18;

		#10;
      m = 8'd22;
      n = 8'd24;		

      #10;$stop;
		end
endmodule
