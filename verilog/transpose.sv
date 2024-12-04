module transpose(
    input clk,
    input reset,
    input  logic signed [31:0] a [0:3][0:3],
    output logic signed [31:0] a_t [0:3][0:3]
);

    logic signed [31:0] transpose [0:3][0:3];

    always_comb begin
        for (int i = 0; i < 4; i++) begin
            for (int j = 0; j < 4; j++) begin
                transpose[j][i] = a[i][j];
            end
        end
    end

    always_ff @ (posedge clk) begin
        if (reset) begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    a_t[i][j] <= 0;
                end
            end
        end
        else begin
            for (int i = 0; i < 4; i++) begin
                for (int j = 0; j < 4; j++) begin
                    a_t[i][j] <= transpose[i][j];
                end
            end
        end
    end

endmodule