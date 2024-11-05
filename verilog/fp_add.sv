// Floating Point Adder - Not fully pipelined
module fp_add #(
    parameter   I_EXP = 8,
    parameter   I_MNT = 23,
    parameter   I_DATA = I_EXP + I_MNT + 1
)(
    input                       clk,
    input                       reset,

    input       [I_DATA-1:0]  idataA,
    input       [I_DATA-1:0]  idataB,
    output      [I_DATA-1:0]  odata
);

    // Extract Exponent and Mantissa Field of Input A and B
    logic                   idataA_sig, idataB_sig;
    logic     [I_EXP-1:0]   idataA_exp, idataB_exp;
    logic     [I_MNT:0]     idataA_mat, idataB_mat;

    assign idataA_sig = idataA[I_DATA-1];
    assign idataA_exp = idataA[I_MNT+:I_EXP];
    assign idataA_mat = {1'b1, idataA[I_MNT-1:0]};
    assign idataB_sig = idataB[I_DATA-1];
    assign idataB_exp = idataB[I_MNT+:I_EXP];
    assign idataB_mat = {1'b1, idataB[I_MNT-1:0]};

    // Merge InputA and InputB's Mantissas for Output
    // 1. Determine the Larger Input
    logic   idataA_larger;
    assign  idataA_larger = (idataA_exp > idataB_exp) ? 1'b1 :
                            ((idataA_exp == idataB_exp) && (idataA_mat > idataB_mat)) ? 1'b1 : 1'b0;

    // 2. Determine EXP difference
    logic    [I_EXP-1:0]   exp_diff;
    assign  exp_diff = idataA_larger ? idataA_exp - idataB_exp : idataB_exp - idataA_exp;

    // 3. Shift the Mantissa of Smaller Input
    logic    [I_MNT*2+1:0] idataA_mat_shift;
    logic    [I_MNT*2+1:0] idataB_mat_shift;

    assign  idataA_mat_shift = idataA_larger              ? {1'b0, idataA_mat, {(I_MNT){1'b0}}} :
                               (exp_diff > (I_MNT*2-1)) ? 'd0 :
                               {1'b0, idataA_mat, {(I_MNT){1'b0}}} >> exp_diff;
    assign  idataB_mat_shift = ~idataA_larger             ? {1'b0, idataB_mat, {(I_MNT){1'b0}}} :
                               (exp_diff > (I_MNT*2-1)) ? 'd0 :
                               {1'b0, idataB_mat, {(I_MNT){1'b0}}} >> exp_diff;

    // 4. Add or Substract InputA and InputB's Mantissas accoring to Sign Bit
    logic                  pre_sign;
    logic    [I_EXP-1:0]   pre_exp;
    logic    [I_MNT*2+1:0] pre_mat;

    assign  pre_sign = idataA_larger ? idataA_sig : idataB_sig;
    assign  pre_exp  = idataA_larger ? idataA_exp : idataB_exp;
    assign  pre_mat  = ((idataA_sig^idataB_sig) &&  idataA_larger) ? idataA_mat_shift - idataB_mat_shift :
                       ((idataA_sig^idataB_sig) && ~idataA_larger) ? idataB_mat_shift - idataA_mat_shift :
                       idataA_mat_shift + idataB_mat_shift;

    // Enable Pipeline
    logic                   pre_sig_reg;
    logic     [I_EXP-1:0]   pre_exp_reg;
    logic     [I_MNT*2+1:0] pre_mat_reg;
    logic     [I_DATA-1:0]  idataA_reg;
    logic     [I_DATA-1:0]  idataB_reg;
    logic                   idataA_zero_reg, idataB_zero_reg;

    always_ff @(posedge clk) begin
        if (reset) begin
            pre_sig_reg <= 1'b0;
            pre_exp_reg <= 'd0;
            pre_mat_reg <= 'd0;
            idataA_reg  <= 'd0;
            idataB_reg  <= 'd0;
            idataA_zero_reg <= 1'b0;
            idataB_zero_reg <= 1'b0;
        end
        else begin
            pre_sig_reg <= pre_sign;
            pre_exp_reg <= pre_exp;
            pre_mat_reg <= pre_mat;
            idataA_reg  <= idataA;
            idataB_reg  <= idataB;
            idataA_zero_reg <= idataA_exp == 'd0;
            idataB_zero_reg <= idataB_exp == 'd0;
        end
    end

    // Normalize Pre-Result for Output
    // 1. Left Shift Mantissa to Meet Bit-1 in MSB
    logic    [I_EXP-1:0]   pre_exp_shift;
    logic    [I_MNT*2+1:0] pre_mat_shift;
    logic    [I_MNT-1:0]   shift_cnt_temp, shift_cnt;

    lead_one #(.IDATA_BIT(I_MNT*2+2), .ODATA_BIT(I_MNT)) lo_inst (
        .idata              (pre_mat_reg),
        .odata              (shift_cnt_temp)
    );  

    assign shift_cnt = (2*I_MNT + 2) - shift_cnt_temp;
    
    assign  pre_exp_shift = pre_exp_reg - shift_cnt + 2;
    assign  pre_mat_shift = pre_mat_reg << ((I_MNT*2+2) - shift_cnt_temp);

    // 3. Output
    assign  odata = (idataA_zero_reg && idataB_zero_reg) ? 'd0 :
                     idataA_zero_reg                     ? idataB_reg :
                     idataB_zero_reg                     ? idataA_reg :
                    {pre_sig_reg, pre_exp_shift, pre_mat_shift[(I_MNT*2+1)-:I_MNT]};

endmodule

// =============================================================================

// Leading One Detector

module lead_one #(
    parameter   IDATA_BIT = 32,
    parameter   ODATA_BIT = 8
)(
    // Data Signals
    input       [IDATA_BIT-1:0] idata,
    output      [ODATA_BIT-1:0] odata
);

    logic    [ODATA_BIT-1:0] postion [0:IDATA_BIT];
    assign  postion[0] = 'd0;   // Default Value if Bit-0 is zero

    genvar i;
    generate
        for (i = 0; i < IDATA_BIT; i = i + 1) begin: gen_lead_one
            assign  postion[i+1] = idata[i] ? i : postion[i];
        end
    endgenerate

    // Output: Check All Bits are Zero (|idata == 0)
    assign  odata = |idata == 1'b0 ? 'd0 : postion[IDATA_BIT]; 

endmodule