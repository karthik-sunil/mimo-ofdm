`include "verilog/headers.svh"

module butterfly_fp_tb();

logic clk;
logic reset;
logic enable;

complex_fp_t A, B;
complex_fp_t X, Y;
logic out_valid;

parameter CLOCK_PERIOD = 10;

butterfly_fp dut (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .A(A),
    .B(B),
    .X(X),
    .Y(Y),
    .out_valid(out_valid)
);

always begin
    clk = ~clk;
    #(CLOCK_PERIOD/2);
end

initial begin
    clk = 0;
    reset = 1;
    enable = 0;
    @(negedge clk);
    reset = 0;
    enable = 1;

    A.r = 32'h3f800000;
    A.i = 32'h3f800000;
    B.r = 32'hBf800000;
    B.i = 32'h3f800000;

    for(int i=0; i<20; i=i+1) begin
        @(negedge clk);
        $display("A.r=%h, A.i=%h, B.r=%h, B.i=%h, X.r=%h, X.i=%h, Y.r=%h, Y.i=%h, out_valid=%h", A.r, A.i, B.r, B.i, X.r, X.i, Y.r, Y.i, out_valid);

    end

    #100;
    $finish;

end


endmodule