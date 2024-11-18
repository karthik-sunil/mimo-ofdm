`include "verilog/headers.svh"

module butterfly_tb();

logic clk;
logic reset;
logic enable;

complex_product_t A;
complex_product_t B;

complex_product_t X;
complex_product_t Y;

logic out_valid;

parameter CLOCK_PERIOD = 10;

butterfly dut (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .A(A),
    .B(B),
    .W_R(-181),
    .W_I(-181),
    .X(X),
    .Y(Y),
    .out_valid(out_valid)
);

always begin
    clk = ~clk;
    #(CLOCK_PERIOD/2);
end

int A_r_values[4] = '{256, 512, 768, 1024};
int B_r_values[4] = '{1280, 1536, 1792, 2048};

initial begin
    clk = 0;
    reset = 1;
    enable = 0;
    @(negedge clk);
    reset = 0;
    enable = 1;

    // A.r = 2;
    // A.i = 3;
    // B.r = 1;
    // B.i = -1;

    // for(int i=0; i<5; i=i+1) begin
    //     @(negedge clk);
    //     $display("A.r=%h, A.i=%h, B.r=%h, B.i=%h, X.r=%h, X.i=%h, Y.r=%h, Y.i=%h, out_valid=%h", A.r, A.i, B.r, B.i, X.r, X.i, Y.r, Y.i, out_valid);
    // end

    for (int i = 0; i < 4; i++) begin
        A.r = A_r_values[i];
        A.i = 0;
        B.r = B_r_values[i];
        B.i = 0;
        @(negedge clk);
        $display("A.r=%d, A.i=%d, B.r=%d, B.i=%d, X.r=%d, X.i=%d, Y.r=%d, Y.i=%d, out_valid=%d", A.r, A.i, B.r, B.i, X.r, X.i, Y.r, Y.i, out_valid);
    end    

    #100;
    $finish;
end

endmodule