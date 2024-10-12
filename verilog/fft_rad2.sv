module fft_rad2 #(
    parameter N = 8,
    parameter INDEX_BITS = $clog2(N)
)(
    input clk,
    input reset,
    input complex_t x [N-1:0],
    output complex_product_t x_f [N-1:0]
);

    complex_t x_reordered [N-1:0];
    logic [FFT_BITS-1:0] bit_reversed_index [N-1:0];

    logic [FFT_BITS:0] reverse_bits;

    // Set up index and reversed index
    logic [INDEX_BITS-1:0] index_bits [N-1:0];
    logic [INDEX_BITS-1:0] reversed_index_bits [N-1:0];

    genvar i;
    genvar j;
    generate
        for(i=0;i<N;i=i+1) begin
            assign index_bits[i] = i;
            for(j=0; j<INDEX_BITS; j = j+1) begin
            assign reversed_index_bits[i][j] = index_bits[i][INDEX_BITS-1-j];
            end
        end
    endgenerate

    always_comb begin
        for(int i = 0; i < N; i = i + 1) begin
            x_reordered[i] = x[reversed_index_bits[i]];
            $display("x_reordered[%0d] = %0d", i, x_reordered[i]);
        end
    end

    assign x_f = '0;


// int span;
// logic [COMPLEX_PRODUCT_WIDTH-1:0] temp_r, temp_i;
// always_comb begin
//     for(int stage = 0; stage<FFT_BITS; stage++) begin
//         span = 2 ** (stage+1);
//         for(int k=0; k<N; k=k+span) begin
//             for(int l=0; l<span/2; l++) begin
//                 temp_r = x_reordered.r[k+l] + x_reordered.r[k+l+span/2];
//                 temp_i = x_reordered.i[k+1] + x_reordered.i[k+1+span/2];
//                 x_f.r[k+l+span/2] = x_reordered.r[k+1] - x_reordered.r[k+1+span/2];
//                 x_f.i[k+l+span/2] = x_reordered.i[k+1] - x_reordered.i[k+1+span/2];
//                 x_f.r[k+l] = temp_r;
//                 x_f.i[k+l] = temp_i;
//              end
//          end
//     end
// end

endmodule
