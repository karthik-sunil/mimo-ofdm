module top_all #(
    parameter DATA_WIDTH = 16,
    // FFT Size
    parameter N = 8 
)(
    input logic clk,
    input logic reset,
    input logic enable,

    input complex_t x [N-1:0],          
    output complex_product_t y [N-1:0], 
    output logic dc_chain_out_valid
);

    localparam NUM_STAGES = $clog2(N);

    // outputs of butterfly
    // for each butterfly 2 outputs and 1 valid
    complex_product_t butterfly_out0 [NUM_STAGES:0];
    complex_product_t butterfly_out1 [NUM_STAGES:0];
    logic butterfly_valid [NUM_STAGES:0];

    //outputs of DC
    complex_product_t dc_out0 [NUM_STAGES-1:0];
    complex_product_t dc_out1 [NUM_STAGES-1:0];
    logic dc_out_valid [NUM_STAGES-1:0];

    // first butterfly outside generate since the ternary part was generating [-1]
    butterfly #(
        .W_R(-1),
        .W_I(0)
    ) first_butterfly (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .A(x[0]),    // for first stage we take x[0] in DIF
        .B(x[N/2]),  //for the first stage we take x[4] in DIF
        .X(butterfly_out0[0]),
        .Y(butterfly_out1[0]),
        .out_valid(butterfly_valid[0])
    );

    // assign butterfly_valid[0] = 1; // set valid for first butterfly
    
    genvar i;
    generate
        for(i=0; i<NUM_STAGES-1; i++) begin

            butterfly #(
            .W_R(-1),
            .W_I(0)
            ) b0 (
                .clk(clk),
                .reset(reset),
                .enable((i == 0) ? enable : ),
                .A(x[i]),    // for first stage we take x[0] in DIF
                .B(x[i+N/2]),  //for the first stage we take x[4] in DIF
                .X(butterfly_out0[0]),
                .Y(butterfly_out1[0]),
                .out_valid(butterfly_valid[0])
            );
            
        
            delay_commutator #(
                .DELAY(N >> (i + 1)),   // Delay = N/4, N/8, N/16, ... 1
                .DATA_WIDTH(DATA_WIDTH)
            ) dc_inst (
                .clk(clk),
                .reset(reset),
                .enable(butterfly_valid[i-1]),  // Enable signal for each stage
                .x0(butterfly_out0[i-1]),
                .x1(butterfly_out1[i-1]),
                .y0(dc_out0[i-1]),
                .y1(dc_out1[i-1]),
                .commutator_out_valid(dc_out_valid[i-1])
            );

            butterfly #(
                .W_R(-1),
                .W_I(0)
            ) b0 (
                .clk(clk),
                .reset(reset),
                .enable(dc_out_valid[i-1]),
                .A(dc_out0[i-1]), 
                .B(dc_out1[i-1]), 
                .X(butterfly_out0[i]),
                .Y(butterfly_out1[i]),
                .out_valid(butterfly_valid[i])
            );

            // connecting the butterfly valid signals to the dc_out for each stage i
            // assign butterfly_valid[i] = dc_out_valid[i-1];

        end
    endgenerate

// Sample outputs from last commutator stages
    assign y[0] = butterfly_out0[NUM_STAGES-1];
    assign y[1] = butterfly_out1[NUM_STAGES-1];
    assign dc_chain_out_valid = butterfly_valid[NUM_STAGES-1];

endmodule