module fft_N_rad2 #(
    parameter N = 8,
    parameter NUM_STAGES = $clog2(N),
    parameter NUM_BUTTERFLIES = N / 2
)(
    input logic clk,
    input logic reset,
    input logic enable,

    // use 1 input instead
    input complex_product_t data_in,

    input logic signed [COEFF_WIDTH-1:0] W_R_STAGE [NUM_STAGES][NUM_BUTTERFLIES], // real twiddle driven dynamically from TB
    input logic signed [COEFF_WIDTH-1:0] W_I_STAGE [NUM_STAGES][NUM_BUTTERFLIES],// img twiddle driven dynamically from TB

    output complex_product_t fft_out [N-1:0],
    output logic out_valid
);

/*
================================================
||           TWIDDLE CONTROL LOGIC            ||
================================================
*/


logic [$clog2(NUM_BUTTERFLIES)-1:0] twiddle_counter;

always_ff @(posedge clk) begin
    if (reset | ~enable) begin
        twiddle_counter <= 0;
    end 
    else begin
        twiddle_counter <= twiddle_counter + 1;
    end
end

/*
================================================
||               INPUT FOLDING                ||
================================================
*/

complex_product_t data_0;
complex_product_t data_1;
logic input_folding_out_valid;

input_folding #(
    .N(N)
) input_folding_inst (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .data_in(data_in),
    .data_out_0(data_0),
    .data_out_1(data_1),
    .out_valid(input_folding_out_valid)
);


/*
================================================
||              FFT ENGINE MAIN               ||
================================================
*/

complex_product_t [NUM_STAGES-1:0] butterfly_x, butterfly_y;
logic [NUM_STAGES-1:0] butterfly_out_valid;

complex_product_t [NUM_STAGES-2:0] butterfly_x_reordered_dc, butterfly_y_reordered_dc;
logic [NUM_STAGES-2:0] dc_out_valid;

genvar i;
generate
    for (i =0; i<NUM_STAGES-1; i++) begin
        // Butterfly
        butterfly butterfly_inst(
            .clk(clk),
            .reset(reset),
            .enable((i == 0) ? input_folding_out_valid : dc_out_valid[i-1]), // if i == 0, enable, else previous out_valid
            .A((i == 0)? data_0 : butterfly_x_reordered_dc[i-1]), // if i == 0, data_0, else previous X
            .B((i == 0)? data_1 : butterfly_y_reordered_dc[i-1]), // if i == 0, data_1, else previous Y
            .W_R(W_R_STAGE[i][twiddle_counter]), // real twiddle
            .W_I(W_I_STAGE[i][twiddle_counter]), // img twiddle
            .X(butterfly_x[i]), 
            .Y(butterfly_y[i]), 
            .out_valid(butterfly_out_valid[i]) 
        );

        // Delay Commutator
        delay_commutator #(
            .DELAY(N >> (i+2))
        ) dc_2 (
            .clk(clk),
            .reset(reset),
            .enable(butterfly_out_valid[i]), 
            .x0(butterfly_x[i]), 
            .x1(butterfly_y[i]), 
            .y0(butterfly_x_reordered_dc[i]), 
            .y1(butterfly_y_reordered_dc[i]), 
            .commutator_out_valid(dc_out_valid[i]) 
        );
    end
endgenerate

// Butterfly
butterfly butterfly_final(
    .clk(clk),
    .reset(reset),
    .enable(dc_out_valid[NUM_STAGES-2]),
    .A(butterfly_x_reordered_dc[NUM_STAGES-2]),
    .B(butterfly_y_reordered_dc[NUM_STAGES-2]),
    .W_R(W_R_STAGE[NUM_STAGES-1][twiddle_counter]),
    .W_I(W_I_STAGE[NUM_STAGES-1][twiddle_counter]),
    .X(butterfly_x[NUM_STAGES-1]),
    .Y(butterfly_y[NUM_STAGES-1]),
    .out_valid(butterfly_out_valid[NUM_STAGES-1])
);

/*
================================================
||              POST-PROCESSING               ||
================================================
*/

complex_product_t deserializer_out_buffer [N-1:0];
logic deserializer_out_valid;

// Deserializer
deserializer #(
    .N(N)
) deserializer_inst (
    .clk(clk),
    .reset(reset),
    .enable(butterfly_out_valid[NUM_STAGES-1]),
    .data_0(butterfly_x[NUM_STAGES-1]),
    .data_1(butterfly_y[NUM_STAGES-1]),
    .data_deserialized(deserializer_out_buffer),
    .out_valid(deserializer_out_valid)
);

complex_product_t bit_corrected_output_buffer [N-1:0];
logic bit_reverse_out_valid;

// Bit Reversal
input_reorder #(
    .N(N)
) input_reorder (
    .clk(clk),
    .reset(reset),
    .enable(deserializer_out_valid),
    .input_array(deserializer_out_buffer),
    .output_array(bit_corrected_output_buffer),
    .out_valid(bit_reverse_out_valid)
);

/*
==================================================
||              OUTPUT ASSIGNMENT               ||
==================================================
*/

assign fft_out = bit_corrected_output_buffer;
assign out_valid = bit_reverse_out_valid;

/*
================================================
||              TWIDDLE MEMORY                ||
================================================
*/

logic signed [COEFF_WIDTH-1:0] W_R_STAGE_LUT [$clog2(N)-1][NUM_STAGES][NUM_BUTTERFLIES];
logic signed [COEFF_WIDTH-1:0] W_I_STAGE_LUT [$clog2(N)-1][NUM_STAGES][NUM_BUTTERFLIES];


endmodule