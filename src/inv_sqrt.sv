/* 
    Quake III Fast Inverse Square Root

    const float k3_2 = 1.5f;   // constant 3/2
    float x_2 = 0.5f * x;      // x/2 (reused a couple times)
    float y = x;
    int i_ff = * ( int * ) &y;    // evil floating point bit hack
    i_ff = 0x5f3759df - ( i_ff>>1 ); // Initial approximation (WTF ?!?)
    y = * ( float * ) &i_ff;
    y = y * ( k3_2 - ( x_2 * y * y );  // Newton iteration

*/

module inv_sqrt # (
    parameter I_EXP = 8,
    parameter I_MNT = 23,
    parameter I_DATA = I_EXP + I_MNT + 1
)(
    input logic clk,
    input logic reset,
    input logic enable,
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

logic [I_DATA-1:0] idata_half, idata_half_ff;
logic [I_DATA-1:0] idata_half_delay_3;
logic              idata_half_delay_3_valid;

logic [I_DATA-1:0] idata_shifted;
logic [I_DATA-1:0] i, i_ff;
logic enable_ff;

assign idata_half = {idata[I_DATA-1], 
                     idata[I_MNT+:I_EXP]-1, 
                     idata[I_MNT-1:0]};

assign idata_shifted = idata >> 1;

assign i = MAGIC_CONSTANT_32 - idata_shifted;


// Pipeline Register here
always_ff @(posedge clk) begin
    if (reset | ~enable) begin
        idata_half_ff <= 0;
        i_ff <= 0;
        enable_ff <= 0;
    end
    else begin
        idata_half_ff <= idata_half;
        i_ff <= i;
        enable_ff <= enable;
    end
end

// Delay idata_half by 3 clock cycles
delay_fp #(
    .DELAY(3),
    .DATA_WIDTH(I_DATA)
) delay_idata_half (
    .clk(clk),
    .reset(reset),
    .enable(enable_ff),
    .in(idata_half_ff),
    .out(idata_half_delay_3),
    .out_valid(idata_half_delay_3_valid),
    .switch_enable()
);

logic [I_DATA-1:0] i_sq;
logic i_sq_valid;

// FP Mul - square i_ff 
fp_mul #(
    .I_EXP(I_EXP),
    .I_MNT(I_MNT),
    .I_DATA(I_DATA)
) fp_mul_0 (
    .clk(clk),
    .reset(reset),
    .enable(enable_ff), // replace with out_valid from previous stage
    .idataA(i_ff),
    .idataB(i_ff),
    .odata(i_sq),
    .out_valid(i_sq_valid)
);

logic [I_DATA-1:0] y_0_intermediate;
logic y_0_intermediate_valid;

// FP Mul - multiply i_sq by idata_half_delay_3
fp_mul #(
    .I_EXP(I_EXP),
    .I_MNT(I_MNT),
    .I_DATA(I_DATA)
) fp_mul_1 (
    .clk(clk),
    .reset(reset),
    .enable(i_sq_valid & idata_half_delay_3_valid),
    .idataA(i_sq),
    .idataB(idata_half_delay_3),
    .odata(y_0_intermediate),
    .out_valid(y_0_intermediate_valid)
);


logic [I_DATA-1:0] y_1_intermediate;
logic y_1_intermediate_valid;

// FP Sub - subtract y_0_intermediate from THREE_HALVES_32
fp_add #(
    .I_EXP(I_EXP),
    .I_MNT(I_MNT),
    .I_DATA(I_DATA),
    .ADD_SUB(1)
) fp_add_0 (
    .clk(clk),
    .reset(reset),
    .enable(y_0_intermediate_valid),
    .idataA(THREE_HALVES_32),
    .idataB(y_0_intermediate),
    .odata(y_1_intermediate),
    .out_valid(y_1_intermediate_valid)
);

logic [I_DATA-1:0] i_delay_9;
logic i_delay_9_valid;

// Delay i_ff by 9 cycles
delay_fp #(
    .DELAY(9),
    .DATA_WIDTH(I_DATA)
) delay_i (
    .clk(clk),
    .reset(reset),
    .enable(enable_ff), // replace with out_valid from previous stage
    .in(i_ff),
    .out(i_delay_9),
    .out_valid(i_delay_9_valid)
);

// FP Mul - multiply y_1_intermediate by i_delay_9
fp_mul #(
    .I_EXP(I_EXP),
    .I_MNT(I_MNT),
    .I_DATA(I_DATA)
) fp_mul_2 (
    .clk(clk),
    .reset(reset),
    .enable(i_delay_9_valid & y_1_intermediate_valid),
    .idataA(y_1_intermediate),
    .idataB(i_delay_9),
    .odata(odata),
    .out_valid(out_valid)
);

endmodule




