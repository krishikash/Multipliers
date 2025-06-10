
`timescale 1ns / 1ps

module multiplier(
    output [15:0] prd,
    output busy,
    input [7:0] mc,
    input [7:0] mp,
    input clk,
    input start
);
    
reg [7:0] A, Q, B;
reg Q_1;
reg [3:0] count;
wire [8:0] sum, difference;  // 9-bit for carry

always @(posedge clk) begin
    if (start) begin
        A <= 8'b0;
        B <= mc;
        Q <= mp;
        Q_1 <= 1'b0;
        count <= 4'b0;
    end
    else begin
        case ({Q[0], Q_1})
            2'b01: {A, Q, Q_1} <= {sum[8], sum[7:1], sum[0], Q[7:1], Q[0]};
            2'b10: {A, Q, Q_1} <= {difference[8], difference[7:1], difference[0], Q[7:1], Q[0]};
            default: {A, Q, Q_1} <= {A[7], A[7:1], A[0], Q[7:1], Q[0]};
        endcase
        count <= count + 1'b1;
    end
end

alu adder (sum, A, B, 1'b0);
alu subtracter (difference, A, B, 1'b1);

assign prd = {A, Q};
assign busy = (count < 4'b1000);

endmodule

module alu(
    output [8:0] out,
    input [7:0] a,
    input [7:0] b,
    input cin
);
    assign out = {1'b0,a} + {1'b0,b} + cin;
endmodule


