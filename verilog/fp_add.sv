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
    // Pass Through
    logic [I_DATA-1:0]      idataA_ff_stage_1, idataB_ff_stage_1;
    logic [I_DATA-1:0]      idataA_ff_stage_2, idataB_ff_stage_2;
    logic [I_DATA-1:0]      idataA_ff_stage_3, idataB_ff_stage_3;

    // ===================================== Stage 1 ===================================== //

    // Extract Exponent and Mantissa Field of Input A and B
    logic                   idataA_sig, idataB_sig;
    logic     [I_EXP-1:0]   idataA_exp, idataB_exp;
    logic     [I_MNT:0]     idataA_mat, idataB_mat;

    logic                   idataA_sig_ff, idataB_sig_ff;
    logic     [I_EXP-1:0]   idataA_exp_ff, idataB_exp_ff;
    logic     [I_MNT:0]     idataA_mat_ff, idataB_mat_ff;

    assign idataA_sig = idataA[I_DATA-1];
    assign idataA_exp = idataA[I_MNT+:I_EXP];
    assign idataA_mat = {1'b1, idataA[I_MNT-1:0]};
    assign idataB_sig = idataB[I_DATA-1];
    assign idataB_exp = idataB[I_MNT+:I_EXP];
    assign idataB_mat = {1'b1, idataB[I_MNT-1:0]};

    // Merge InputA and InputB's Mantissas for Output
    // 1. Determine the Larger Input
    logic   idataA_larger;
    logic   idataA_larger_ff;
    assign  idataA_larger = (idataA_exp > idataB_exp) ? 1'b1 :
                            ((idataA_exp == idataB_exp) && (idataA_mat > idataB_mat)) ? 1'b1 : 1'b0;

    // 2. Determine EXP difference
    logic    [I_EXP-1:0]   exp_diff;
    logic    [I_EXP-1:0]   exp_diff_ff;
    assign  exp_diff = idataA_larger ? idataA_exp - idataB_exp : idataB_exp - idataA_exp;

    // Insert Pipeline Register Here
    always_ff @(posedge clk) begin
        if (reset) begin
           exp_diff_ff <= 'd0; 
           idataA_larger_ff <= 1'b0;
           
           idataA_sig_ff <= 1'b0;
           idataA_exp_ff <= 'd0;
           idataA_mat_ff <= 'd0;

           idataB_sig_ff <= 1'b0;
           idataB_exp_ff <= 'd0;
           idataB_mat_ff <= 'd0; 

           idataA_ff_stage_1 <= 'd0;
           idataB_ff_stage_1 <= 'd0;
        end
        else begin
            exp_diff_ff <= exp_diff;
            idataA_larger_ff <= idataA_larger;  

            idataA_sig_ff <= idataA_sig;
            idataA_exp_ff <= idataA_exp;
            idataA_mat_ff <= idataA_mat;

            idataB_sig_ff <= idataB_sig;
            idataB_exp_ff <= idataB_exp;
            idataB_mat_ff <= idataB_mat;

            idataA_ff_stage_1 <= idataA;
            idataB_ff_stage_1 <= idataB;
        end
    end

    // ===================================== Stage 2 ===================================== // 

    // 3. Shift the Mantissa of Smaller Input
    logic    [I_MNT*2+1:0] idataA_mat_shift;
    logic    [I_MNT*2+1:0] idataB_mat_shift;

    assign  idataA_mat_shift = idataA_larger_ff              ? {1'b0, idataA_mat_ff, {(I_MNT){1'b0}}} :
                               (exp_diff_ff > (I_MNT*2-1)) ? 'd0 :
                               {1'b0, idataA_mat_ff, {(I_MNT){1'b0}}} >> exp_diff_ff;
    assign  idataB_mat_shift = ~idataA_larger_ff             ? {1'b0, idataB_mat_ff, {(I_MNT){1'b0}}} :
                               (exp_diff_ff > (I_MNT*2-1)) ? 'd0 :
                               {1'b0, idataB_mat_ff, {(I_MNT){1'b0}}} >> exp_diff_ff;

    // 4. Add or Substract InputA and InputB's Mantissas accoring to Sign Bit
    logic                  pre_sign;
    logic    [I_EXP-1:0]   pre_exp;
    logic    [I_MNT*2+1:0] pre_mat;

    logic                  pre_sig_ff_stage_2;
    logic    [I_EXP-1:0]   pre_exp_ff;
    logic    [I_MNT*2+1:0] pre_mat_ff;
    logic                  idataA_zero_ff_stage_2, idataB_zero_ff_stage_2;
    logic                  idataA_zero_ff_stage_3, idataB_zero_ff_stage_3;


    assign  pre_sign = idataA_larger ? idataA_sig : idataB_sig;
    assign  pre_exp  = idataA_larger ? idataA_exp : idataB_exp;
    assign  pre_mat  = ((idataA_sig^idataB_sig) &&  idataA_larger) ? idataA_mat_shift - idataB_mat_shift :
                       ((idataA_sig^idataB_sig) && ~idataA_larger) ? idataB_mat_shift - idataA_mat_shift :
                       idataA_mat_shift + idataB_mat_shift;

    always_ff @(posedge clk) begin
        if (reset) begin
            pre_sig_ff_stage_2 <= 1'b0;
            pre_exp_ff <= 'd0;
            pre_mat_ff <= 'd0;

            idataA_ff_stage_2  <= 'd0;
            idataB_ff_stage_2  <= 'd0;
            
            idataA_zero_ff_stage_2 <= 1'b0;
            idataB_zero_ff_stage_2 <= 1'b0;
        end
        else begin
            pre_sig_ff_stage_2 <= pre_sign;
            pre_exp_ff <= pre_exp;
            pre_mat_ff <= pre_mat;

            idataA_ff_stage_2  <= idataA_ff_stage_1;
            idataB_ff_stage_2  <= idataB_ff_stage_1;
            
            idataA_zero_ff_stage_2 <= idataA_exp_ff == 'd0;
            idataB_zero_ff_stage_2 <= idataB_exp_ff == 'd0;
        end
    end

    // ===================================== Stage 3 ===================================== // 

    // Normalize Pre-Result for Output
    // 1. Left Shift Mantissa to Meet Bit-1 in MSB
    logic    [I_EXP-1:0]   pre_exp_shift;
    logic    [I_MNT*2+1:0] pre_mat_shift;
    logic    [I_MNT-1:0]   shift_cnt_temp, shift_cnt;

    logic                  pre_sig_ff_stage_3;
    logic    [I_EXP-1:0]   pre_exp_shift_ff;
    logic    [I_MNT*2+1:0] pre_mat_shift_ff;

    lead_one #(.IDATA_BIT(I_MNT*2+2), .ODATA_BIT(I_MNT)) lo_inst (
        .idata              (pre_mat_ff),
        .odata              (shift_cnt_temp)
    );  

    assign shift_cnt = (2*I_MNT + 2) - shift_cnt_temp;
    
    assign  pre_exp_shift = pre_exp_ff - shift_cnt + 2;
    assign  pre_mat_shift = pre_mat_ff << ((I_MNT*2+2) - shift_cnt_temp);


    always_ff @(posedge clk) begin
        if (reset) begin
            pre_sig_ff_stage_3 <= 1'b0;
            pre_exp_shift_ff <= 'd0;
            pre_mat_shift_ff <= 'd0;

            idataA_ff_stage_3  <= 'd0;
            idataB_ff_stage_3  <= 'd0;

            idataA_zero_ff_stage_3 <= 1'b0;
            idataB_zero_ff_stage_3 <= 1'b0;
        end
        else begin
            pre_sig_ff_stage_3 <= pre_sig_ff_stage_2;
            pre_exp_shift_ff <= pre_exp_shift;
            pre_mat_shift_ff <= pre_mat_shift;

            idataA_ff_stage_3  <= idataA_ff_stage_2;
            idataB_ff_stage_3  <= idataB_ff_stage_2;

            idataA_zero_ff_stage_3 <= idataA_zero_ff_stage_2;
            idataB_zero_ff_stage_3 <= idataB_zero_ff_stage_2;
        end
    end

    // 3. Output
    assign  odata = (idataA_zero_ff_stage_3 && idataB_zero_ff_stage_3) ? 'd0 :
                     idataA_zero_ff_stage_3                     ? idataB_ff_stage_3 :
                     idataB_zero_ff_stage_3                     ? idataA_ff_stage_3 :
                    {pre_sig_ff_stage_3, pre_exp_shift_ff, pre_mat_shift_ff[(I_MNT*2+1)-:I_MNT]};

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