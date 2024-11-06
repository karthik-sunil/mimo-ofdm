module inv_sqrt # (
    parameter I_EXP = 8,
    parameter I_MNT = 23,
    parameter I_DATA = I_EXP + I_MNT + 1
)(
    input logic clk,
    input logic reset,
    input logic [I_DATA-1:0] idata,
    output logic [I_DATA-1:0] odata,
    output logic out_valid
);

// 16 bit
parameter MAGIC_CONSTANT_16 = 16'h59A8;
parameter THREE_HALVES_16 = 16'h3E00;

// 32 bit
parameter MAGIC_CONSTANT_32 = 32'h5F3759DF;
parameter THREE_HALVES_32 = 32'h3FC00000;

logic [I_DATA-1:0] idata_half;

logic [I_DATA-1:0] idata_ff, idata_ff_1, idata_ff_2, idata_ff_3; 

// Capture Input 
always_ff @(posedge clk) begin
    if (reset) begin
        idata_ff <= 'd0;
        idata_ff_1 <= 'd0;
        idata_ff_2 <= 'd0;
        idata_ff_3 <= 'd0;
    end
    else begin
        idata_ff <= idata;
        idata_ff_1 <= idata_ff;
        idata_ff_2 <= idata_ff_1;
        idata_ff_3 <= idata_ff_2;
    end
end

// Compute x/2 on delayed input
assign idata_half = {idata_ff_3[I_DATA-1], idata_ff_3[I_MNT+:I_EXP]-1, idata_ff_3[I_MNT-1:0]};

logic [I_DATA-1:0] i;

// Difference between magic constant and shifted delayed input 
assign i = MAGIC_CONSTANT_32 - (idata_ff_3 >> 1);

logic [I_DATA-1:0] i_squared;

logic fp_mul_0_out_valid;

fp_mul #(
    .I_EXP(I_EXP),
    .I_MNT(I_MNT),
    .I_DATA(I_DATA)
) fp_mul_0 (
    .clk(clk),
    .reset(reset),
    .idataA(i),
    .idataB(i),
    .odata(i_squared),
    .out_valid(fp_mul_0_out_valid)
);

/*

    const float k3_2 = 1.5f;   // constant 3/2
    float x_2 = 0.5f * x;      // x/2 (reused a couple times)
    float y = x;
    int i = * ( int * ) &y;    // evil floating point bit hack
    i = 0x5f3759df - ( i>>1 ); // Initial approximation (WTF ?!?)
    y = * ( float * ) &i;
    y = y * ( k3_2 - ( x_2 * y * y );  // Newton iteration

*/




endmodule