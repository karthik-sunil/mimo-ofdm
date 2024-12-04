module QR_decomp4(
    input logic clk,
    input logic reset,
    input logic signed [31:0] matrix [0:3][0:3], // Input matrix
    output logic signed [31:0] Q_matrix [0:3][0:3], // Output Q matrix
    output logic signed [31:0] R_matrix [0:3][0:3]  // Output R matrix
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
    logic QR_valid;

    // Initialize Q and R matrices
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize Q as identity matrix and R as input matrix
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    Q[i][j] <= 0; // Identity matrix (1.0 for diagonal)
                    R[i][j] <= 0; // Copy input matrix to R
                    G[i][j] <= 0; // Identity matrix (1.0 for diagonal)
                    //G_t[k][i][j] <= (i == j) ? 32'h3F800000 : 32'h00000000; // Identity matrix (1.0 for diagonal)
                end
            end
        end
        else begin
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


    
    // i=0, j=1
    //givens_rotation g(.clk(clk), .reset(reset), .a(R[i][i]), .b(R[j][i]),.cos(c),.sin(s));
    givens_rotation g1(.clk(clk), .reset(reset), .a(R[0][0]), .b(R[1][0]),.cos(c1),.sin(s1)); //25 cycle
    givens_matrix gm1(.clk(clk), .reset(reset), .G(G), .c(c1), .s(s1), .i(2'd0), .j(2'd1), .out(Gm1)); // 1cycle
    matmul GR1 (.clk(clk), .reset(reset), .a(Gm1), .b(R), .out(R1)); // 10 cycle
    transpose GT1 (.clk(clk), .reset(reset), .a(Gm1), .a_t(Gm_t1)); // 1cycle
    matmul QGT1 (.clk(clk), .reset(reset), .a(Q), .b(Gm_t1), .out(Q1)); // 10cycle
    

    // i=0, j=2
    givens_rotation g2(.clk(clk), .reset(reset), .a(R1[0][0]), .b(R1[2][0]),.cos(c2),.sin(s2));    
    givens_matrix gm2(.clk(clk), .reset(reset), .G(G), .c(c2), .s(s2), .i(2'd0), .j(2'd2), .out(Gm2));
    matmul GR2 (.clk(clk), .reset(reset), .a(Gm2), .b(R1), .out(R2));   
    transpose GT2 (.clk(clk), .reset(reset), .a(Gm2), .a_t(Gm_t2));
    matmul QGT2 (.clk(clk), .reset(reset), .a(Q1), .b(Gm_t2), .out(Q2));
    

    // i=0, j=3
    givens_rotation g3(.clk(clk), .reset(reset), .a(R2[0][0]), .b(R2[3][0]),.cos(c3),.sin(s3));
    givens_matrix gm3(.clk(clk), .reset(reset), .G(G), .c(c3), .s(s3), .i(2'd0), .j(2'd3), .out(Gm3));
    matmul GR3 (.clk(clk), .reset(reset), .a(Gm3), .b(R2), .out(R3));
    transpose GT3 (.clk(clk), .reset(reset), .a(Gm3), .a_t(Gm_t3));
    matmul QGT3 (.clk(clk), .reset(reset), .a(Q2), .b(Gm_t3), .out(Q3));


    // i=1, j=2
    givens_rotation g4(.clk(clk), .reset(reset), .a(R3[1][1]), .b(R3[2][1]),.cos(c4),.sin(s4));
    givens_matrix gm4(.clk(clk), .reset(reset), .G(G), .c(c4), .s(s4), .i(2'd1), .j(2'd2), .out(Gm4));
    matmul GR4 (.clk(clk), .reset(reset), .a(Gm4), .b(R3), .out(R4));
    transpose GT4 (.clk(clk), .reset(reset), .a(Gm4), .a_t(Gm_t4));
    matmul QGT4 (.clk(clk), .reset(reset), .a(Q3), .b(Gm_t4), .out(Q4));

    // i=1, j=3
    givens_rotation g5(.clk(clk), .reset(reset), .a(R4[1][1]), .b(R4[3][1]),.cos(c5),.sin(s5));
    givens_matrix gm5(.clk(clk), .reset(reset), .G(G), .c(c5), .s(s5), .i(2'd1), .j(2'd3), .out(Gm5));
    matmul GR5 (.clk(clk), .reset(reset), .a(Gm5), .b(R4), .out(R5));
    transpose GT5 (.clk(clk), .reset(reset), .a(Gm5), .a_t(Gm_t5));
    matmul QGT5 (.clk(clk), .reset(reset), .a(Q4), .b(Gm_t5), .out(Q5));

    // i=2, j=3
    givens_rotation g6(.clk(clk), .reset(reset), .a(R5[2][2]), .b(R5[3][2]),.cos(c6),.sin(s6));
    givens_matrix gm6(.clk(clk), .reset(reset), .G(G), .c(c6), .s(s6), .i(2'd2), .j(2'd3), .out(Gm6));
    matmul GR6 (.clk(clk), .reset(reset), .a(Gm6), .b(R5), .out(R6));
    transpose GT6 (.clk(clk), .reset(reset), .a(Gm6), .a_t(Gm_t6));
    matmul QGT6 (.clk(clk), .reset(reset), .a(Q5), .b(Gm_t6), .out(Q6));


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