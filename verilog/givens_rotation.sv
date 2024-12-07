module givens_rotation (  // fully pipelined (I think?)
    input clk,
    input reset,
    input logic [31:0] a,
    input logic [31:0] b,
    output logic signed [31:0] cos,
    output logic signed [31:0] sin
);

    // logic [16:0] mag;
    // logic [19:0] theta;
    // //cordic cv (......,mode = 1'b0, .z(mag), .theta(theta)); //vectoring mode to find theta and magnitude

    parameter I_EXP = 8;
    parameter I_MNT = 23;
    parameter I_DATA = I_EXP + I_MNT + 1;

    logic [31:0] a_reg_array[0:20];
    logic [31:0] b_reg_array[0:20];
    logic a_valid_array[0:20], b_valid_array[0:20];

    logic [31:0] a_reg;
    logic [31:0] b_reg;
    logic a_valid, b_valid;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i =0; i < 21; i++) begin
                a_reg_array[i] <= 0;
                a_valid_array[i] <= 0;
                b_reg_array[i] <= 0;
                b_valid_array[i] <= 0;
            end
        end
        else begin
            a_reg_array[0] <= a;
            a_valid_array[0] <= 1'b1;
            b_reg_array[0] <= b;
            b_valid_array[0] <= 1'b1;
            for (int i =1; i < 21; i++) begin
                a_reg_array[i] <= a_reg_array[i-1];
                a_valid_array[i] <= a_valid_array[i-1];
                b_reg_array[i] <= b_reg_array[i-1];
                b_valid_array[i] <= a_valid_array[i-1];
            end
            a_reg <= a_reg_array[20];
            b_reg <= b_reg_array[20];
            a_valid <= a_valid_array[20];
            b_valid <= b_valid_array[20];
        end
    end


    logic [31:0] a_2;
    logic a_out_valid;
    logic [31:0] b_2;
    logic b_out_valid;
    logic [31:0] a_2_b_2; // a^2+b^2
    logic ab_out_valid;
    logic [31:0] sqrt_a_2_b_2; // sqrt(a^2+b^2)
    logic sqrt_out_valid;
    logic signed [31:0] c;
    logic signed [31:0] s;
    logic c_out_valid;
    logic s_out_valid;

    logic [31:0] a_2_reg;
    logic a_out_valid_reg;
    logic [31:0] b_2_reg;
    logic b_out_valid_reg;
    logic [31:0] a_2_b_2_reg; // a^2+b^2
    logic ab_out_valid_reg;
    logic [31:0] sqrt_a_2_b_2_reg; // sqrt(a^2+b^2)
    logic sqrt_out_valid_reg;
    logic signed [31:0] c_reg;
    logic signed [31:0] s_reg;
    logic c_out_valid_reg;
    logic s_out_valid_reg;

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

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            a_2_reg <= 0;
            a_out_valid_reg <= 0;
        end
        else begin
            a_2_reg <= a_2;
            a_out_valid_reg <= a_out_valid;
        end
    end

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

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            b_2_reg <= 0;
            b_out_valid_reg <= 0;
        end
        else begin
            b_2_reg <= b_2;
            b_out_valid_reg <= b_out_valid;
        end
    end

    fp_add #(
        .I_EXP(I_EXP),
        .I_MNT(I_MNT),
        .I_DATA(I_DATA)
    ) a2_b2 (
        .clk(clk),
        .reset(reset),
        .enable(a_out_valid_reg && b_out_valid_reg), //tie to out_valid to avoid processing garbage data
        .idataA(a_2_reg),
        .idataB(b_2_reg),
        .odata(a_2_b_2),
        .out_valid(ab_out_valid)
    );

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            a_2_b_2_reg <= 0;
            ab_out_valid_reg <= 0;
        end
        else begin
            a_2_b_2_reg <= a_2_b_2;
            ab_out_valid_reg <= ab_out_valid;
        end
    end

    inv_sqrt #(
        .I_EXP(I_EXP),
        .I_MNT(I_MNT),
        .I_DATA(I_DATA)
    ) sqrt (
        .clk(clk),
        .reset(reset),
	    .enable(ab_out_valid_reg),
        .idata(a_2_b_2_reg),
        .odata(sqrt_a_2_b_2),
        .out_valid(sqrt_out_valid)
    );

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            sqrt_a_2_b_2_reg <= 0;
            sqrt_out_valid_reg <= 0;
        end
        else begin
            sqrt_a_2_b_2_reg <= sqrt_a_2_b_2;
            sqrt_out_valid_reg <= sqrt_out_valid;
        end
    end


    fp_mul #(
        .I_EXP(I_EXP),
        .I_MNT(I_MNT),
        .I_DATA(I_DATA)
    ) c_ (
        .clk(clk),
        .reset(reset),
        .enable(sqrt_out_valid_reg),
        .idataA(a_reg),
        .idataB(sqrt_a_2_b_2_reg),
        .odata(c),
        .out_valid(c_out_valid)
    );
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            c_reg <= 0;
            c_out_valid_reg <= 0;
        end
        else begin
            c_reg <= c;
            c_out_valid_reg <= c_out_valid;
        end
    end



    fp_mul #(
        .I_EXP(I_EXP),
        .I_MNT(I_MNT),
        .I_DATA(I_DATA)
    ) s_ (
        .clk(clk),
        .reset(reset),
        .enable(sqrt_out_valid_reg),
        .idataA(b_reg),
        .idataB(sqrt_a_2_b_2_reg),
        .odata(s),
        .out_valid(s_out_valid)
    );

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            s_reg <= 0;
            s_out_valid_reg <= 0;
        end
        else begin
            s_reg <= s;
            s_out_valid_reg <= s_out_valid;
        end
    end



    always_ff @ (posedge clk or posedge reset) begin
        cos <= c_reg;
        if (s_reg[31] == 0) begin
            sin <= s_reg | 32'h80000000;
        end
        else begin
            sin <= s_reg & 32'h7FFFFFFF;
        end
        //sin <= s_reg | 32'h80000000;
    end



    //cordic cr (....., mode = 1'b1, .x_in(1), .y_in(0), .z_in(theta) .cordic_x(c), cordic_y(s)); // rotation mode to find sine and cosine


endmodule
