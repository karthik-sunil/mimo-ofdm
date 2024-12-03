module fft_N_rad2 #(
    parameter N = 8,
    parameter NUM_STAGES = $clog2(N),
    parameter NUM_BUTTERFLIES = N / 2
)(
    input logic clk,
    input logic reset,
    input logic enable,

    input complex_product_t data_in_0,
    input complex_product_t data_in_1,

    output complex_product_t fft_out [N-1:0],
    output logic output_mode,
    output logic out_valid
);

/*
================================================
||              TWIDDLE MEMORY                ||
================================================
*/

logic signed [COEFF_WIDTH-1:0] W_R_STAGE_LUT [(N/2-1):0];
logic signed [COEFF_WIDTH-1:0] W_I_STAGE_LUT [(N/2-1):0];

logic signed [COEFF_WIDTH-1:0] W_R_FINAL;
logic signed [COEFF_WIDTH-1:0] W_I_FINAL;

assign W_R_FINAL = W_R_STAGE_LUT[0];
assign W_I_FINAL = W_I_STAGE_LUT[0];

generate
    case(N)
        8 : begin                                         
                `include "verilog/mem/twiddle_8_rad2.sv"    
            end
        16 : begin
                `include "verilog/mem/twiddle_16_rad2.sv"    
            end
        32 : begin
                `include "verilog/mem/twiddle_32_rad2.sv"     
            end
        64 : begin
                `include "verilog/mem/twiddle_64_rad2.sv"     
            end
        128 : begin
                `include "verilog/mem/twiddle_128_rad2.sv"     
            end
        256 : begin
                `include "verilog/mem/twiddle_256_rad2.sv"     
            end
        512 : begin
                `include "verilog/mem/twiddle_512_rad2.sv"
            end
        1024 : begin
                `include "verilog/mem/twiddle_1024_rad2.sv"
            end
        2048 : begin
                `include "verilog/mem/twiddle_2048_rad2.sv"
            end
        4096 : begin
                `include "verilog/mem/twiddle_4096_rad2.sv"
            end
        endcase
endgenerate


/*
================================================
||           TWIDDLE CONTROL LOGIC            ||
================================================
*/

// logic [$clog2(NUM_BUTTERFLIES)-1:0] twiddle_counter;
logic [$clog2(NUM_BUTTERFLIES)-1:0] twiddle_pointers [NUM_STAGES-1:0];
logic twiddle_pointers_out_valid [NUM_STAGES-1:0];

/*
====================================================
||               INPUT INTERLEAVER                ||
====================================================
*/

complex_product_t data_0;
complex_product_t data_1;
logic input_folding_out_valid;

interleaver #(
    .N(N)
) interleaver_inst (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .x0(data_in_0),
    .x1(data_in_1),
    .data_out_0(data_0),
    .data_out_1(data_1),
    .out_valid(input_folding_out_valid)
);

logic deserializer_out_valid_delayed;

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
        twiddle_control_pointer #(
            .N(N),
            .STEP(1<<i)
        ) twiddle_control_pointer_inst (
            .clk(clk),
            .reset(reset),
            .enable((i == 0) ? input_folding_out_valid : dc_out_valid[i-1]), // if i == 0, enable, else previous out_valid
            .pointer(twiddle_pointers[i]),
            .out_valid(twiddle_pointers_out_valid[i])
        ); 

        // Butterfly
        butterfly butterfly_inst(
            .clk(clk),
            .reset(reset),
            .enable((i == 0) ? input_folding_out_valid : dc_out_valid[i-1]), // if i == 0, enable, else previous out_valid
            .A((i == 0)? data_0 : butterfly_x_reordered_dc[i-1]), // if i == 0, data_0, else previous X
            .B((i == 0)? data_1 : butterfly_y_reordered_dc[i-1]), // if i == 0, data_1, else previous Y
            .W_R(W_R_STAGE_LUT[twiddle_pointers[i]]), // real twiddle
            .W_I(W_I_STAGE_LUT[twiddle_pointers[i]]), // img twiddle
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
    .W_R(W_R_FINAL),
    .W_I(W_I_FINAL),
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
====================================================
||                 OUTPUT SELECT                  ||
====================================================
*/

logic output_select;

always_ff @(posedge clk) begin
    if (reset) begin
        output_select <= 0;
    end 
    else begin
        output_select <= (bit_reverse_out_valid)? ~output_select : output_select;
    end
end

/*
==================================================
||              OUTPUT ASSIGNMENT               ||
==================================================
*/

assign fft_out =  bit_corrected_output_buffer;
assign out_valid = bit_reverse_out_valid;
assign output_mode = output_select;

endmodule