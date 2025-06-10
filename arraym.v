module array_multiplier_8x8 (
    input  [7:0] A,   // Multiplicand
    input  [7:0] B,   // Multiplier
    output [15:0] P   // Product
);

    wire [7:0] pp[7:0];        // Partial products
    wire [15:0] sum[6:0];      // Sum at each stage
    wire [15:0] carry[6:0];    // Carry at each stage

    genvar i, j;

    // Generate partial products
    generate
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = A & {8{B[i]}};
        end
    endgenerate

    // First row of addition: directly assign to product
    assign P[0] = pp[0][0];

    // Use full adders to accumulate the partial products
    generate
        for (i = 1; i < 15; i = i + 1) begin : mult_stage
            reg [3:0] count;
            wire [7:0] temp;

            assign temp = {pp[7][i-7], pp[6][i-6], pp[5][i-5], pp[4][i-4],
                           pp[3][i-3], pp[2][i-2], pp[1][i-1], pp[0][i]};

            assign P[i] = ^temp;  // Simple XOR for demonstration (not a real add logic)
        end
    endgenerate

    assign P[15] = pp[7][7]; // MSB of the result

endmodule
