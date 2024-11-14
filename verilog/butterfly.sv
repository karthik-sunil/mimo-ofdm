module butterfly #(
    parameter W_R = -1,
    parameter W_I =  0
)(
    input logic clk,
    input logic reset,
    input logic enable,

    input complex_product_t A,
    input complex_product_t B,

    output complex_product_t X,
    output complex_product_t Y,
    output logic out_valid
);

    complex_product_t X_comb, Y_comb;
    complex_product_t B_W; 

    always_comb begin
        // Complex multiplication B * W
        B_W.r = B.r * W_R - B.i * W_I;
        B_W.i = B.r * W_I + B.i * W_R;

        // Complex addition A + B * W
        X_comb.r = A.r + B_W.r;
        X_comb.i = A.i + B_W.i;

        // Complex subtraction A - B * W
        Y_comb.r = A.r - B_W.r;
        Y_comb.i = A.i - B_W.i;
    end

   always_ff @(posedge clk) begin
        if(reset | ~enable) begin
            X <= '0;
            Y <= '0;
            out_valid <= 0;
        end else begin
            X <= X_comb;
            Y <= Y_comb;
            out_valid <= 1'b1;
        end
   end

endmodule