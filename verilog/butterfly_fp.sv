module butterfly_fp #(
    parameter W_R = 32'h3f800000,
    parameter W_I = 32'hbf800000
) (
    input logic clk,
    input logic reset,
    input logic enable,

    input complex_fp_t A, 
    input complex_fp_t B,

    output complex_fp_t X,
    output complex_fp_t Y,
    output logic out_valid
);

// Calculate the complex product of B and W
complex_fp_t B_W;
logic [I_DATA-1:0] B_W_rr, B_W_ii, B_W_ri, B_W_ir;
logic out_valid_mul_0, out_valid_mul_1, out_valid_mul_2, out_valid_mul_3;

// B.r * W_R
fp_mul #(
    .I_EXP(I_EXP),
    .I_MNT(I_MNT),
    .I_DATA(I_DATA)
) mul_0 (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .idataA(B.r),
    .idataB(W_R),
    .odata(B_W_rr),
    .out_valid(out_valid_mul_0)
);

// B.i * W_I
fp_mul #(
    .I_EXP(I_EXP),
    .I_MNT(I_MNT),
    .I_DATA(I_DATA)
) mul_1 (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .idataA(B.i),
    .idataB(W_I),
    .odata(B_W_ii),
    .out_valid(out_valid_mul_1)
);

// B.r * W_I
fp_mul #(
    .I_EXP(I_EXP),
    .I_MNT(I_MNT),
    .I_DATA(I_DATA)
) mul_2 (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .idataA(B.r),
    .idataB(W_I),
    .odata(B_W_ri),
    .out_valid(out_valid_mul_2)
);

// B.i * W_R
fp_mul #(
    .I_EXP(I_EXP),
    .I_MNT(I_MNT),
    .I_DATA(I_DATA)
) mul_3 (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .idataA(B.i),
    .idataB(W_R),
    .odata(B_W_ir),
    .out_valid(out_valid_mul_3)
);

logic out_valid_add_0, out_valid_add_1;

// Combine the results of the four multiplications
fp_add #(
    .I_EXP(I_EXP),
    .I_MNT(I_MNT),
    .I_DATA(I_DATA)
) add_0 (
    .clk(clk),
    .reset(reset),
    .enable(out_valid_mul_0 & out_valid_mul_1),
    .idataA(B_W_rr),
    .idataB({~B_W_ii[I_DATA],B_W_ii[I_DATA-2:0]}),
    .odata(B_W.r),
    .out_valid(out_valid_add_0)
);

fp_add #(
    .I_EXP(I_EXP),
    .I_MNT(I_MNT),
    .I_DATA(I_DATA)
) add_1 (
    .clk(clk),
    .reset(reset),
    .enable(out_valid_mul_2 & out_valid_mul_3),
    .idataA(B_W_ri),
    .idataB(B_W_ir),
    .odata(B_W.i),
    .out_valid(out_valid_add_1)
);

// Calculate the complex sum of A and B_W
complex_fp_t X_comb, Y_comb;
logic out_valid_add_AB_0, out_valid_add_AB_1, out_valid_add_AB_2, out_valid_add_AB_3;

// A.r + B_W.r
fp_add #(
    .I_EXP(I_EXP),
    .I_MNT(I_MNT),
    .I_DATA(I_DATA),
    .ADD_SUB(1'b0)
) add_AB_rr (
    .clk(clk),
    .reset(reset),
    .enable(out_valid_add_0 & out_valid_add_1),
    .idataA(A.r),
    .idataB(B_W.r),
    .odata(X_comb.r),
    .out_valid(out_valid_add_AB_0)
);

// A.i + B_W.i
fp_add #(
    .I_EXP(I_EXP),
    .I_MNT(I_MNT),
    .I_DATA(I_DATA),
    .ADD_SUB(1'b0)
) add_AB_ii (
    .clk(clk),
    .reset(reset),
    .enable(out_valid_add_0 & out_valid_add_1),
    .idataA(A.i),
    .idataB(B_W.i),
    .odata(X_comb.i),
    .out_valid(out_valid_add_AB_1)
);

// A.r - B_W.r
fp_add #(
    .I_EXP(I_EXP),
    .I_MNT(I_MNT),
    .I_DATA(I_DATA),
    .ADD_SUB(1'b1)
) add_AB_ri (
    .clk(clk),
    .reset(reset),
    .enable(out_valid_add_0 & out_valid_add_1),
    .idataA(A.r),
    .idataB(B_W.r),
    .odata(Y_comb.r),
    .out_valid(out_valid_add_AB_2)
);

// A.i - B_W.i
fp_add #(
    .I_EXP(I_EXP),
    .I_MNT(I_MNT),
    .I_DATA(I_DATA),
    .ADD_SUB(1'b1)
) add_AB_ir (
    .clk(clk),
    .reset(reset),
    .enable(out_valid_add_0 & out_valid_add_1),
    .idataA(A.i),
    .idataB(B_W.i),
    .odata(Y_comb.i),
    .out_valid(out_valid_add_AB_3)
);

// Assign the outputs
assign X = X_comb;
assign Y = Y_comb;
assign out_valid = out_valid_add_AB_0 & out_valid_add_AB_1 & out_valid_add_AB_2 & out_valid_add_AB_3;



endmodule 