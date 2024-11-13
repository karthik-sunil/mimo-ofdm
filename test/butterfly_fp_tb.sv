module butterfly_fp_tb();

logic clk;
logic reset;

complex_fp_t A, B;
complex_fp_t X, Y;
logic out_valid;

parameter CLOCK_PERIOD = 10;

butterfly_fp dut (
    .clk(clk),
    .reset(reset),
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

intial begin
    clk = 0;
    reset = 1;
    enable = 0;
    @(negedge clk);
    reset = 0;
    enable = 1;

    A.r = 0;
    A.i = 0;
    B.r = 0;
    B.i = 0;

    for(int i=0; i<20; i=i+1) begin
        @(negedge clk);
        $$display("A.r=%h, A.i=%h, B.r=%h, B.i=%h, X.r=%h, X.i=%h, Y.r=%h, Y.i=%h, out_valid=%h", A.r, A.i, B.r, B.i, X.r, X.i, Y.r, Y.i, out_valid);

    end

end


endmodule