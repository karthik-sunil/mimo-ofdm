module QR_decomp3(
    input logic clk,
    input logic reset,
    input logic [31:0] matrix [0:3][0:3], // Input matrix
    output logic [31:0] Q_matrix [0:3][0:3], // Output Q matrix
    output logic [31:0] R_matrix [0:3][0:3]  // Output R matrix
);

    logic [31:0] Q [0:3][0:3]; // Q matrix
    logic [31:0] R [0:3][0:3]; // R matrix
    // logic [31:0] R_temp [0:5][0:3][0:3]; // Temporary R matrix
    // logic [31:0] Q_temp [0:5][0:3][0:3]; // Temporary Q matrix
    // logic [31:0] G [0:5][0:3][0:3]; // Givens rotation matrix initialization
    logic [31:0] G [0:3][0:3];
    // logic [31:0] G_m [0:5][0:3][0:3]; // Givens rotation matrix
    // logic [31:0] G_t [0:5][0:3][0:3]; // Transpose of G matrix
    //logic [31:0] c, s; // Cosine and Sine from Givens rotation

    // Initialize Q and R matrices
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize Q as identity matrix and R as input matrix
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Q[i][j] <= (i == j) ? 32'h3F800000 : 32'h00000000; // Identity matrix (1.0 for diagonal)
                    R[i][j] <= matrix[i][j]; // Copy input matrix to R
                    G[i][j] <= (i == j) ? 32'h3F800000 : 32'h00000000; // Identity matrix (1.0 for diagonal)
                    //G_t[k][i][j] <= (i == j) ? 32'h3F800000 : 32'h00000000; // Identity matrix (1.0 for diagonal)
                end
            end
        end
    end
    




    logic [31:0] c1, s1;
    logic [31:0] c2, s2;
    logic [31:0] c3, s3;
    logic [31:0] c4, s4;
    logic [31:0] c5, s5;
    logic [31:0] c6, s6;
    logic [31:0] Gm1 [0:3][0:3]; // givens matrix
    logic [31:0] Gm2 [0:3][0:3];
    logic [31:0] Gm3 [0:3][0:3];
    logic [31:0] Gm4 [0:3][0:3];
    logic [31:0] Gm5 [0:3][0:3];
    logic [31:0] Gm6 [0:3][0:3];
    logic [31:0] R1 [0:3][0:3];
    logic [31:0] R2 [0:3][0:3];
    logic [31:0] R3 [0:3][0:3];
    logic [31:0] R4 [0:3][0:3];
    logic [31:0] R5 [0:3][0:3];
    logic [31:0] R6 [0:3][0:3];
    logic [31:0] Gm_t1 [0:3][0:3]; // givens matrix transpose
    logic [31:0] Gm_t2 [0:3][0:3];
    logic [31:0] Gm_t3 [0:3][0:3];
    logic [31:0] Gm_t4 [0:3][0:3];
    logic [31:0] Gm_t5 [0:3][0:3];
    logic [31:0] Gm_t6 [0:3][0:3];
    logic [31:0] Q1 [0:3][0:3];
    logic [31:0] Q2 [0:3][0:3];
    logic [31:0] Q3 [0:3][0:3];
    logic [31:0] Q4 [0:3][0:3];
    logic [31:0] Q5 [0:3][0:3];
    logic [31:0] Q6 [0:3][0:3];

    logic [31:0] c1r, s1r; // pipeline regiester
    logic [31:0] c2r, s2r;
    logic [31:0] c3r, s3r;
    logic [31:0] c4r, s4r;
    logic [31:0] c5r, s5r;
    logic [31:0] c6r, s6r;
    logic [31:0] Gm1r [0:3][0:3]; // givens matrix
    logic [31:0] Gm2r [0:3][0:3];
    logic [31:0] Gm3r [0:3][0:3];
    logic [31:0] Gm4r [0:3][0:3];
    logic [31:0] Gm5r [0:3][0:3];
    logic [31:0] Gm6r [0:3][0:3];
    logic [31:0] R1r [0:3][0:3];
    logic [31:0] R2r [0:3][0:3];
    logic [31:0] R3r [0:3][0:3];
    logic [31:0] R4r [0:3][0:3];
    logic [31:0] R5r [0:3][0:3];
    logic [31:0] R6r [0:3][0:3];
    logic [31:0] Gm_t1r [0:3][0:3]; // givens matrix transpose
    logic [31:0] Gm_t2r [0:3][0:3];
    logic [31:0] Gm_t3r [0:3][0:3];
    logic [31:0] Gm_t4r [0:3][0:3];
    logic [31:0] Gm_t5r [0:3][0:3];
    logic [31:0] Gm_t6r [0:3][0:3];
    logic [31:0] Q1r [0:3][0:3];
    logic [31:0] Q2r [0:3][0:3];
    logic [31:0] Q3r [0:3][0:3];
    logic [31:0] Q4r [0:3][0:3];
    logic [31:0] Q5r [0:3][0:3];
    logic [31:0] Q6r [0:3][0:3];


    // i=0, j=1
    //givens_rotation g(.clk(clk), .reset(reset), .a(R[i][i]), .b(R[j][i]),.cos(c),.sin(s));
    givens_rotation g1(.clk(clk), .reset(reset), .a(R[0][0]), .b(R[1][0]),.cos(c1),.sin(s1));
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            c1r <= 0;
            s1r <= 0;
        end
        else begin
            c1r <= c1;
            s1r <= s1;
        end
    end
    givens_matrix gm1(.G(G), .c(c1r), .s(s1r), .i(2'd0), .j(2'd1), .out(Gm1));
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Gm1r[i][j] <= 0;
                end
            end
        end
        else begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Gm1r[i][j] <= Gm1[i][j];
                end
            end
        end
    end
    matmul GR1 (.clk(clk), .reset(reset), .a(Gm1r), .b(R), .out(R1));
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    R1r[i][j] <= 0;
                end
            end
        end
        else begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    R1r[i][j] <= R1[i][j];
                end
            end
        end
    end
    transpose GT1 (.a(Gm1r), .a_t(Gm_t1));
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Gm_t1r[i][j] <= 0;
                end
            end
        end
        else begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Gm_t1r[i][j] <= Gm_t1[i][j];
                end
            end
        end
    end
    matmul QGT1 (.clk(clk), .reset(reset), .a(Q), .b(Gm_t1r), .out(Q1));
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Q1r[i][j]  <= 0;
                end
            end
        end
        else begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Q1r[i][j] <= Q1[i][j];
                end
            end
        end
    end



    // i=0, j=2
    givens_rotation g2(.clk(clk), .reset(reset), .a(R1[0][0]), .b(R1[2][0]),.cos(c2),.sin(s2));
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            c2r <= 0;
            s2r <= 0;
        end
        else begin
            c2r <= c2;
            s2r <= s2;
        end
    end
    givens_matrix gm2(.G(G), .c(c2), .s(s2), .i(2'd0), .j(2'd2), .out(Gm2));
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Gm2r[i][j] <= 0;
                end
            end
        end
        else begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Gm2r[i][j] <= Gm2[i][j];
                end
            end
        end
    end
    matmul GR2 (.clk(clk), .reset(reset), .a(Gm2), .b(R1), .out(R2));
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    R2r[i][j] <= 0;
                end
            end
        end
        else begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    R2r[i][j] <= R2[i][j];
                end
            end
        end
    end
    transpose GT2 (.a(Gm2), .a_t(Gm_t2));
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Gm_t2r[i][j] <= 0;
                end
            end
        end
        else begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Gm_t2r[i][j] <= Gm_t2[i][j];
                end
            end
        end
    end
    matmul QGT2 (.clk(clk), .reset(reset), .a(Q1), .b(Gm_t2), .out(Q2));
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Q2r[i][j]  <= 0;
                end
            end
        end
        else begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Q2r[i][j] <= Q2[i][j];
                end
            end
        end
    end

    

    // i=0, j=3
    givens_rotation g3(.clk(clk), .reset(reset), .a(R2[0][0]), .b(R2[3][0]),.cos(c3),.sin(s3));
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            c3r <= 0;
            s3r <= 0;
        end
        else begin
            c3r <= c3;
            s3r <= s3;
        end
    end
    givens_matrix gm3(.G(G), .c(c3), .s(s3), .i(2'd0), .j(2'd3), .out(Gm3));
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Gm3r[i][j] <= 0;
                end
            end
        end
        else begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Gm3r[i][j] <= Gm3[i][j];
                end
            end
        end
    end
    matmul GR3 (.clk(clk), .reset(reset), .a(Gm3), .b(R2), .out(R3));
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    R3r[i][j] <= 0;
                end
            end
        end
        else begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    R3r[i][j] <= R3[i][j];
                end
            end
        end
    end
    transpose GT3 (.a(Gm3), .a_t(Gm_t3));
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Gm_t3r[i][j] <= 0;
                end
            end
        end
        else begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Gm_t3r[i][j] <= Gm_t3[i][j];
                end
            end
        end
    end
    matmul QGT3 (.clk(clk), .reset(reset), .a(Q2), .b(Gm_t3), .out(Q3));
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Q3r[i][j]  <= 0;
                end
            end
        end
        else begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Q3r[i][j] <= Q3[i][j];
                end
            end
        end
    end

    // i=1, j=2
    givens_rotation g4(.clk(clk), .reset(reset), .a(R3[1][1]), .b(R3[2][1]),.cos(c4),.sin(s4));
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            c4r <= 0;
            s4r <= 0;
        end
        else begin
            c4r <= c4;
            s4r <= s4;
        end
    end
    givens_matrix gm4(.G(G), .c(c4), .s(s4), .i(2'd1), .j(2'd2), .out(Gm4));
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Gm4r[i][j] <= 0;
                end
            end
        end
        else begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Gm4r[i][j] <= Gm4[i][j];
                end
            end
        end
    end
    matmul GR4 (.clk(clk), .reset(reset), .a(Gm4), .b(R3), .out(R4));
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    R4r[i][j] <= 0;
                end
            end
        end
        else begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    R4r[i][j] <= R4[i][j];
                end
            end
        end
    end
    transpose GT4 (.a(Gm4), .a_t(Gm_t4));
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Gm_t4r[i][j] <= 0;
                end
            end
        end
        else begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Gm_t4r[i][j] <= Gm_t4[i][j];
                end
            end
        end
    end
    matmul QGT4 (.clk(clk), .reset(reset), .a(Q3), .b(Gm_t4), .out(Q4));
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Q4r[i][j]  <= 0;
                end
            end
        end
        else begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Q4r[i][j] <= Q4[i][j];
                end
            end
        end
    end

    // i=1, j=3
    givens_rotation g5(.clk(clk), .reset(reset), .a(R4[1][1]), .b(R4[3][1]),.cos(c5),.sin(s5));
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            c5r <= 0;
            s5r <= 0;
        end
        else begin
            c5r <= c5;
            s5r <= s5;
        end
    end
    givens_matrix gm5(.G(G), .c(c5), .s(s5), .i(2'd1), .j(2'd3), .out(Gm5));
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Gm5r[i][j] <= 0;
                end
            end
        end
        else begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Gm5r[i][j] <= Gm5[i][j];
                end
            end
        end
    end
    matmul GR5 (.clk(clk), .reset(reset), .a(Gm5), .b(R4), .out(R5));
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    R5r[i][j] <= 0;
                end
            end
        end
        else begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    R5r[i][j] <= R5[i][j];
                end
            end
        end
    end
    transpose GT5 (.a(Gm5), .a_t(Gm_t5));
        always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Gm_t5r[i][j] <= 0;
                end
            end
        end
        else begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Gm_t5r[i][j] <= Gm_t5[i][j];
                end
            end
        end
    end
    matmul QGT5 (.clk(clk), .reset(reset), .a(Q4), .b(Gm_t5), .out(Q5));
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Q5r[i][j]  <= 0;
                end
            end
        end
        else begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Q5r[i][j] <= Q5[i][j];
                end
            end
        end
    end
    // i=2, j=3
    givens_rotation g6(.clk(clk), .reset(reset), .a(R5[2][2]), .b(R5[3][2]),.cos(c6),.sin(s6));
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            c6r <= 0;
            s6r <= 0;
        end
        else begin
            c6r <= c6;
            s6r <= s6;
        end
    end
    givens_matrix gm6(.G(G), .c(c6), .s(s6), .i(2'd2), .j(2'd3), .out(Gm6));
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Gm6r[i][j] <= 0;
                end
            end
        end
        else begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Gm6r[i][j] <= Gm6[i][j];
                end
            end
        end
    end
    matmul GR6 (.clk(clk), .reset(reset), .a(Gm6), .b(R5), .out(R6));
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    R6r[i][j] <= 0;
                end
            end
        end
        else begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    R6r[i][j] <= R6[i][j];
                end
            end
        end
    end
    transpose GT6 (.a(Gm6), .a_t(Gm_t6));
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Gm_t6r[i][j] <= 0;
                end
            end
        end
        else begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Gm_t6r[i][j] <= Gm_t6[i][j];
                end
            end
        end
    end
    matmul QGT6 (.clk(clk), .reset(reset), .a(Q5), .b(Gm_t6), .out(Q6));
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Q6r[i][j]  <= 0;
                end
            end
        end
        else begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Q6r[i][j] <= Q6[i][j];
                end
            end
        end
    end


    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize Q as identity matrix and R as input matrix
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Q_matrix[i][j] <= 0;
                    R_matrix[i][j] <= 0;
                end
            end
        end
        else begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Q_matrix[i][j] <= Q6[i][j];
                    R_matrix[i][j] <= R6[i][j];
                end
            end
        end
    end



endmodule