module fft_N_rad2 #(
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

genvar i;
generate
    for (i =0; i<NUM_STAGES-1; i++) begin
        // Butterfly
        butterfly butterfly_inst(
            .clk(clk),
            .reset(reset),
            .enable(enable), // if i == 0, enable, else previous out_valid
            .A(data_0), // if i == 0, data_0, else previous X
            .B(data_1), // if i == 0, data_1, else previous Y
            .W_R(W_R_STAGE[i][twiddle_counter]), // real twiddle
            .W_I(W_I_STAGE[i][twiddle_counter]), // img twiddle
            .X(butterfly_0_x), // if i == 0, butterfly_0_x, else previous X_reordered
            .Y(butterfly_0_y), // if i == 0, butterfly_0_y, else previous Y_reordered
            
        )

        // Delay Commutator
    end
endgenerate

// Butterfly

// Deserializer

// Bit Reversal


endmodule