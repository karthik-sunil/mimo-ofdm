
module pre_cal(
    input logic clk,
    input logic reset,
    input logic signed [31:0] H_matrix[0:3][0:3],
    input logic signed [31:0] signal_receive[0:3],
    input logic signed [31:0] snr,

    output logic signed [31:0] matrix_A [0:3][0:3],
    output logic signed [31:0] vector_b [0:3]
    
);
//registers
logic signed [31:0] input_H[0:3][0:3];
logic signed [31:0] input_sig[0:3];
logic signed [31:0] input_snr;


logic signed [31:0] H_hermitian [0:3][0:3];
logic signed [31:0] A_add ;
logic signed [31:0] A_mul [0:3][0:3];
logic signed [31:0] matrix_sig [0:3][0:3];
logic signed [31:0] matrix_b [0:3][0:3];


always_comb begin
    for(int i=0; i<4;i++)begin
        for(int j=0;j<4;j++)begin
            H_hermitian[i][j]=input_H[j][i];
        end
    end
end
// get H^H

matmul m1(
    .clk(clk),
    .reset(reset),
    .a(H_hermitian),
    .b(input_H),
    .out(A_mul)
);
always_comb begin
    for(int i=0; i<4;i++)begin
        for(int j=0;j<4;j++)begin

            if(i==j) begin
                matrix_A[i][j]=A_mul[i][j]+input_snr;
            end else begin
                matrix_A[i][j]=A_mul[i][j];
            end
            
            
        end
    end
end

// get matrix A= H^H * H + snr* I
always_comb begin
    for (int i=0;i<4;i++)begin
        for(int j=0;j<4;j++)begin
            if(i==0)begin
                matrix_sig[i][j]=input_sig[j];
            end else begin
                matrix_sig[i][j]=0;
            end
        end
    end
end

matmul m2(
    .clk(clk),
    .reset(reset),
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

always_ff @(posedge clk) begin
    if(reset)begin

    end else begin
        input_H <= H_matrix;
        input_sig <= signal_receive;
        input_snr <= snr;
    end

end




endmodule
