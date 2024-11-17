module int2fp (
    input logic clk,
    input logic reset,
    input logic enable,
    input  logic signed [I_DATA-1:0]  int_in,
    output logic [I_DATA-1:0]  fp_out,
    output logic out_valid
);

    localparam BIAS = 2**(I_EXP-1) - 1 - R;


    logic sign;
    logic [I_EXP-1:0] exponent;
    logic [I_MNT-1:0] mantissa;
    logic [I_DATA-1:0] abs_int;
    logic [7:0] idx; // index of leading 1
    logic [I_DATA-1:0] temp; 

    logic [I_DATA-1:0] fp_out_comb, fp_out_ff;
    logic out_valid_ff;

    // Get sign of int_in 
    assign sign = int_in[I_DATA-1];

    // Get absolute value of int_in
    assign abs_int = sign ? (~int_in)+1 : int_in;

    lead_one l_count(
                .idata(abs_int),
                .odata(idx) 
            );

    assign exponent = (abs_int == 0) ? 0 : idx + BIAS;
    assign mantissa = (abs_int == 0) ? 0 : abs_int << (I_MNT-idx);
    assign fp_out_comb = {sign, exponent, mantissa};

    always_ff @(posedge clk) begin
        if (reset | ~enable) begin
            fp_out_ff <= 0;
            out_valid_ff <= 0;
        end
        else if (enable) begin
            fp_out_ff <= fp_out_comb;
            out_valid_ff <= 1;
        end
    end

    assign fp_out = fp_out_ff;
    assign out_valid = out_valid_ff;

endmodule

// =============================================================================

// Leading One Detector

module lead_one #(
    parameter   I_DATA = 32,
    parameter   ODATA_BIT = 8
)(
    // Data Signals
    input       [I_DATA-1:0] idata,
    output      [ODATA_BIT-1:0] odata
);

    logic    [ODATA_BIT-1:0] postion [0:I_DATA];
    assign  postion[0] = 'd0;   // Default Value if Bit-0 is zero

    genvar i;
    generate
        for (i = 0; i < I_DATA; i = i + 1) begin: gen_lead_one
            assign  postion[i+1] = idata[i] ? i : postion[i];
        end
    endgenerate

    // Output: Check All Bits are Zero (|idata == 0)
    assign  odata = |idata == 1'b0 ? 'd0 : postion[I_DATA]; 

endmodule
