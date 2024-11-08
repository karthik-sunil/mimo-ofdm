module QR_decomposition(
    input clk;
    input reset;
    input logic[31:0] matrix[0:3][0:3];
    output logic[31:0] Q_matrix[0:3][0:3];
    output logic[31:0] R_matrix[0:3][0:3];
);
//assume fixed point (16,8)

logic[31:0] Q [0:3][0:3];
logic[31:0] R [0:3][0:3];
integer i,j;
for (i=0; i<4; i++) begin
    for (j=0; j<4; j++) begin
        R[i][j] = matrix[i][j];
        if (i==j) begin
            Q[i][j] = 32'h3F800000;
        end
        else begin
            Q[i][j] = 0;
        end
    end 
end

logic[31:0] c;
logic[31:0] s;
logic[31:0] G [0:3][0:3];
logic[31:0] G_t [0:3][0:3];
for (i=0; i<4; i++) begin
    for (j=0; j<4; j++) begin
        G[i][j] = (i==j)? 16'd256 : 0;
        if (j >= i+1) begin
            givens_rotation (.clk(clk), .reset(reset), .a(matrix[i][i]), .b(matrix[j][i]), .c(c), .s(s));
            G[i][i] = c;
            G[i][j] = -s;
            G[j][i] = s;
            G[j][j] = c;
        end

        matmul GR (.a(G), .b(R), .result(R));
        transpose GT (.a(G), .a_t(G_t));
        matmul QGT (.a(Q), .b(G_t), .out(Q));
    end
end



always_ff (@posedge clk or negedge reset) begin
    if (!reset) begin 
        for (i=0; i<4; i++) begin
            for (j=0; j<4; j++) begin
                Q_matrix[i][j] <= 0;
                R_matrix[i][j] <= 0;
            end
        end
    end
    else begin
        for (i=0; i<4; i++) begin
            for (j=0; j<4; j++) begin
                Q_matrix[i][j] <= Q[i][j];
                R_matrix[i][j] <= R[i][j];
            end
        end
    end
end

endmodule


