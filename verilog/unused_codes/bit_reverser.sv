module bit_reverser #(
  parameter N = 8
)(
  input logic clk,
  input logic reset,
  input complex_product_t input_array [N-1:0],
  output complex_product_t output_array [N-1:0]
);

    complex_product_t reversed_array_comb [N-1:0];

    genvar i;
    genvar j;
    generate
        for(i=0;i<N;i=i+1) begin
            for(j=0; j<$clog2(N); j = j+1) begin
            assign reversed_array_comb[i][j] = input_array[i][$clog2(N)-1-j];
            end
        end
    endgenerate


    always_ff @(posedge clk) begin
    if (reset) begin
        for (int i = 0; i < N; i = i + 1) begin
            output_array[i] <= '0;
        end
    end else begin
        output_array <= reversed_array_comb;
    end

    end

endmodule
