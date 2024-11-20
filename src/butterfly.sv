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
    complex_product_t X_ff, Y_ff;
    complex_product_t Y_Wout; 

    logic out_valid_ff;

    

    // Complex addition A + B
    assign X_comb.i = A.i + B.i;
    assign X_comb.r = A.r + B.r;

    // Complex subtraction A - B
    assign Y_comb.r = A.r - B.r;
    assign Y_comb.i = A.i - B.i;

    // Twiddle factor mult after the stage - DIF FFT
    assign Y_Wout.r = Y_comb.r * W_R - Y_comb.i * W_I;
    assign Y_Wout.i = Y_comb.r * W_I + Y_comb.i * W_R;

    
   always_ff @(posedge clk) begin
        if(reset | ~enable) begin
            X_ff <= '0;
            Y_ff <= '0;
            out_valid_ff <= 0;
        end else begin
            X_ff.r <= X_comb.r;
            X_ff.i <= X_comb.i;
            Y_ff.r <= Y_Wout.r >>> R;
            Y_ff.i <= Y_Wout.i >>> R;
            out_valid_ff <= 1'b1;
        end
   end

   assign X.r = (X_ff.r > FIXED_POINT_MAX) ? FIXED_POINT_MAX : 
                (X_ff.r < FIXED_POINT_MIN) ? FIXED_POINT_MIN : X_ff.r;
   assign X.i = (X_ff.i > FIXED_POINT_MAX) ? FIXED_POINT_MAX : 
                (X_ff.i < FIXED_POINT_MIN) ? FIXED_POINT_MIN : X_ff.i;
   
   assign Y.r = (Y_ff.r > FIXED_POINT_MAX) ? FIXED_POINT_MAX : 
                (Y_ff.r < FIXED_POINT_MIN) ? FIXED_POINT_MIN : Y_ff.r;
   assign Y.i = (Y_ff.i > FIXED_POINT_MAX) ? FIXED_POINT_MAX : 
                (Y_ff.i < FIXED_POINT_MIN) ? FIXED_POINT_MIN : Y_ff.i;

   assign out_valid = out_valid_ff;   

endmodule