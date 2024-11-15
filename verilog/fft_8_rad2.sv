module fft_8_rad2 #(
    parameter N = 8
)(
    input logic clk,
    input logic reset,
    input logic enable,

    input complex_product_t data_0,
    input complex_product_t data_1,

    // output complex_product_t data_out_0,
    // output complex_product_t data_out_1,
    output complex_product_t fft_out [N-1:0],
    output logic out_valid
);

complex_product_t butterfly_0_x, butterfly_0_y;
logic butterfly_0_out_valid;

// Butterfly
butterfly butterfly_0 (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .A(data_0),
    .B(data_1),
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