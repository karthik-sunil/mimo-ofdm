module inv_sqrt_tb();

parameter CLOCK_PERIOD = 10;
parameter I_DATA = 32;

integer f_out;

logic clk;
logic reset;
logic enable;
logic [I_DATA-1:0] idata;
logic [I_DATA-1:0] odata;
logic out_valid;

logic [I_DATA-1:0] i_check;

assign i_check = 32'h5f3759df - (idata >> 1);

always begin
    clk = ~clk;
    #(CLOCK_PERIOD/2);
end

task file_test; 
        integer f1,r1; 
        logic [255:0] line_f1; 

        // Open the file 
        f1 = $fopen("dat/inv_sqrt_in.csv","r");

        if (f1 == 0) begin
            $display("File is missing! Exiting...");
            $finish; 
        end
        while(!$feof(f1)) begin
            r1 = $fgets(line_f1,f1);
            if (r1 >0) begin
                $sscanf(line_f1,"%h", idata);
                $display("idata = %h", idata);
                @(negedge clk);
                end
            
            end
                
        $fclose(f1);
endtask

inv_sqrt #(
    .I_DATA(I_DATA)
) dut (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .idata(idata),
    .odata(odata),
    .out_valid(out_valid)
);

always @(negedge clk) begin
    // $display("idata = %h, odata = %h, out_valid = %b", idata, odata, out_valid);
    $fdisplay(f_out, "%h, %h, %b", idata, odata, out_valid);

end

initial begin
    clk = 0;
    reset = 1;
    enable = 0;

    @(negedge clk);

    reset = 0;
    enable = 1;
    // Need to test for more inputs
    // idata = 32'h40000000;
    // @(negedge clk);
    // idata = 32'h3E200000;
    // @(negedge clk);
    // idata = 32'h40B66666;
    // @(negedge clk);
    // idata = 32'h40A00000;

    f_out = $fopen("out/inv_sqrt_out.csv","w");
    file_test;
    repeat(20) @(negedge clk);
    $fclose(f_out);
    // @(negedge clk);
    $finish;

end


endmodule