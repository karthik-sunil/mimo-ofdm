module transpose(
    input  logic signed [31:0] a [0:3][0:3],
    output logic signed [31:0] a_t [0:3][0:3]
);

    always_comb begin
        for (int i = 0; i < 4; i++) begin
            for (int j = 0; j < 4; j++) begin
                a_t[j][i] = a[i][j];
            end
        end
    end

endmodule