`timescale 1ns / 1ps
`include "verilog/headers.svh"

module fft_8_rad2_tb();

parameter N = 8;
parameter CLOCK_PERIOD = 10;

// code changes to incorporate for LUT based twiddle factors
parameter NUM_STAGES = $clog2(N);
parameter NUM_BUTTERFLIES = N/2; //no of butterflies to be put per stage
parameter TWIDDLE_FILE = "./test/data/twiddle_factors8fixed.txt";

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

    // // fed into 2d array
    // for (int stage = 0; stage < NUM_STAGES; stage++) begin
    //     for (int butterfly = 0; butterfly < NUM_BUTTERFLIES; butterfly++) begin
    //         // Read binary strings and convert to signed logic
    //         $fscanf(twiddle_file, "%b,%b\n", 
    //                 twiddle_factors[stage][butterfly].r, 
    //                 twiddle_factors[stage][butterfly].i);

    //         //debug
    //         $display("Read Twiddle Factor (Binary): Stage %0d, Butterfly %0d, W_R=%b, W_I=%b", 
    //         stage, butterfly, 
    //         twiddle_factors[stage][butterfly].r, 
    //         twiddle_factors[stage][butterfly].i);
    //     end
    // end

    $fclose(twiddle_file);
end

always @(negedge clk) begin
    integer f_out = $fopen("out/fft_8_rad2_tb_output.txt");
    if(enable) cycle_count++;
    $fdisplay(f_out,"--------------------");
        for (int j=0; j<N; j++) begin
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

    // for (int i = 0; i < 16; i++) begin
    //         data_0.r = 1; 
    //         data_0.i = 0;        
    //         data_1.r = 0; 
    //         data_1.i = 0; 

    //     @(negedge clk);
    // end


    // for (int stage = 0; stage < NUM_STAGES; stage++) begin
    //     for (int butterfly = 0; butterfly < NUM_BUTTERFLIES; butterfly++) begin
    //         // we can test for various scenarios
    //         data_0.r = 1; 
    //         data_0.i = 0;        
    //         data_1.r = 0; 
    //         data_1.i = 0; 

    //         W_R = twiddle_factors[stage][butterfly].r; // real part
    //         W_I = twiddle_factors[stage][butterfly].i; // imaginary part

    //         $display("Cycle %0d, W_R=%b, W_I=%b, Data_0=%d, Data_1=%d", 
    //                  cycle_count, W_R, W_I, data_0.r, data_1.r);
    //         //checking our twiddle factors applied
    //         // $display("Stage %0d, Butterfly_no %0d, Twiddle_Factor (Binary): W_R=%b, W_I=%b", 
    //         // stage, butterfly, 
    //         // twiddle_factors[stage][butterfly].r, 
    //         // twiddle_factors[stage][butterfly].i);
    //         // $display("Data_0.r = %d, Data_0.i = %d, Data_1.r = %d, Data_1.i = %d", 
    //         // data_0.r, data_0.i, data_1.r, data_1.i);

    //         //to move to next set of inputs and twiddle factors
    //         @(negedge clk);
    //         //print the intermediates for the butterfly just before being fed to next stage (after DC)
    //         $display("but_0_x_re_dc_2.r = %d, but_0_x_re_dc_2.i = %d, but_0_y_re_dc_2.r = %d. but_0_y_re_dc_2.i = %d", dut.butterfly_0_x_reordered_dc_2.r, dut.butterfly_0_x_reordered_dc_2.i, dut.butterfly_0_y_reordered_dc_2.r, dut.butterfly_0_y_reordered_dc_2.i);
    //         $display("but_1_x_re_dc_1.r = %d, but_1_x_re_dc_1.i = %d, but_1_y_re_dc_1.r = %d, but_1_y_re_dc_1.i = %d", dut.butterfly_1_x_reordered_dc_1.r, dut.butterfly_1_x_reordered_dc_1.i, dut.butterfly_1_y_reordered_dc_1.r, dut.butterfly_1_y_reordered_dc_1.i);
    //         $display("------------------------------------------------------------");
    //         cycle_count++;
    //     end
    // end

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