`include "verilog/headers.svh"

module input_folding_tb();

parameter N = 8;

logic clk;
logic reset;
logic enable;

complex_product_t data_in;

complex_product_t data_out_0;
complex_product_t data_out_1;

logic out_valid;

input_folding #(
    .N(N)
) dut (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .data_in(data_in),
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
    $display("%d,%d, %d, %d", data_out_0.r, data_out_1.r, out_valid, dut.switch_enable);
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
        data_in.r = i;
        @(negedge clk);
    end

    repeat(10) @(negedge clk);

    $finish;
end


endmodule