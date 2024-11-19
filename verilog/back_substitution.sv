module back_substitution(
    input complex_fp_t matrix_R_real [0:3][0:3],

    input complex_fp_t vector_Rx_real [0:3],

    output complex_fp_t vector_x_real[0:3],


);

complex_fp_t matrix_R_inv_real [0:3][0:3];
complex_fp_t matrix_R_inv_imag [0:3][0:3];

for(int i=0;i<4;i++)begin
    for(int j=0;j<4;j++)begin
        if(i==j)begin
            [matrix_R_inv_real[i][j],matrix_R_inv_imag[i][j]]=complex_divide(1,0,matrix_R_real[i][j],matrix_R_imag[i][j]);
        end else begin
            matrix_R_inv_real[i][j]=0;
            matrix_R_inv_imag[i][j]=0;
        end
    end
end

matrix_R_inv[0][1]=-complex_divide(1,0,matrix_R[0][1],(matrix_R[0][0]*matrix_R[1][1]));


matrix_R_inv[1][2]=-matrix_R[1][2]/(matrix_R[1][1]*matrix_R[2][2]);
matrix_R_inv[2][3]=-matrix_R[2][3]/(matrix_R[2][2]*matrix_R[3][3]);

matrix_R_inv[0][2]=(matrix_R[0][1]*matrix_R[1][2]/matrix_R[1][1]-matrix_R[0][2])/(matrix_R[0][0]*matrix_R[2][2]);
matrix_R_inv[1][3]=(matrix_R[1][2]*matrix_R[2][3]/matrix_R[2][2]-matrix_R[1][3])/(matrix_R[1][1]*matrix_R[3][3]);

matrix_R_inv[0][3]=-1/(matrix_R[0][0]*matrix_R[3][3])*(matrix_R[0][1]/matrix_R[1][1]*(matrix_R[1][2]*matrix_R[2][3]/matrix_R[2][2]-matrix_R[1][3])-matrix_R[0][2]*matrix_R[2][3]/matrix_R[2][2]+matrix_R[0][3]);

//get R^-1


endmodule