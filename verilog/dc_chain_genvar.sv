module dc_chain #(
    parameter DATA_WIDTH = 16,
    parameter N = 8
)(
    input logic clk,
    input logic reset,
    input logic [DATA_WIDTH-1:0] x0,
    input logic [DATA_WIDTH-1:0] x1,
    output logic [DATA_WIDTH-1:0] y0,
    output logic [DATA_WIDTH-1:0] y1,
    output logic dc_chain_out_valid
);

    //no of delay commutators based on N
    localparam NUM_COMMUTATORS = (N / 4) + (N >= 8) + (N >= 16);

    logic [DATA_WIDTH-1:0] dc_x0 [NUM_COMMUTATORS:0];
    logic [DATA_WIDTH-1:0] dc_x1 [NUM_COMMUTATORS:0];
    logic dc_valid [NUM_COMMUTATORS:0];

    // first stage inputs
    assign dc_x0[0] = x0;
    assign dc_x1[0] = x1;
    assign dc_valid[0] = 1; // enable for the first delay commutator set to 1

    genvar i;
    generate
        for (i = 0; i < NUM_COMMUTATORS; i++) begin : gen_dc_chain
            delay_commutator #(
                .DELAY((N >> (i+2))),  // delay for each comm stage (N/4, N/8, N/16 ...)
                .DATA_WIDTH(DATA_WIDTH)
            ) dc_inst (
                .clk(clk),
                .reset(reset),
                .enable(dc_valid[i]), // enable signal from the previous commutator
                .x0(dc_x0[i]),
                .x1(dc_x1[i]),
                .y0(dc_x0[i+1]), // to next comm stage
                .y1(dc_x1[i+1]),
                .commutator_out_valid(dc_valid[i+1])  //  valid to the next enable
            );
        end
    endgenerate

    // last stage outputs to pass
    assign y0 = dc_x0[NUM_COMMUTATORS];
    assign y1 = dc_x1[NUM_COMMUTATORS];
    assign dc_chain_out_valid = dc_valid[NUM_COMMUTATORS];

endmodule
