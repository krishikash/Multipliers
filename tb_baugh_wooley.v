
module test;

reg [7:0] x, y;   // 8 bit inputs

wire [15:0] s; // 16 bit output of multiplier circuit

baugh_wooley mult(.x(x), .y(y), .s(s));

initial
begin
x = 8'b00111111; y = 8'b00011001;
#10 x = 8'b00110111; y = 8'b00011011;
end

initial
$monitor($time, "%b * %b = %b", x, y, s);

endmodule

 
