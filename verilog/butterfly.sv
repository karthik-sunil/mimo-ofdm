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
    complex_product_t X_ff_1, Y_ff_1;

    logic out_valid_stage_1, out_valid_stage_2, out_valid_stage_3;

    // Complex addition A + B
    assign X_comb.i = A.i + B.i;
    assign X_comb.r = A.r + B.r;

    // Complex subtraction A - B
    assign Y_comb.r = A.r - B.r;
    assign Y_comb.i = A.i - B.i;

    // Stage 1 - Sum-Difference
    always_ff @(posedge clk) begin
        if (reset | ~enable) begin
            X_ff_1 <= '0;
            Y_ff_1 <= '0;
            out_valid_stage_1 <= 0;
        end else begin
            X_ff_1 <= X_comb;
            Y_ff_1 <= Y_comb;
            out_valid_stage_1 <= enable;
        end
    end

    // Stage 2 - Multiply Y with twiddle factor
    complex_product_t X_ff_2;
    
    logic signed [COMPLEX_PRODUCT_WIDTH-1:0] Y_Wout_rr, Y_Wout_rr_ff;
    logic signed [COMPLEX_PRODUCT_WIDTH-1:0] Y_Wout_ii, Y_Wout_ii_ff;
    logic signed [COMPLEX_PRODUCT_WIDTH-1:0] Y_Wout_ri, Y_Wout_ri_ff;
    logic signed [COMPLEX_PRODUCT_WIDTH-1:0] Y_Wout_ir, Y_Wout_ir_ff;

    assign Y_Wout_rr = Y_ff_1.r * W_R;
    assign Y_Wout_ii = Y_ff_1.i * W_I;
    assign Y_Wout_ri = Y_ff_1.r * W_I;
    assign Y_Wout_ir = Y_ff_1.i * W_R;

    always_ff @(posedge clk) begin
        if(reset | ~out_valid_stage_1) begin
            X_ff_2 <= '0;
            Y_Wout_rr_ff <= 0;
            Y_Wout_ii_ff <= 0;
            Y_Wout_ri_ff <= 0;
            Y_Wout_ir_ff <= 0;
            out_valid_stage_2 <= 0;
        end else begin
            X_ff_2.r <= X_ff_1.r;
            X_ff_2.i <= X_ff_1.i;
            Y_Wout_rr_ff <= Y_Wout_rr;
            Y_Wout_ii_ff <= Y_Wout_ii;
            Y_Wout_ri_ff <= Y_Wout_ri;
            Y_Wout_ir_ff <= Y_Wout_ir;
            out_valid_stage_2 <= out_valid_stage_1;
        end
    end

    // Stage 3 - Assemble Y_Wout
    
    complex_product_t Y_Wout;
    complex_product_t X_ff_3, Y_ff_3;

    assign Y_Wout.r = Y_Wout_rr_ff - Y_Wout_ii_ff;  
    assign Y_Wout.i = Y_Wout_ri_ff + Y_Wout_ir_ff;

    always_ff @(posedge clk) begin
        if(reset | ~out_valid_stage_2) begin
            X_ff_3 <= '0;
            Y_ff_3 <= '0;
            out_valid_stage_3 <= 0;
        end else begin
            X_ff_3 <= X_ff_2;
            Y_ff_3.r <= Y_Wout.r >>> R;
            Y_ff_3.i <= Y_Wout.i >>> R;
            out_valid_stage_3 <= out_valid_stage_2;
        end
    end


   assign X.r = (X_ff_3.r > FIXED_POINT_MAX) ? FIXED_POINT_MAX : 
                (X_ff_3.r < FIXED_POINT_MIN) ? FIXED_POINT_MIN : X_ff_3.r;
   assign X.i = (X_ff_3.i > FIXED_POINT_MAX) ? FIXED_POINT_MAX : 
                (X_ff_3.i < FIXED_POINT_MIN) ? FIXED_POINT_MIN : X_ff_3.i;
   
   assign Y.r = (Y_ff_3.r > FIXED_POINT_MAX) ? FIXED_POINT_MAX : 
                (Y_ff_3.r < FIXED_POINT_MIN) ? FIXED_POINT_MIN : Y_ff_3.r;
   assign Y.i = (Y_ff_3.i > FIXED_POINT_MAX) ? FIXED_POINT_MAX : 
                (Y_ff_3.i < FIXED_POINT_MIN) ? FIXED_POINT_MIN : Y_ff_3.i;

   assign out_valid = out_valid_stage_3;   

endmodule