module inv_sqrt_tb();

parameter CLOCK_PERIOD = 10;
parameter I_DATA = 32;

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
    // $display("idata = %h, i = %h, y_1_intermediate = %h, y_1_intermediate_valid = %b, i_delay_9 = %h, i_delay_9_valid = %b, odata = %h, out_valid = %b", 
    //             idata, 
    //             dut.i_ff,
    //           dut.y_1_intermediate,
    //           dut.y_1_intermediate_valid,
    //             dut.i_delay_9,
    //             dut.i_delay_9_valid,
    //             odata,
    //             out_valid
    //           );

    $display("idata = %h, odata = %h, out_valid = %b", idata, odata, out_valid);
end

initial begin
    clk = 0;
    reset = 1;
    enable = 0;

    @(negedge clk);

    reset = 0;
    enable = 1;
    // Need to test for more inputs
    idata = 32'h40000000;
    @(negedge clk);
    idata = 32'h3E200000;
    @(negedge clk);
    idata = 32'h40B66666;
    repeat(20) @(negedge clk);
    // @(negedge clk);
    $finish;

end


endmodule