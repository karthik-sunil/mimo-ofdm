`timescale 1ns / 1ps
`include "verilog/headers.svh"

module fft_8_rad2_tb();

parameter N = 8;
parameter CLOCK_PERIOD = 10;

// code changes to incorporate for LUT based twiddle factors
parameter NUM_STAGES = $clog2(N);
parameter NUM_BUTTERFLIES = N/2; //no of butterflies to be put per stage
parameter TWIDDLE_FILE = "./dat/twiddle_factors_temp.txt";

logic clk;
logic reset;
logic enable;

complex_product_t data_0;
complex_product_t data_1;

// complex_product_t data_out_0;
complex_product_t fft_out [N-1:0];
logic out_valid;

// Dynamic twiddle factor inputs for each stage separately
logic signed [15:0] W_R_STAGE [NUM_STAGES][NUM_BUTTERFLIES];
logic signed [15:0] W_I_STAGE [NUM_STAGES][NUM_BUTTERFLIES];

integer cycle_count;
integer twiddle_file;
// to hold the twiddle factors in a 2D array such that for each stage we use 
complex_fixed_t twiddle_factors [NUM_STAGES][NUM_BUTTERFLIES]; // i do not think we need this or use this anymore

fft_8_rad2 #(
    .N(N)
) dut (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .data_0(data_0),
    .data_1(data_1),
    .W_R_STAGE(W_R_STAGE), //stage wise passing
    .W_I_STAGE(W_I_STAGE),
    .fft_out(fft_out),
    .out_valid(out_valid)
);

always begin
    clk = ~clk;
    #(CLOCK_PERIOD/2);
end

// to read the twiddle factors from the LUT file
initial begin
    twiddle_file = $fopen(TWIDDLE_FILE, "r");
    if (twiddle_file == 0) begin
        $display("error opening twiddle factors file.");
        $finish;
    end

    // loadingthe full twiddle factor set fr each stage and buttefly
    for (int stage = 0; stage < NUM_STAGES; stage++) begin
        for (int butterfly = 0; butterfly < NUM_BUTTERFLIES; butterfly++) begin
            $fscanf(twiddle_file, "%d,%d\n", 
                    W_R_STAGE[stage][butterfly], 
                    W_I_STAGE[stage][butterfly]);
            $display("W_R_STAGE[%d][%d]= %d, W_R_STAGE[%d][%d]= %d", stage, butterfly, W_R_STAGE[stage][butterfly], stage, butterfly, W_I_STAGE[stage][butterfly]);
        end
    end

    $fclose(twiddle_file);
end

always @(negedge clk) begin
    integer f_out = $fopen("out/fft_8_rad2_tb_output.txt");
    if(enable) cycle_count++;
    $fdisplay(f_out,"--------------------");
        for (int j=0; j<N; j++) begin
            // $fdisplay(f_out,"before deserializer: buttefly_x = %d; butterfly_y = %d", dut.butterfly_2_x, dut.butterfly_2_y);
            // $fdisplay(f_out, "deserializer output[%d, %d, %d, %d, %d, %d, %d, %d]", dut.deserializer_out_buffer[7].r, dut.deserializer_out_buffer[6].r, dut.deserializer_out_buffer[5].r, dut.deserializer_out_buffer[4].r, dut.deserializer_out_buffer[3].r, dut.deserializer_out_buffer[2].r, dut.deserializer_out_buffer[1].r, dut.deserializer_out_buffer[0].r);
            // the above output of deserializer is correct
            // $fdisplay(f_out,"before input reorder: fft_out[%d]= fft_out.r=%d; fft_out.i=%d", j, fft_out[j].r, fft_out[j].i);
            $fdisplay(f_out,"fft_out[%d]= fft_out.r=%d; fft_out.i=%d", j, fft_out[j].r, fft_out[j].i);
        end

        if (out_valid) begin
            $fdisplay(f_out,"out_valid = %d, cycle_count = %d", out_valid, cycle_count);
            $finish();
        end
end

integer f_new = $fopen("out/fft_8_debug.txt");

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
    $display("Butterfly_0 Output: X.r = %d, X.i = %d", dut.butterfly_0_x.r, dut.butterfly_0_x.i);
    $display("Butterfly_0 Output: Y.r = %d, Y.i = %d", dut.butterfly_0_y.r, dut.butterfly_0_y.i);

    data_0.r = 1; 
    data_0.i = 0;
    data_1.r = 5;
    data_1.i = 0;
    
    @(negedge clk);
    $display("Butterfly_0 Output: X.r = %d, X.i = %d", dut.butterfly_0_x.r, dut.butterfly_0_x.i);
    $display("Butterfly_0 Output: Y.r = %d, Y.i = %d", dut.butterfly_0_y.r, dut.butterfly_0_y.i);

    data_0.r = 2; 
    data_0.i = 0;
    data_1.r = 6;
    data_1.i = 0;
    
    @(negedge clk);
    $display("Butterfly_0 Output: X.r = %d, X.i = %d", dut.butterfly_0_x.r, dut.butterfly_0_x.i);
    $display("Butterfly_0 Output: Y.r = %d, Y.i = %d", dut.butterfly_0_y.r, dut.butterfly_0_y.i);

    data_0.r = 3; 
    data_0.i = 0;
    data_1.r = 7;
    data_1.i = 0;
    @(negedge clk);
    $display("Butterfly_0 Output: X.r = %d, X.i = %d", dut.butterfly_0_x.r, dut.butterfly_0_x.i);
    $display("Butterfly_0 Output: Y.r = %d, Y.i = %d", dut.butterfly_0_y.r, dut.butterfly_0_y.i);

    data_0.r = 0; 
    data_0.i = 0;
    data_1.r = 0;
    data_1.i = 0;

    for(int i=0; i<30; i++) begin
       
        // Butterfly 1 Outputs
        $display("idx 0 Stage 1 Twiddle Factors: W_R = %d, W_I = %d", dut.W_R_STAGE[1][0], dut.W_I_STAGE[1][0]);
        $display("idx 1 Stage 1 Twiddle Factors: W_R = %d, W_I = %d", dut.W_R_STAGE[1][1], dut.W_I_STAGE[1][1]);
        $display("idx 2 Stage 1 Twiddle Factors: W_R = %d, W_I = %d", dut.W_R_STAGE[1][2], dut.W_I_STAGE[1][2]);
        $display("idx 3 Stage 1 Twiddle Factors: W_R = %d, W_I = %d", dut.W_R_STAGE[1][3], dut.W_I_STAGE[1][3]);
        @(negedge clk);
        $display("Butterfly_1 Output: X.r = %d, X.i = %d", dut.butterfly_1_x.r, dut.butterfly_1_x.i);
        $display("Butterfly_1 Output: Y.r = %d, Y.i = %d", dut.butterfly_1_y.r, dut.butterfly_1_y.i);
    end


    #100; 
    $finish;

end

endmodule