`timescale 1ns/1ps
`include "verilog/headers.svh"

module input_reorder_tb;

parameter CLOCK_PERIOD = 10;


parameter N = 16;

logic clk;
logic reset;

complex_t input_array [N-1:0];
complex_t output_array[N-1:0];

input_reorder #(
    .N(N)
)
dut (
    .clk(clk),
    .reset(reset),
    .input_array(input_array),
    .output_array(output_array)
);

always begin
    clk = ~clk;
    #(CLOCK_PERIOD/2);
end

initial begin
    clk = 0;
    reset = 1;

    @(negedge clk);
    reset = 0;

    // Input set 1
    for(int i = 0; i < N; i = i + 1) begin
        input_array[i].r = $random;
        input_array[i].i = $random;
    end

    @(negedge clk);

    $display("Input array");
    for (int i = 0; i < N; i = i + 1) begin
        $display("\t%d,(%d+j(%d))",i, input_array[i].r, input_array[i].i);
    end

    $display("Output array");
    for (int i = 0; i < N; i = i + 1) begin
        $display("\t%d,(%d+j(%d))",dut.reversed_index[i],output_array[i].r,output_array[i].i);
    end

      


    $finish;
    
end
endmodule