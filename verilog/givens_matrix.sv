module givens_matrix(
    input logic [31:0] G [0:3][0:3],
    input logic [31:0] c,
    input logic [31:0] s,
    input logic [1:0] i,
    input logic [1:0] j,
    output logic [31:0] out [0:3][0:3]
);
    always_comb begin
        for (int m=0; m<4; m++) begin
            for (int n =0; n<4; n++) begin
                out[m][n] = G[m][n];
            end
        end
        out[i][i] = c;
        out[j][i] = s;
        if (s[31] == 0) begin
            out[i][j] = s | 32'h80000000;
        end
        else begin
            out[i][j] = s & 32'h7FFFFFFF;
        end
                    
        out[j][j] = c;
                
    end




endmodule


// $(wildcard \
// 	QR_decomp2.sv\
// 	givens_rotation.sv\
// 	givens_matrix.sv\
// 	matmul.sv\
// 	transpose.sv\
// 	fp_mul.sv \
// 	fp_add.sv \
// 	inv_sqrt.sv \
// 	delay.sv\
// )