module butterfly_fp #(
    parameter W_R = 32'h3f800000,
    parameter W_I = 32'hbf800000,
    parameter I_EXP = 8,
    parameter I_MNT = 23,
    parameter I_DATA = I_EXP + I_MNT
)(
    input logic clk,
    input logic reset,
    input logic enable,

    input complex_fp_t A, 
    input complex_fp_t B,

    output complex_fp_t X,
    output complex_fp_t Y,
    output logic out_valid
);

// Calculate A+B, A-B
complex_fp_t A_B_sum, A_B_diff;
complex_fp_t B_negated;
logic AB_r_sum_valid, AB_i_sum_valid, AB_r_diff_valid, AB_i_diff_valid;

// AB Sum
fp_add #(
    .I_EXP(I_EXP),
    .I_MNT(I_MNT),
    .I_DATA(I_DATA)
) add_r (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .idataA(A.r),
    .idataB(B.r),
    .odata(A_B_sum.r),
    .out_valid(AB_r_sum_valid)
);

fp_add #(
    .I_EXP(I_EXP),
    .I_MNT(I_MNT),
    .I_DATA(I_DATA)
) add_i (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .idataA(A.i),
    .idataB(B.i),
    .odata(A_B_sum.i),
    .out_valid(AB_i_sum_valid)
);

// AB Diff
fp_add #(
    .I_EXP(I_EXP),
    .I_MNT(I_MNT),
    .I_DATA(I_DATA),
    .ADD_SUB(1'b1)
) sub_r (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .idataA(A.r),
    .idataB(B.r),
    .odata(A_B_diff.r),
    .out_valid(AB_r_diff_valid)
);

fp_add #(
    .I_EXP(I_EXP),
    .I_MNT(I_MNT),
    .I_DATA(I_DATA),
    .ADD_SUB(1'b1)
) sub_i (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .idataA(A.i),
    .idataB(B.i),
    .odata(A_B_diff.i),
    .out_valid(AB_i_diff_valid)
);

logic adder_sub_valid;

assign adder_sub_valid = AB_r_sum_valid & AB_i_sum_valid & AB_r_diff_valid & AB_i_diff_valid;

// Calculate W*(A-B), delay A+B by 3 cycles
logic [I_DATA-1:0] W_AB_diff_rr, W_AB_diff_ii, W_AB_diff_ri, W_AB_diff_ir;
logic W_AB_diff_rr_out_valid, W_AB_diff_ii_out_valid, W_AB_diff_ri_out_valid, W_AB_diff_ir_out_valid;

fp_mul #(
    .I_EXP(I_EXP),
    .I_MNT(I_MNT),
    .I_DATA(I_DATA)
) mul_rr (
    .clk(clk),
    .reset(reset),
    .enable(adder_sub_valid),
    .idataA(A_B_diff.r),
    .idataB(W_R),
    .odata(W_AB_diff_rr),
    .out_valid(W_AB_diff_rr_out_valid)
);

fp_mul #(
    .I_EXP(I_EXP),
    .I_MNT(I_MNT),
    .I_DATA(I_DATA)
) mul_ii (
    .clk(clk),
    .reset(reset),
    .enable(adder_sub_valid),
    .idataA(A_B_diff.i),
    .idataB(W_I),
    .odata(W_AB_diff_ii),
    .out_valid(W_AB_diff_ii_out_valid)
);

fp_mul #(
    .I_EXP(I_EXP),
    .I_MNT(I_MNT),
    .I_DATA(I_DATA)
) mul_ri (
    .clk(clk),
    .reset(reset),
    .enable(adder_sub_valid),
    .idataA(A_B_diff.r),
    .idataB(W_I),
    .odata(W_AB_diff_ri),
    .out_valid(W_AB_diff_ri_out_valid)
);

fp_mul #(
    .I_EXP(I_EXP),
    .I_MNT(I_MNT),
    .I_DATA(I_DATA)
) mul_ir (
    .clk(clk),
    .reset(reset),
    .enable(adder_sub_valid),
    .idataA(A_B_diff.i),
    .idataB(W_R),
    .odata(W_AB_diff_ir),
    .out_valid(W_AB_diff_ir_out_valid)
);

complex_fp_t Y_comb;
logic Y_comb_valid_r, Y_comb_valid_i;
logic Y_comb_valid;

fp_add #(
    .I_EXP(I_EXP),
    .I_MNT(I_MNT),
    .I_DATA(I_DATA),
    .ADD_SUB(1'b1)
) sub_1 (
    .clk(clk),
    .reset(reset),
    .enable(W_AB_diff_rr_out_valid & W_AB_diff_ii_out_valid),
    .idataA(W_AB_diff_rr),
    .idataB({~W_AB_diff_ii[I_DATA-1],W_AB_diff_ii[I_DATA-2:0]}),
    .odata(Y_comb.r),
    .out_valid(Y_comb_valid_r)
);

fp_add #(
    .I_EXP(I_EXP),
    .I_MNT(I_MNT),
    .I_DATA(I_DATA)
) add_1 (
    .clk(clk),
    .reset(reset),
    .enable(W_AB_diff_ri_out_valid & W_AB_diff_ir_out_valid),
    .idataA(W_AB_diff_ri),
    .idataB(W_AB_diff_ir),
    .odata(Y_comb.i),
    .out_valid(Y_comb_valid_i)
);

assign Y_comb_valid = Y_comb_valid_r & Y_comb_valid_i;

// Delay A+B by 3 cycles

complex_fp_t X_comb;
logic X_comb_valid;

delay #(
    .DELAY(3)
) delay_AB (
    .clk(clk),
    .reset(reset),
    .enable(adder_sub_valid),
    .in(A_B_sum),
    .out(X_comb),
    .out_valid(X_comb_valid)
);

assign X = X_comb;
assign Y = Y_comb;
assign out_valid = X_comb_valid & Y_comb_valid;





endmodule