module fp2int #(
    parameter I_EXP = 8,
    parameter I_MNT = 23,
    parameter I_DATA = I_EXP + I_MNT
)(
    input logic clk,
    input logic reset,
    input logic enable,
    input [I_DATA-1:0] fp_in,
    output signed [I_DATA-1:0] int_out,
    output logic out_valid
);

localparam BIAS = (2**(I_EXP-1)-1) - R;


logic sign; 
logic [I_EXP-1:0] exponent;
logic [I_MNT-1:0] mantissa;
logic signed [I_DATA-1:0] temp_1, temp_2;
logic [I_DATA-1:0] abs_int;
logic signed [I_DATA-1:0] int_comb, int_ff;
logic out_valid_ff;

assign sign = fp_in[I_DATA-1];
assign exponent = fp_in[I_DATA-1:I_MNT];
assign mantissa = fp_in[I_MNT-1:0];

assign temp_1 = {1'b1, mantissa};
assign abs_int = temp_1 >> (I_MNT - (exponent - BIAS));
assign temp_2 = sign? (~abs_int)+1 : abs_int;
assign int_comb = {sign, temp_2};

always_ff @(posedge clk) begin
    if (reset | ~enable) begin
        int_ff <= 0;
        out_valid_ff <= 0;
    end
    else begin
        int_ff <= int_comb;
        out_valid_ff <= 1'b1;
    end
end

assign int_out = (int_ff > FIXED_POINT_MAX) ? FIXED_POINT_MAX :
                 (int_ff < FIXED_POINT_MIN) ? FIXED_POINT_MIN : int_ff;
assign out_valid = out_valid_ff;


endmodule