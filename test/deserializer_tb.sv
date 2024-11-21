`timescale 1ns/1ps
`include "verilog/headers.svh"

module deserializer_tb();

parameter N = 8;
parameter CLOCK_PERIOD = 10;

logic clk;
logic reset; 
logic enable;

complex_product_t x_0;
complex_product_t x_1;

complex_product_t x_deserialized [N-1:0];
logic out_valid;

always begin
    clk = ~clk;
    #(CLOCK_PERIOD/2);
end

deserializer #(
    .N(N)
) dut (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .data_0(x_0),
    .data_1(x_1),
    .data_deserialized(x_deserialized),
    .out_valid(out_valid)
);

always @(negedge clk) begin
    if(enable) begin
    //  $display("[%d, %d, %d, %d, %d, %d, %d, %d,%d, %d, %d, %d, %d, %d, %d, %d] -> (%d)", x_deserialized[15].r, x_deserialized[14].r, x_deserialized[13].r, x_deserialized[12].r, x_deserialized[11].r, x_deserialized[10].r, x_deserialized[9].r, x_deserialized[8].r, x_deserialized[7].r, x_deserialized[6].r, x_deserialized[5].r, x_deserialized[4].r, x_deserialized[3].r, x_deserialized[2].r, x_deserialized[1].r, x_deserialized[0].r, out_valid);
     $display("[%d, %d, %d, %d, %d, %d, %d, %d] -> (%d)", x_deserialized[7].r, x_deserialized[6].r, x_deserialized[5].r, x_deserialized[4].r, x_deserialized[3].r, x_deserialized[2].r, x_deserialized[1].r, x_deserialized[0].r, out_valid);
     if(out_valid) $finish();
    end
end

initial begin
    clk  = 0;
    reset = 1;
    enable = 0;

    @(negedge clk);
    reset = 0;
    enable = 1;
    // @(negedge clk);

    for (int i=0; i<N/2; i++) begin
        x_0.r = i;
        x_0.i = 0;
        x_1.r = i+4;
        x_1.i = 0;
        @(negedge clk);
    end

    repeat(10) @(negedge clk);
    
 $finish();
end



endmodule