module fft_rad2 #(
    parameter N = 8,
    parameter DATA_WIDTH = 16
)(
    input logic clk,
    input logic reset,
    input logic [DATA_WIDTH-1:0] x0,
    input logic [DATA_WIDTH-1:0] x1,
    output logic [DATA_WIDTH-1:0] y0,
    output logic [DATA_WIDTH-1:0] y1,
    output logic fft_out_valid

);

// N = 8 Point DIF FFT

// Using a pipelined design from lecture
// Log2(N) = 3 butterfly stages
// Each stage takes N/2 cycles

// Stage 1
// Butterfly 1
// Delay Commutator - Delay and rearrage stage output

// Stage 2
// Butterfly 2
// Delay Commutator - Delay and rearrage stage output

// Stage 3
// Butterfly 3
// Delay Commutator - Delay and rearrage stage output

// DC 2
delay_commutator #(
    .DELAY(2),
    .DATA_WIDTH(DATA_WIDTH)
) stage0 (
    .clk(clk),
    .reset(reset),
    .x0(x0),
    .x1(x1),
    .y0(y0),
    .y1(y1),
    .commutator_out_valid(fft_out_valid)
);

// DC 1

endmodule