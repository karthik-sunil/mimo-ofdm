`timescale 1ns / 1ps
`include "verilog/headers.svh"

module fp2int_tb();

logic clk;
logic reset;
logic enable;

logic [I_DATA-1:0] fp_in;
logic signed [I_DATA-1:0] int_out;
real int_out_real;

logic out_valid;

assign int_out_real = int_out;

integer f_out;

task file_test; 
        integer f1,r1; 
        logic [255:0] line_f1; 

        // Open the file 
        f1 = $fopen("dat/in_data.csv","r");

        if (f1 == 0) begin
            $display("File is missing! Exiting...");
            $finish; 
        end
        while(!$feof(f1)) begin
            r1 = $fgets(line_f1,f1);
            if (r1 >0) begin
                $sscanf(line_f1,"%h", fp_in);
                @(negedge clk);
                end
            end
                
        $fclose(f1);
endtask


fp2int #(
    .I_EXP(I_EXP),
    .I_MNT(I_MNT),
    .I_DATA(I_DATA),
    .R(R)
) dut (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .fp_in(fp_in),
    .int_out(int_out),
    .out_valid(out_valid)
);

always begin
    clk = ~clk;
    #(CLOCK_PERIOD/2);
end

always @(negedge clk) begin
    if(enable) $fdisplay(f_out,"%h, %d, %d, %b", fp_in, int_out, dut.int_ff, out_valid);
end

initial begin
    clk = 0;
    reset = 1;
    enable = 0;
    fp_in = 0;
    f_out = $fopen("out/fp2int_out.csv","w");
    @(negedge clk);
    reset = 0;
    enable = 1;
    // Call file_test task
    file_test;
    @(negedge clk);
    enable = 0;
    #100;
    $fclose(f_out);
    $finish;
end




endmodule