`timescale 1ns / 1ps
`include "verilog/headers.svh"

module fft_8_rad2_tb();

parameter N = 8;
parameter CLOCK_PERIOD = 10;

logic clk;
logic reset;
logic enable;

complex_product_t data_0;
complex_product_t data_1;

// complex_product_t data_out_0;
complex_product_t fft_out [N-1:0];

logic out_valid;

integer cycle_count;

fft_8_rad2 dut (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .data_0(data_0),
    .data_1(data_1),
    .fft_out(fft_out),
    .out_valid(out_valid)
);

always begin
    clk = ~clk;
    #(CLOCK_PERIOD/2);
end

always @(negedge clk) begin
    integer f_out = $fopen("out/fft_8_rad2_tb_output.txt");
    if(enable) cycle_count++;
    $fdisplay(f_out,"--------------------");
        for (int j=0; j<N; j++) begin
            $fdisplay(f_out,"fft_out[%0d]= fft_out.r=%d; fft_out.i=%d", j, fft_out[j].r, fft_out[j].i);
        end

        if (out_valid) begin
            $fdisplay(f_out,"out_valid = %d, cycle_count = %d", out_valid, cycle_count);
            $finish();
        end
end

initial begin
    reset = 1;
    enable = 0;
    clk = 0;
    cycle_count = 0;

    @(negedge clk);
    reset = 0;
    enable = 1;

    data_0.r = 0; 
    data_0.i = 0;
    data_1.r = 4;
    data_1.i = 0;
    
    @(negedge clk);
    data_0.r = 1; 
    data_0.i = 0;
    data_1.r = 5;
    data_1.i = 0;
    
    @(negedge clk);
    data_0.r = 2; 
    data_0.i = 0;
    data_1.r = 6;
    data_1.i = 0;
    
    @(negedge clk);
    data_0.r = 3; 
    data_0.i = 0;
    data_1.r = 7;
    data_1.i = 0;
    @(negedge clk);
    data_0.r = 0; 
    data_0.i = 0;
    data_1.r = 0;
    data_1.i = 0;
    @(negedge clk);

    for(int i=0; i<16; i++) begin
        @(negedge clk);
    end


    #100; 
    $finish;

end




endmodule