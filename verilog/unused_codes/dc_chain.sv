module dc_chain #(
    parameter DATA_WIDTH = 16
)(
    input logic clk,
    input logic reset,
    input logic [DATA_WIDTH-1:0] x0,
    input logic [DATA_WIDTH-1:0] x1,
    output logic [DATA_WIDTH-1:0] y0,
    output logic [DATA_WIDTH-1:0] y1,
    output logic dc_chain_out_valid
);

    // logic [DATA_WIDTH-1:0] x0_dc4, x1_dc4;
    // logic [DATA_WIDTH-1:0] x0_dc2, x1_dc2;
    // logic [DATA_WIDTH-1:0] x0_dc1, x1_dc1;
    // logic dc4_out_valid, dc2_out_valid, dc1_out_valid;

    // // DC 4
    // delay_commutator #(
    //     .DELAY(4),
    //     .DATA_WIDTH(DATA_WIDTH)
    // ) dc4 (
    //     .clk(clk),
    //     .reset(reset),
    //     .enable(1),
    //     .x0(x0),
    //     .x1(x1),
    //     .y0(x0_dc4),
    //     .y1(x1_dc4),
    //     .commutator_out_valid(dc4_out_valid)
    // );

    // // DC 2
    // delay_commutator #(
    //     .DELAY(2),
    //     .DATA_WIDTH(DATA_WIDTH)
    // ) dc2 (
    //     .clk(clk),
    //     .reset(reset),
    //     .enable(dc4_out_valid),
    //     .x0(x0_dc4),
    //     .x1(x1_dc4),
    //     .y0(x0_dc2),
    //     .y1(x1_dc2),
    //     .commutator_out_valid(dc2_out_valid)
    // );

    // // DC 1
    // delay_commutator #(
    //     .DELAY(1),
    //     .DATA_WIDTH(DATA_WIDTH)
    // ) dc1 (
    //     .clk(clk),
    //     .reset(reset),
    //     .enable(dc2_out_valid),
    //     .x0(x0_dc2),
    //     .x1(x1_dc2),
    //     .y0(y0),
    //     .y1(y1),
    //     .commutator_out_valid(dc1_out_valid)
    // );

    // use this logic for 8,4,2,1
    logic [DATA_WIDTH-1:0] x0_dc8, x1_dc8;
    logic [DATA_WIDTH-1:0] x0_dc4, x1_dc4;
    logic [DATA_WIDTH-1:0] x0_dc2, x1_dc2;
    logic [DATA_WIDTH-1:0] x0_dc1, x1_dc1;
    logic dc8_out_valid, dc4_out_valid, dc2_out_valid, dc1_out_valid;

    // DC 8
    delay_commutator #(
        .DELAY(8),
        .DATA_WIDTH(DATA_WIDTH)
    ) dc8 (
        .clk(clk),
        .reset(reset),
        .enable(1),
        .x0(x0),
        .x1(x1),
        .y0(x0_dc8),
        .y1(x1_dc8),
        .commutator_out_valid(dc8_out_valid)
    );

    // DC 4
    delay_commutator #(
        .DELAY(4),
        .DATA_WIDTH(DATA_WIDTH)
    ) dc4 (
        .clk(clk),
        .reset(reset),
        .enable(dc8_out_valid),
        .x0(x0_dc8),
        .x1(x1_dc8),
        .y0(x0_dc4),
        .y1(x1_dc4),
        .commutator_out_valid(dc4_out_valid)
    );

    // DC 2
    delay_commutator #(
        .DELAY(2),
        .DATA_WIDTH(DATA_WIDTH)
    ) dc2 (
        .clk(clk),
        .reset(reset),
        .enable(dc4_out_valid),
        .x0(x0_dc4),
        .x1(x1_dc4),
        .y0(x0_dc2),
        .y1(x1_dc2),
        .commutator_out_valid(dc2_out_valid)
    );

    // DC 1
    delay_commutator #(
        .DELAY(1),
        .DATA_WIDTH(DATA_WIDTH)
    ) dc1 (
        .clk(clk),
        .reset(reset),
        .enable(dc2_out_valid),
        .x0(x0_dc2),
        .x1(x1_dc2),
        .y0(y0),
        .y1(y1),
        .commutator_out_valid(dc1_out_valid)
    );

assign dc_chain_out_valid = dc1_out_valid;

endmodule