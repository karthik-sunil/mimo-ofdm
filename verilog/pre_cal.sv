`include "matmul.sv"
module pre_cal(
    input logic clk,
    input logic reset,
    input logic [31:0] H_matrix[0:3][0:3],
    input logic [31:0] signal_receive[0:3],
    input logic [31:0] snr,

    output logic [31:0] matrix_A [0:3][0:3],
    output logic [31:0] vector_b [0:3]
    
);

logic [31:0] H_hermitian [0:3][0:3];
logic [31:0] A_add [0:3][0:3];
logic [31:0] A_mul [0:3][0:3];
logic [31:0] matrix_sig [0:3][0:3];
logic [31:0] matrix_b [0:3][0:3];


always_comb begin
    for(int i=0; i<4;i++)begin
        for(int j=0;j<4;j++)begin
            H_hermitian[i][j]=H_matrix[j][i];
        end
    end
end
// get H^H

matmul m1(

    .a(H_hermitian),
    .b(H_matrix),
    .out(A_mul)
);
always_comb begin
    for(int i=0; i<4;i++)begin
        for(int j=0;j<4;j++)begin

            if(i==j) begin
                A_add[i][j]=snr;
            end else begin
                A_add[i][j]=0;
            end
            matrix_A[i][j]=A_mul[i][j]+A_add[i][j];
            
        end
    end
end

// get matrix A= H^H * H + snr* I
always_comb begin
    for (int i=0;i<4;i++)begin
        for(int j=0;j<4;j++)begin
            if(i==0)begin
                matrix_sig[i][j]=signal_receive[j];
            end else begin
                matrix_sig[i][j]=0;
            end
        end
    end
end

matmul m2(

    .a(H_hermitian),
    .b(matrix_sig),
    .out(matrix_b)
);

always_comb begin
    for(int i=0;i<4;i++)begin
        vector_b[i]=matrix_b[0][i];
    end
end
// get vector B= H^H * r




endmodule
