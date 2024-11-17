
`include "verilog/headers.svh"

module bit_reverser_tb();


parameter CLOCK_PERIOD = 10;


parameter N = 8;

logic clk;
logic reset;
complex_product_t input_array [N-1:0];
complex_product_t output_array[N-1:0];

bit_reverser dut (
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
        input_array[i].r = i;
        input_array[i].i = 0;
    end

    @(negedge clk);

    $display("Output Array");
    for (int i = 0; i < N; i = i + 1) begin
        $display("%d,%d", input_array[i].r, output_array[i].r);
    end

    $finish;
    
end
endmodule