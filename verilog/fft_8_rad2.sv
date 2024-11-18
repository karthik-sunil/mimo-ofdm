module fft_8_rad2 #(
    parameter N = 8,
    parameter NUM_STAGES = $clog2(N),
    parameter NUM_BUTTERFLIES = N / 2
)(
    input logic clk,
    input logic reset,
    input logic enable,

    input complex_product_t data_0,
    input complex_product_t data_1,
 
    input logic signed [15:0] W_R_STAGE [NUM_STAGES][NUM_BUTTERFLIES], // real twiddle driven dynamically from TB
    input logic signed [15:0] W_I_STAGE [NUM_STAGES][NUM_BUTTERFLIES],// img twiddle driven dynamically from TB

    output complex_product_t fft_out [N-1:0],
    output logic out_valid
);

complex_product_t butterfly_0_x, butterfly_0_y;
logic butterfly_0_out_valid;
// counter for twiddle
logic [$clog2(NUM_BUTTERFLIES)-1:0] twiddle_counter;

// Butterfly for this stage
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        twiddle_counter <= 0;
    end else if (enable) begin
        if (twiddle_counter == NUM_BUTTERFLIES - 1) begin
            twiddle_counter <= 0; // reset counter when it gets to max
        end else begin
            twiddle_counter <= twiddle_counter + 1;
        end
    end
end

// Butterfly
butterfly butterfly_0 (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .A(data_0),
    .B(data_1),
    .W_R(W_R_STAGE[0][twiddle_counter]), // real twiddle
    .W_I(W_I_STAGE[0][twiddle_counter]), // img twiddle
    .X(butterfly_0_x),
    .Y(butterfly_0_y),
    .out_valid(butterfly_0_out_valid)
);

complex_product_t butterfly_0_x_reordered_dc_2, butterfly_0_y_reordered_dc_2;
logic dc_2_out_valid;
// DC 2
delay_commutator #(
    .DELAY(2)
) dc_2 (
    .clk(clk),
    .reset(reset),
    .enable(butterfly_0_out_valid),
    .x0(butterfly_0_x),
    .x1(butterfly_0_y),
    .y0(butterfly_0_x_reordered_dc_2),
    .y1(butterfly_0_y_reordered_dc_2),
    .commutator_out_valid(dc_2_out_valid)
);

complex_product_t butterfly_1_x, butterfly_1_y;
logic butterfly_1_out_valid;

// Butterfly
butterfly butterfly_1 (
    .clk(clk),
    .reset(reset),
    .enable(dc_2_out_valid),
    .A(butterfly_0_x_reordered_dc_2),
    .B(butterfly_0_y_reordered_dc_2),
    .W_R(W_R_STAGE[1][twiddle_counter]), // real tewiddle
    .W_I(W_I_STAGE[1][twiddle_counter]), // img twiddle
    .X(butterfly_1_x),
    .Y(butterfly_1_y),
    .out_valid(butterfly_1_out_valid)
);

complex_product_t butterfly_1_x_reordered_dc_1, butterfly_1_y_reordered_dc_1;
logic dc_1_out_valid;
// DC 1
delay_commutator #(
    .DELAY(1)
) dc_1 (
    .clk(clk),
    .reset(reset),
    .enable(butterfly_1_out_valid),
    .x0(butterfly_1_x),
    .x1(butterfly_1_y),
    .y0(butterfly_1_x_reordered_dc_1),
    .y1(butterfly_1_y_reordered_dc_1),
    .commutator_out_valid(dc_1_out_valid)
);

complex_product_t butterfly_2_x, butterfly_2_y;
logic butterfly_2_out_valid;

// Butterfly
butterfly butterfly_2 (
    .clk(clk),
    .reset(reset),
    .enable(dc_1_out_valid),
    .A(butterfly_1_x_reordered_dc_1),
    .B(butterfly_1_y_reordered_dc_1),
    .W_R(W_R_STAGE[2][twiddle_counter]), // real tewiddle
    .W_I(W_I_STAGE[2][twiddle_counter]), // img twiddle
    .X(butterfly_2_x),
    .Y(butterfly_2_y),
    .out_valid(butterfly_2_out_valid)
);

complex_product_t deserializer_out_buffer [N-1:0];
logic deserializer_out_valid;

// Deserializer Interface
deserializer #(
    .N(N)
) deser_0 (
    .clk(clk),
    .reset(reset),
    .enable(butterfly_2_out_valid),
    .data_0(butterfly_2_x),
    .data_1(butterfly_2_y),
    .data_deserialized(deserializer_out_buffer),
    .out_valid(deserializer_out_valid)
);

complex_product_t bit_corrected_output_buffer [N-1:0];
logic bit_reverse_out_valid;

// Bit-reversed output
input_reorder #(
    .N(8)
) input_reorder (
    .clk(clk),
    .reset(reset),
    .enable(deserializer_out_valid),
    .input_array(deserializer_out_buffer),
    .output_array(bit_corrected_output_buffer),
    .out_valid(bit_reverse_out_valid)
);

// assign data_out_0 = butterfly_2_x;
assign fft_out = bit_corrected_output_buffer;
assign out_valid = bit_reverse_out_valid;

endmodule