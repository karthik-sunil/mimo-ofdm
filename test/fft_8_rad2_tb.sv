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

initial begin
    reset = 1;
    enable = 0;
    clk = 0;

    @(negedge clk);
    reset = 0;
    enable = 1;

    // @(negedge clk);
    data_0.r = 1; 
    data_0.i = 0;
    data_1.r = 0;
    data_1.i = 0;
    
    @(negedge clk);
    data_0.r = 1; 
    data_0.i = 0;
    data_1.r = 0;
    data_1.i = 0;
    
    @(negedge clk);
    data_0.r = 1; 
    data_0.i = 0;
    data_1.r = 0;
    data_1.i = 0;
    
    @(negedge clk);
    data_0.r = 1; 
    data_0.i = 0;
    data_1.r = 0;
    data_1.i = 0;
    @(negedge clk);
    data_0.r = 0; 
    data_0.i = 0;
    data_1.r = 0;
    data_1.i = 0;
    @(negedge clk);

    for(int i=0; i<16; i++) begin
        // 
        // $display("data_0 = %d, data_1 = %d, butterfly_0_x = %d, butterfly_0_y = %d, butterfly_0_out_valid = %d", data_0.r, data_1.r, dut.butterfly_0_x.r, dut.butterfly_0_y.r, dut.butterfly_0_out_valid);
        // $display("butterfly_0_x = %d, butterfly_0_y = %d, butterfly_0_x_reordered_dc_2 = %d, butterfly_0_y_reordered_dc_2 = %d, dc_2_out_valid = %d", dut.butterfly_0_x.r, dut.butterfly_0_y.r, dut.butterfly_0_x_reordered_dc_2.r, dut.butterfly_0_y_reordered_dc_2.r, dut.dc_2_out_valid);
        // $display("butterfly_0_x_reordered_dc_2 = %d, butterfly_0_y_reordered_dc_2 = %d, butterfly_1_x = %d, butterfly_1_y = %d, butterfly_1_out_valid = %d", dut.butterfly_0_x_reordered_dc_2.r, dut.butterfly_0_y_reordered_dc_2.r, dut.butterfly_1_x.r, dut.butterfly_1_y.r, dut.butterfly_1_out_valid);
        // $display("data_0 = %d, data_1 = %d, butterfly_1_x = %d, butterfly_1_x = %d, butterfly_1_out_valid = %d, %d, %d, %d", data_0.r, data_1.r, dut.butterfly_1.X_comb.r, dut.butterfly_1.Y_comb.r, dut.butterfly_1_out_valid, dut.butterfly_1.B.r, dut.butterfly_1.B_W.r, dut.butterfly_1.B_W.i);
        // $display("data_0 = %d, data_1 = %d, data_out_0 = %d, data_out_1 = %d, out_valid = %d", data_0.r, data_1.r, data_out_0.r, data_out_1.r, out_valid);
        @(negedge clk);
        $display("--------------------");
        for (int j=0; j<N; j++) begin
            $display("fft_out[%0d]= fft_out.r=%d; fft_out.i=%d", j, fft_out[j].r, fft_out[j].i);
        end

    end


    #100; 
    $finish;

end




endmodule