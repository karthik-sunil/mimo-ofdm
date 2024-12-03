`timescale 1ns / 1ps
`include "verilog/headers.svh"

module fft_N_rad2_tb();

parameter N = 128;
parameter CLOCK_PERIOD = 10;

parameter DEBUG_FLAG = 1;

// code changes to incorporate for LUT based twiddle factors
parameter NUM_STAGES = $clog2(N);
parameter NUM_BUTTERFLIES = N/2; //no of butterflies to be put per stage

string INPUT_FILE = "./dat/modulated.txt";
string OUTPUT_FILE = $sformatf("./out/fft_out/fft%0d_rad2.out",N);

logic clk;
logic reset;
logic enable;

complex_product_t data_in;
complex_product_t fft_out [N-1:0];
logic out_valid;

integer cycle_count;

integer input_file;
integer input_values[7:0][1:0];  // 8 pairs of values from the file - need to think of a beter way to do this
integer input_index;

fft_N_rad2 #(
    .N(N)
) dut (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .data_in(data_in),
    .fft_out(fft_out),
    .out_valid(out_valid)
);

always begin
    clk = ~clk;
    #(CLOCK_PERIOD/2);
end

always @(negedge clk) begin
   integer f_out = $fopen(OUTPUT_FILE, "w");
   if(enable) cycle_count++;
       if(out_valid) begin
           if(~$isunknown(out_valid)) begin 
               for (int j=0; j<N; j++) begin
                   $fdisplay(f_out,"%d, %d, %d",fft_out[j].r,fft_out[j].i,out_valid);
               end
           end
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

    while(!$feof(input_file)) begin
        $fscanf(input_file, "%d,%d", data_in.r, data_in.i);
        @(negedge clk);
    end

    $fclose(input_file);

    repeat(N*2) begin
        @(negedge clk);
    end

    #100; 
    $finish;

end

endmodule