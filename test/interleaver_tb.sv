`include "verilog/headers.svh"

module interleaver_tb();

parameter N = 8;

logic clk;
logic reset;
logic enable;

complex_product_t x0;
complex_product_t x1;

complex_product_t data_out_0;
complex_product_t data_out_1;

logic out_valid;

interleaver #(
    .N(N)
) dut (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .x0(x0),
    .x1(x1),
    .data_out_0(data_out_0),
    .data_out_1(data_out_1),
    .out_valid(out_valid)
);

always begin
    clk = ~clk;
    #5;
end

always @(negedge clk) begin
    // if(out_valid) begin
    $display("%d,%d, %d", data_out_0.r, data_out_1.r, out_valid);
    // end
end

initial begin
    clk = 0;
    reset = 1;
    enable = 0;
    @(negedge clk);
    reset = 0;
    enable = 1;

    for (int i = 0; i < 128; i++) begin
        x0.r = i;
        x0.i = 0;
        x1.r = i + 100;
        x1.i = 0;
        @(negedge clk);
    end

    repeat(10) @(negedge clk);

    $finish;
end


endmodule