module givens_rotation (
    input clk,
    input reset
    input logic [31:0] a,
    input logic [31:0] b,
    output logic [31:0] cos,
    output logic [31:0] sin
);

    // logic [16:0] mag;
    // logic [19:0] theta;
    // //cordic cv (......,mode = 1'b0, .z(mag), .theta(theta)); //vectoring mode to find theta and magnitude

    local parameter I_EXP = 8,
    local parameter I_MNT = 23,
    local parameter I_DATA = I_EXP + I_MNT + 1


    logic [31:0] a_2;
    logic a_out_valid;
    logic [31:0] b_2;
    logic b_out_valid;
    logic [31:0] a_2_b_2; // a^2+b^2
    logic ab_out_valid;
    logic [31:0] sqrt_a_2_b_2; // sqrt(a^2+b^2)
    logic sqrt_out_valid;
    logic [31:0] c;
    logic [31:0] s;
    logic c_out_valid;
    logic s_out_valid;

    fp_mul #(
        .I_EXP(I_EXP),
        .I_MNT(I_MNT),
        .I_DATA(I_DATA)
    ) asq (
        .clk(clk),
        .reset(reset),
        .enable(1'b1),
        .idataA(a),
        .idataB(a),
        .odata(a_2),
        .out_valid(a_out_valid)
    );

    fp_mul #(
        .I_EXP(I_EXP),
        .I_MNT(I_MNT),
        .I_DATA(I_DATA)
    ) bsq (
        .clk(clk),
        .reset(reset),
        .enable(1'b1),
        .idataA(b),
        .idataB(b),
        .odata(b_2),
        .out_valid(b_out_valid)
    );

    fp_add #(
        .I_EXP(I_EXP),
        .I_MNT(I_MNT),
        .I_DATA(I_DATA)
    ) a2_b2 (
        .clk(clk),
        .reset(reset),
        .enable(1'b1), //tie to out_valid to avoid processing garbage data
        .idataA(a_2),
        .idataB(b_2),
        .odata(a_2_b_2),
        .out_valid(ab_out_valid)
    );

    inv_sqrt #(
        .I_EXP(I_EXP),
        .I_MNT(I_MNT),
        .I_DATA(I_DATA)
    ) sqrt (
        .clk(clk),
        .reset(reset),
        .idata(a_2_b_2),
        .odata(sqrt_a_2_b_2),
        .out_valid(sqrt_out_valid)
    );


    fp_mul #(
        .I_EXP(I_EXP),
        .I_MNT(I_MNT),
        .I_DATA(I_DATA)
    ) c (
        .clk(clk),
        .reset(reset),
        .enable(1'b1),
        .idataA(a),
        .idataB(sqrt_a_2_b_2),
        .odata(c),
        .out_valid(c_out_valid)
    );


    fp_mul #(
        .I_EXP(I_EXP),
        .I_MNT(I_MNT),
        .I_DATA(I_DATA)
    ) s (
        .clk(clk),
        .reset(reset),
        .enable(1'b1),
        .idataA(b),
        .idataB(sqrt_a_2_b_2),
        .odata(s),
        .out_valid(s_out_valid)
    );

    always @ (posedge clk or negedge reset) begin
        cos <= c;
        sin <= -s;
    end


    //cordic cr (....., mode = 1'b1, .x_in(1), .y_in(0), .z_in(theta) .cordic_x(c), cordic_y(s)); // rotation mode to find sine and cosine


endmodule