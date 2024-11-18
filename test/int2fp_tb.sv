`timescale 1ns / 1ps
`include "verilog/headers.svh"

module int2fp_tb();

logic clk;
logic reset;
logic enable;

logic signed [I_DATA-1:0] int_in;
logic [I_DATA-1:0] fp_out;
logic out_valid;

integer f_out;

task file_test; 
        integer f1,r1; 
        logic [255:0] line_f1; 

        // Open the file 
        f1 = $fopen("dat/int2fp_in.csv","r");

        if (f1 == 0) begin
            $display("File is missing! Exiting...");
            $finish; 
        end
        while(!$feof(f1)) begin
            r1 = $fgets(line_f1,f1);
            if (r1 >0) begin
                $sscanf(line_f1,"%d", int_in);
                @(negedge clk);
                end
            end
                
        $fclose(f1);
endtask

int2fp dut (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .int_in(int_in),
    .fp_out(fp_out),
    .out_valid(out_valid)
);

always begin
    clk = ~clk;
    #(CLOCK_PERIOD/2);
end

always @(negedge clk) begin
    if(enable) $fdisplay(f_out,"%d, %h, %b", int_in, fp_out, out_valid);
end

initial begin
    clk = 0;
    reset = 1;
    enable = 0;
    f_out = $fopen("out/int2fp_out.csv","w");
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