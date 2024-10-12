module input_reorder #(
  parameter N = 8
)(
  input logic clk,
  input logic reset,
  input complex_t input_array [N-1:0],
  output complex_t output_array [N-1:0]
);
    logic [$clog2(N)-1:0] index [N-1:0];
    logic [$clog2(N)-1:0] reversed_index [N-1:0];

    complex_t input_reordered [N-1:0];

    genvar i;
    genvar j;
    generate
        for(i=0;i<N;i=i+1) begin
            assign index[i] = i;
            for(j=0; j<$clog2(N); j = j+1) begin
            assign reversed_index[i][j] = index[i][$clog2(N)-1-j];
            end
        end
    endgenerate

    always_comb begin
        for(int i = 0; i < N; i = i + 1) begin
            input_reordered[i] = input_array[reversed_index[i]];
        end

        // Now that we have reordered the input, we can use it for further FFT Computations
        // This module can be extended to include the FFT computations as well
        
    end


    always_ff @(posedge clk) begin
    if (reset) begin
        for (int i = 0; i < N; i = i + 1) begin
            output_array[i] <= '0;
        end
    end else begin
        for (int i = 0; i < N; i = i + 1) begin
            output_array <= input_reordered;
        end
    end

    end

endmodule
