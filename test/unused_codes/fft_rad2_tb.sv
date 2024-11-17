`timescale 1ns/1ps
`include "verilog/headers.svh"

module fft_rad2_tb();

parameter CLOCK_PERIOD = 20;

parameter N = 8;
parameter INDEX_BITS = $clog2(N);

logic clk;
logic reset;
complex_t x[N-1:0];
complex_product_t x_reordered[N-1:0];

dut #(
    .N(N),
    .INDEX_BITS(INDEX_BITS)
)fft_rad2(
    .clk(clk),
    .reset(reset),
    .x(x),
    .x_reordered(x_reordered)
);

initial begin
    for(int i =0; i<N; i++) begin
        x[i].r = i;
        x[i].i = 0;
        #(CLOCK_PERIOD/2);
        $display("%d,%d", x[i],x_reordered[i]);
    end

   

end




endmodule