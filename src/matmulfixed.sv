module matmulfixed(
    input logic signed [31:0] a [0:3][0:3],  //(16,8) MAXIMUM # 2(?) TO BE ACCURATE (DIDN'T KEEP THE MOST SIGNIFICANT BITS FOR MULT)
    input logic signed [31:0] b [0:3][0:3],  
    output logic signed [31:0] out [0:3][0:3]
);

    // Multiply matrices A and B to get matrix C
    logic signed[34:0] temp [0:3][0:3];
    always_comb begin
        for (int i = 0; i < 4; i++) begin
            for (int j = 0; j < 4; j++) begin
                temp[i][j] = 0;  // Initialize element
                for (int k = 0; k < 4; k++) begin
                    temp[i][j] += a[i][k] * b[k][j];
                end
                out[i][j] = temp[i][j][26:11]; //???
            end
        end
    end
endmodule