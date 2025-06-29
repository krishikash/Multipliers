`timescale 1ns / 1ps
module test_8x8;
reg [7:0] a,b;
wire [15:0] result;

vedic8x8 V0(a, b, result);

initial begin

    #10 a= 8'b01000000; b= 8'b00110000;
    #20 a= 8'b00110000; b= 8'b00100011;
    #20 a= 8'b00100000; b= 8'b00100101;
    #20 a= 8'b00010011; b= 8'b01110011;
    //#50 $finish; 
end

//always #5 clk = ~clk  ; 

endmodule
