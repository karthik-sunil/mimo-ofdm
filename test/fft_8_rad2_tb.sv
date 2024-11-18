`timescale 1ns / 1ps
`include "verilog/headers.svh"

module fft_8_rad2_tb();

parameter N = 8;
parameter CLOCK_PERIOD = 10;

// code changes to incorporate for LUT based twiddle factors
parameter NUM_STAGES = $clog2(N);
parameter NUM_BUTTERFLIES = N/2; //no of butterflies to be put per stage
parameter TWIDDLE_FILE = "./dat/twiddle_factors8fixed.txt";
parameter INPUT_FILE = "./dat/inputsine.txt";

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


integer input_file;
integer input_values[7:0][1:0];  // 8 pairs of values from the file - need to think of a beter way to do this
integer input_index;

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
            $fscanf(twiddle_file, "%d,%d", 
                    W_R_STAGE[stage][butterfly], 
                    W_I_STAGE[stage][butterfly]);
            $display("W_R_STAGE[%d][%d]= %d, W_R_STAGE[%d][%d]= %d", stage, butterfly, W_R_STAGE[stage][butterfly], stage, butterfly, W_I_STAGE[stage][butterfly]);
        end
    end

    $fclose(twiddle_file);
end

always @(negedge clk) begin
    integer f_out = $fopen("out/fft_8_rad2.out");
    if(enable) cycle_count++;
    $fdisplay(f_out,"--------------------");
        for (int j=0; j<N; j++) begin
            $fdisplay(f_out,"fft_out[%d]= fft_out.r=%d; fft_out.i=%d", j, fft_out[j].r, fft_out[j].i);
        end
end

integer f_new = $fopen("out/fft_8_debug.txt");

initial begin
    reset = 1;
    enable = 0;
    clk = 0;
    cycle_count = 0;
    
    @(negedge clk);
    
    //reading the sine value file
    input_file = $fopen(INPUT_FILE, "r");
    if (input_file == 0) begin
        $display("Error opening input file.");
        $finish;
    end

    reset = 0;
    enable = 1;

    while(!feof(input_file)) begin
      // Read in 2 values every clock cycle
        $fscanf(input_file, "%d,%d\n%d,%d", data_0.r, data_0.i, data_1.r, data_1.i);
        @(negedge clk);
    end

    // for (int i = 0; i < 8; i++) begin
    //     $fscanf(input_file, "%d,%d\n%d,%d\n%d,%d\n%d,%d", input_values[i][0], input_values[i][1]);
    // end

    // @(negedge clk);
    


    // while (!$feof(input_file)) begin
    //     data_0.r = input_values[input_index][0];
    //     data_0.i = input_values[input_index][1];
    //     data_1.r =input_values[(input_index + 4) % 8][0];
    //     data_1.i =input_values[(input_index + 4) % 8][1];
        
    //     @(negedge clk);
    //     // $display("Butterfly_0 Output: X.r = %d, X.i = %d", dut.butterfly_0_x.r, dut.butterfly_0_x.i);
    //     // $display("Butterfly_0 Output: Y.r = %d, Y.i = %d", dut.butterfly_0_y.r, dut.butterfly_0_y.i);

    //     input_index = (input_index + 1) % 8;

    //     if (input_index == 0) begin
    //         // Read next 8 values
    //         for (int i = 0; i < 8; i++) begin
    //             //check to see if we do not have equal to 8 values then we break
    //             if ($fscanf(input_file, "%d,%d", input_values[i][0], input_values[i][1]) != 2) begin
    //                 break; 
    //             end
    //         end
    //     end
    // end

    $fclose(input_file);

    repeat(60) begin
        @(negedge clk);
        // $display("Butterfly_1 Output: X.r = %d, X.i = %d", dut.butterfly_1_x.r, dut.butterfly_1_x.i);
        // $display("Butterfly_1 Output: Y.r = %d, Y.i = %d", dut.butterfly_1_y.r, dut.butterfly_1_y.i);
    end


// repeat(2) begin 
//     data_0.r = 256;
//     data_0.i = 256;
//     data_1.r = 1280;
//     data_1.i = 256;
    
//     @(negedge clk);
//     $display("Butterfly_0 Output: X.r = %d, X.i = %d", dut.butterfly_0_x.r, dut.butterfly_0_x.i);
//     $display("Butterfly_0 Output: Y.r = %d, Y.i = %d", dut.butterfly_0_y.r, dut.butterfly_0_y.i);

//     data_0.r = 512;
//     data_0.i = 512;
//     data_1.r = 1536;
//     data_1.i = 256;
    
//     @(negedge clk);
//     $display("Butterfly_0 Output: X.r = %d, X.i = %d", dut.butterfly_0_x.r, dut.butterfly_0_x.i);
//     $display("Butterfly_0 Output: Y.r = %d, Y.i = %d", dut.butterfly_0_y.r, dut.butterfly_0_y.i);

//     data_0.r = 768;
//     data_0.i = 256;
//     data_1.r = 1792;
//     data_1.i = 256;
    
//     @(negedge clk);
//     $display("Butterfly_0 Output: X.r = %d, X.i = %d", dut.butterfly_0_x.r, dut.butterfly_0_x.i);
//     $display("Butterfly_0 Output: Y.r = %d, Y.i = %d", dut.butterfly_0_y.r, dut.butterfly_0_y.i);

//     data_0.r = 1024;
//     data_0.i = 256;
//     data_1.r = 2048;
//     data_1.i = 256;
//     @(negedge clk);
//     $display("Butterfly_0 Output: X.r = %d, X.i = %d", dut.butterfly_0_x.r, dut.butterfly_0_x.i);
//     $display("Butterfly_0 Output: Y.r = %d, Y.i = %d", dut.butterfly_0_y.r, dut.butterfly_0_y.i);
//   end
//     data_0.r = 0; 
//     data_0.i = 0;
//     data_1.r = 0;
//     data_1.i = 0;

//     for(int i=0; i<60; i++) begin
       
//         // Butterfly 1 Outputs
//         $display("idx 0 Stage 1 Twiddle Factors: W_R = %d, W_I = %d", dut.W_R_STAGE[1][0], dut.W_I_STAGE[1][0]);
//         $display("idx 1 Stage 1 Twiddle Factors: W_R = %d, W_I = %d", dut.W_R_STAGE[1][1], dut.W_I_STAGE[1][1]);
//         $display("idx 2 Stage 1 Twiddle Factors: W_R = %d, W_I = %d", dut.W_R_STAGE[1][2], dut.W_I_STAGE[1][2]);
//         $display("idx 3 Stage 1 Twiddle Factors: W_R = %d, W_I = %d", dut.W_R_STAGE[1][3], dut.W_I_STAGE[1][3]);
//         @(negedge clk);
//         $display("Butterfly_1 Output: X.r = %d, X.i = %d", dut.butterfly_1_x.r, dut.butterfly_1_x.i);
//         $display("Butterfly_1 Output: Y.r = %d, Y.i = %d", dut.butterfly_1_y.r, dut.butterfly_1_y.i);
//     end


    #100; 
    $finish;

end

endmodule