module wallace_multiplier_8x8 (
    input  [7:0] A,
    input  [7:0] B,
    output [15:0] P
);

    wire [7:0] pp[7:0]; // Partial products
    genvar i, j;

    // Generate Partial Products
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_pp
            for (j = 0; j < 8; j = j + 1) begin : gen_pp_bits
                assign pp[i][j] = A[j] & B[i];
            end
        end
    endgenerate

    // Wires for intermediate sums and carries
    wire s11, c11, s12, c12, s13, c13, s14, c14, s15, c15, s16, c16, s17, c17;
    wire s21, c21, s22, c22, s23, c23, s24, c24, s25, c25;
    wire s31, c31, s32, c32, s33, c33;
    wire s41, c41, s42, c42;
    wire s51, c51;

    // Stage 1
    assign P[0] = pp[0][0];

    half_adder ha11(pp[0][1], pp[1][0], s11, c11);
    full_adder fa12(pp[0][2], pp[1][1], pp[2][0], s12, c12);
    full_adder fa13(pp[0][3], pp[1][2], pp[2][1], s13, c13);
    full_adder fa14(pp[0][4], pp[1][3], pp[2][2], s14, c14);
    full_adder fa15(pp[0][5], pp[1][4], pp[2][3], s15, c15);
    full_adder fa16(pp[0][6], pp[1][5], pp[2][4], s16, c16);
    full_adder fa17(pp[0][7], pp[1][6], pp[2][5], s17, c17);

    // Stage 2
    full_adder fa21(s12, pp[3][0], c11, s21, c21);
    full_adder fa22(s13, pp[3][1], c12, s22, c22);
    full_adder fa23(s14, pp[3][2], c13, s23, c23);
    full_adder fa24(s15, pp[3][3], c14, s24, c24);
    full_adder fa25(s16, pp[3][4], c15, s25, c25);
    full_adder fa26(s17, pp[3][5], c16, s31, c31);
    full_adder fa27(pp[1][7], pp[2][6], pp[3][6], s32, c32);
    half_adder  ha28(pp[3][7], c17, s33, c33);

    // Stage 3
    full_adder fa31(s21, pp[4][0], pp[5][0], s41, c41);
    full_adder fa32(s22, pp[4][1], pp[5][1], s42, c42);
    full_adder fa33(s23, pp[4][2], pp[5][2], s43, c43);
    full_adder fa34(s24, pp[4][3], pp[5][3], s44, c44);
    full_adder fa35(s25, pp[4][4], pp[5][4], s45, c45);
    full_adder fa36(s31, pp[4][5], pp[5][5], s46, c46);
    full_adder fa37(s32, pp[4][6], pp[5][6], s47, c47);
    full_adder fa38(s33, pp[4][7], pp[5][7], s48, c48);

    // Stage 4: Compress final two rows using Ripple Carry Adder
    wire [15:0] row1 = {pp[7][7], pp[6][7], pp[6][6], pp[6][5], pp[6][4], pp[6][3], pp[6][2], pp[6][1], pp[6][0], s48, s47, s46, s45, s44, s43, s42};
    wire [15:0] row2 = {1'b0,   pp[7][6], pp[7][5], pp[7][4], pp[7][3], pp[7][2], pp[7][1], pp[7][0], c48, c47, c46, c45, c44, c43, c42, c41};

    assign P[1] = s11;
    assign P[2] = s21;
    assign P[3] = s22;
    assign P[4] = s23;
    assign P[5] = s24;
    assign P[6] = s25;
    assign P[7] = s31;

    ripple_carry_adder_16bit final_adder (
        .A(row1),
        .B(row2),
        .Sum(P[15:8])
    );

endmodule

// Half Adder Module
module half_adder(input A, input B, output Sum, output Carry);
    assign Sum = A ^ B;
    assign Carry = A & B;
endmodule

// Full Adder Module
module full_adder(input A, input B, input Cin, output Sum, output Carry);
    assign Sum = A ^ B ^ Cin;
    assign Carry = (A & B) | (B & Cin) | (A & Cin);
endmodule

// 16-bit Ripple Carry Adder
module ripple_carry_adder_16bit(
    input  [15:0] A,
    input  [15:0] B,
    output [7:0]  Sum
);
    wire [15:0] carry;
    assign carry[0] = 0;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : rca
            full_adder fa (
                .A(A[i]),
                .B(B[i]),
                .Cin(carry[i]),
                .Sum(Sum[i]),
                .Carry(carry[i+1])
            );
        end
    endgenerate
endmodule
