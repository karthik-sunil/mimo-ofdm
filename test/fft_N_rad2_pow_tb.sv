`timescale 1ns / 1ps

module fft_N_rad2_tb();

parameter N = 8;
parameter CLOCK_PERIOD = 10;

parameter DEBUG_FLAG = 1;

// code changes to incorporate for LUT based twiddle factors
parameter NUM_STAGES = $clog2(N);
parameter NUM_BUTTERFLIES = N/2; //no of butterflies to be put per stage

string INPUT_FILE_1 = "./dat/inputsine.txt";
string INPUT_FILE_2 = "./dat/modulated.txt";
string OUTPUT_FILE_1 = $sformatf("./out/fft_out/out_0/inputsine_out_0_fft%0d_rad2.out",N);
string OUTPUT_FILE_2 = $sformatf("./out/fft_out/out_1/modulated_out_1_fft%0d_rad2.out",N);

logic clk;
logic reset;
logic enable;

complex_product_t data_in_0;
complex_product_t data_in_1;

complex_product_t fft_out [N-1:0];
logic [(N*64)-1:0] fft_out_net;
logic out_valid;
logic output_mode;

integer cycle_count;

integer input_file_1, input_file_2;
integer input_values[7:0][1:0];  // 8 pairs of values from the file - need to think of a beter way to do this
integer input_index;

// assign fft_out.r = fft_out_net[(N*32)-1:0];
// assign fft_out.i = fft_out_net[(N*64)-1:(N*32)];


fft_N_rad2 #(
    .N(N)
) dut (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .data_in_0(data_in_0),
    .data_in_1(data_in_1),
    .fft_out(fft_out_net),
    .output_mode(output_mode),
    .out_valid(out_valid)
);

always begin
    clk = ~clk;
    #(CLOCK_PERIOD/2);
end

always @(negedge clk) begin
   integer f_out_1 = $fopen(OUTPUT_FILE_1, "w");
   integer f_out_2 = $fopen(OUTPUT_FILE_2, "w");
   if(enable) cycle_count++;
       if(out_valid) begin
           if(~$isunknown(out_valid)) begin 
               for (int j=0; j<N; j++) begin
                    if(~output_mode) begin
                        $fdisplay(f_out_1,"%d, %d, %d",fft_out[j].r,fft_out[j].i,out_valid);
                    end
                    else begin
                        $fdisplay(f_out_2,"%d, %d, %d",fft_out[j].r,fft_out[j].i,out_valid);
                    end
               end
           end
       end
end

integer f_new = $fopen("out/fft_8_debug.txt");

initial begin
    $sdf_annotate("syn/fft_N_rad2.mapped.sdf", dut);
    $dumpfile("fft_N_rad2_tb.vcd");
    $dumpvars(0, fft_N_rad2_tb.dut);

    reset = 1;
    enable = 0;
    clk = 0;
    cycle_count = 0;
    
    @(negedge clk);
    
    //reading the sine value file
    input_file_1 = $fopen(INPUT_FILE_1, "r");
    input_file_2 = $fopen(INPUT_FILE_2, "r");

    if (input_file_1 == 0 || input_file_2 == 0) begin
        $display("Error opening one or more input file(s).");
        $finish;
    end

    reset = 0;
    enable = 1;

    while(!$feof(input_file_1) && !$feof(input_file_2)) begin
        $fscanf(input_file_1, "%d,%d", data_in_0.r, data_in_0.i);
        $fscanf(input_file_2, "%d,%d", data_in_1.r, data_in_1.i);
        @(negedge clk);
    end

    $fclose(input_file_1);
    $fclose(input_file_2);

    repeat(N*2) begin
        @(negedge clk);
    end

    #100; 
    $finish;

end

endmodule