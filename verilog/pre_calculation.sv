module pre_calculation(
    input logic [15:0] H_matrix_real[0:3][0:3],
    input logic [15:0] H_matrix_imag[0:3][0:3],
    input logic [15:0] signal_receive_real[0:3],
    input logic [15:0] signal_receive_imag[0:3],
    input unsigned [15:0] snr_real,
    input unsigned [15:0] snr_imag,

    output logic [15:0] matrix_A_real [0:3][0:3],
    output logic [15:0] matrix_A_imag [0:3][0:3],
    output logic [15:0] vector_b_real [0:3],
    output logic [15:0] vector_b_imag [0:3]
    
);

logic [15:0] H_hermitian_real[0:3][0:3];
logic [15:0] H_hermitian_imag[0:3][0:3];

for(int i=0; i<16;i++)begin
    for(int j=0;j<16;j++)begin
        H_hermitian_real[i][j]=H_matrix_real[j][i];
        H_hermitian_imag[i][j]=-H_matrix_imag[j][i];
    end
end
// get H^H

for(int i=0; i<16;i++)begin
    for(int j=0;j<16;j++)begin

        if(i=j)begin
            [matrix_A_real[i][j],matrix_A_imag[i][j]]=[snr_real,snr_imag];
        end else begin
            [matrix_A_real[i][j],matrix_A_imag[i][j]]=0;
        end
        for(int k=0;k<4;k++)begin
            [matrix_A_real[i][j],matrix_A_imag[i][j]]=[matrix_A_real[i][j],matrix_A_imag[i][j]] + complex_multi(H_hermitian_real[i][k],H_hermitian_imag[i][k],H_matrix_real[k][j],H_matrix_imag[k][j]);
        end
    end
end
// get matrix A

for (int i=0;i<4;i++)begin
    for(int j=0;j<4;j++)begin
        [vector_b_real[i],vector_b_imag[i]]=[vector_b_real[i],vector_b_imag[i]]+complex_multi(H_hermitian_real[i][j],H_hermitian_imag[i][j],signal_receive_real[j],signal_receive_imag[j]);
    end
end
// get vector B




endmodule