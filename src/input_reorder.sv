module input_reorder #(
  parameter N = 8
)(
  input logic clk,
  input logic reset,
  input logic enable,
  input complex_product_t input_array [N-1:0],
  output complex_product_t output_array [N-1:0],
  output logic out_valid
);
    logic [$clog2(N)-1:0] index [N-1:0];
    logic [$clog2(N)-1:0] reversed_index [N-1:0];

    complex_product_t input_reordered [N-1:0];

    genvar i;
    genvar j;
    generate
        for(i=0;i<N;i=i+1) begin : loop1
            assign index[i] = i;
            for(j=0; j<$clog2(N); j = j+1) begin : loop2
            assign reversed_index[i][j] = index[i][$clog2(N)-1-j];
            end
        end
    endgenerate

    always_comb begin
        for(int i = 0; i < N; i = i + 1) begin
            input_reordered[i] = input_array[reversed_index[i]];
        end
    end


    always_ff @(posedge clk) begin
    if (reset | ~enable) begin
        for (int i = 0; i < N; i = i + 1) begin
            output_array[i] <= '0;
            out_valid <= 0;
        end
    end else begin
        for (int i = 0; i < N; i = i + 1) begin
            output_array[N-1-i] <= input_reordered[i];
            out_valid <= 1;
        end
    end

    end

endmodule
