module dc_top #(
    parameter DATA_WIDTH = 16,
    // FFT Size
    parameter N = 32 

)(
    input logic clk,
    input logic reset,
    input logic [DATA_WIDTH-1:0] x0,
    input logic [DATA_WIDTH-1:0] x1,
    output logic [DATA_WIDTH-1:0] y0,
    output logic [DATA_WIDTH-1:0] y1,
    output logic dc_chain_out_valid
);

    // Calculate the number of commutators from FFT Size
    localparam NUM_COMMUTATORS = $clog2(N) - 1;

    logic [DATA_WIDTH-1:0] x0_dc [NUM_COMMUTATORS-1:0];
    logic [DATA_WIDTH-1:0] x1_dc [NUM_COMMUTATORS-1:0];    
    logic dc_out_valid [NUM_COMMUTATORS-1:0];
    
    genvar i;
    generate
        for(i=0; i<NUM_COMMUTATORS; i++) begin
            delay_commutator #(
                .DELAY(N >> (i+2)),
                .DATA_WIDTH(DATA_WIDTH)
            ) dc_inst (
                .clk(clk),
                .reset(reset),
                .enable(i == 0 ? 1: dc_out_valid[i-1]),
                .x0(i == 0 ? x0 : x0_dc[i-1]),
                .x1(i == 0 ? x1 : x1_dc[i-1]),
                .y0(x0_dc[i]),
                .y1(x1_dc[i]),
                .commutator_out_valid(dc_out_valid[i])
            );
        end
    endgenerate


assign y0 = x0_dc[NUM_COMMUTATORS-1];
assign y1 = x1_dc[NUM_COMMUTATORS-1];
assign dc_chain_out_valid = dc_out_valid[NUM_COMMUTATORS-1];

endmodule