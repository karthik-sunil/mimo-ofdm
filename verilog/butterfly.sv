module butterfly(
    input logic clk,
    input logic reset,
    input logic enable,

    input complex_product_t A,
    input complex_product_t B,

    input logic signed [15:0] W_R,
    input logic signed [15:0] W_I,

    output complex_product_t X,
    output complex_product_t Y,
    output logic out_valid
);

    complex_product_t X_comb, Y_comb;
    complex_product_t Y_Wout; 

    always_comb begin

        // Complex addition A + B
        X_comb.r = A.r + B.r;
        X_comb.i = A.i + B.i;

        // Complex subtraction A - B
        Y_comb.r = A.r - B.r;
        Y_comb.i = A.i - B.i;

        // Twiddle factor mult after the stage - DIF FFT
        Y_Wout.r = Y_comb.r * W_R - Y_comb.i * W_I;
        Y_Wout.i = Y_comb.r * W_I + Y_comb.i * W_R;

    end

   always_ff @(posedge clk) begin
        if(reset | ~enable) begin
            X <= '0;
            Y <= '0;
            out_valid <= 0;
        end else begin
            X <= X_comb;
            Y <= Y_Wout;
            out_valid <= 1'b1;
        end
   end

endmodule