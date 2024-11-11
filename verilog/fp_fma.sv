module fp_fma #(
    parameter I_EXP = 8,
    parameter I_MNT = 23,
    parameter DATA_WIDTH = 1 + I_EXP + I_MANT
)(
    input logic clk,
    input logic reset,
    input logic enable,

    input logic [DATA_WIDTH-1:0] idataA,
    input logic [DATA_WIDTH-1:0] idataB,
    input logic [DATA_WIDTH-1:0] idataC,

    output logic [DATA_WIDTH-1:0] odata,
    output logic out_valid
);

    localparam  EXP_BASE = 2 ** (I_EXP-1) - 1;

    // Extract Exponent and Mantissa Field of Input A and B
    logic                   idataA_sig, idataB_sig, idataA_sig_ff, idataB_sig_ff;
    logic     [I_EXP-1:0]   idataA_exp, idataB_exp, idataA_exp_ff, idataB_exp_ff;
    logic     [I_MNT:0]     idataA_mat, idataB_mat, idataA_mat_ff, idataB_mat_ff;
    logic out_valid_stage_1;

    // Extract Sign, Exponent and Mantissa Field of Input C
    logic                   idataC_sig;
    logic     [I_EXP-1:0]   idataC_exp;
    logic     [I_MNT:0]     idataC_mat;

    // Sign, Exponent and Mantissa Bit for Output
    logic                     product_sig, product_sig_ff;
    logic     [I_EXP:0]       product_exp, product_exp_ff;
    logic     [I_MNT*2+1:0]   product_mat, product_mat_ff;
    logic out_valid_stage_2;


    // Output Normalization: Left shift the mantissia if the top bit is zero.
    logic                   odata_sig, odata_sig_ff;
    logic     [I_EXP-1:0]   odata_exp, odata_exp_ff;
    logic     [I_MNT-1:0]   odata_mat, odata_mat_ff;
    logic out_valid_stage_3;

    assign idataA_sig = idataA[I_DATA-1];
    assign idataA_exp = idataA[I_MNT+:I_EXP];
    assign idataA_mat = {1'b1, idataA[I_MNT-1:0]};

    assign idataB_sig = idataB[I_DATA-1];
    assign idataB_exp = idataB[I_MNT+:I_EXP];
    assign idataB_mat = {1'b1, idataB[I_MNT-1:0]};
    
    assign idataC_sig = idataC[I_DATA-1];
    assign idataC_exp = idataC[I_MNT+:I_EXP];
    assign idataC_mat = {1'b1, idataC[I_MNT-1:0]};


    // Pipeline Register 1 - Capture Input fields
    always_ff @(posedge clk) begin
        if (reset | ~enable) begin
            idataA_sig_ff <= 1'b0;
            idataA_exp_ff <= 'd0;
            idataA_mat_ff <= 'd0;
            idataB_sig_ff <= 1'b0;
            idataB_exp_ff <= 'd0;
            idataB_mat_ff <= 'd0;
            out_valid_stage_1 <= 1'b0;
        end
        else begin
            idataA_sig_ff <= idataA_sig;
            idataA_exp_ff <= idataA_exp;
            idataA_mat_ff <= idataA_mat;
            idataB_sig_ff <= idataB_sig;
            idataB_exp_ff <= idataB_exp;
            idataB_mat_ff <= idataB_mat;
            out_valid_stage_1 <= 1'b1;
        end
    end

    assign product_sig = idataA_sig_ff ^ idataB_sig_ff;
    assign product_exp = idataA_exp_ff + idataB_exp_ff;
    assign product_mat = idataA_mat_ff * idataB_mat_ff;

    // Pipeline Register 2 - Capture Product fields
    always_ff @(posedge clk) begin
        if (reset | ~enable) begin
            product_sig_ff <= 1'b0;
            product_exp_ff <= 'd0;
            product_mat_ff <= 'd0;
            out_valid_stage_2 <= 1'b0;
        end
        else begin
            product_sig_ff <= product_sig;
            product_exp_ff <= product_exp;
            product_mat_ff <= product_mat;
            out_valid_stage_2 <= out_valid_stage_1;
        end
    end

    // Start addition here
    logic product_AB_larger, product_AB_larger_ff;
    logic product_AB_sig; 
    logic [I_EXP-1:0] product_AB_exp;
    logic [I_MNT-1:0] product_AB_mat;  

    assign product_AB_sig = product_sig_ff;
    assign product_AB_exp = (product_mat_ff[I_MNT*2+1]) ? product_exp_ff - EXP_BASE + 1: product_exp_ff - EXP_BASE ; 
    assign product_AB_mat = product_mat_ff[I_MNT*2+1] ? product_mat_ff[(I_MNT*2)-:I_MNT] : product_mat_ff[(I_MNT*2-1)-:I_MNT];

    // Determine Larger Value
    assign product_AB_larger = (product_AB_exp > idataC_exp) ? 1'b1 :
                               ((product_AB_exp == idataC_exp) && (product_AB_mat > idataC_mat)) ? 1'b1 : 1'b0;
    // Determine EXP difference
    logic [I_EXP-1:0] exp_diff;
    assign exp_diff = product_AB_larger ? product_AB_exp - idataC_exp : idataC_exp - product_AB_exp;


    // Pipeline Register 3 - Capture Normalized Output fields
    always_ff @(posedge clk) begin
        if (reset | ~enable) begin
            odata_sig_ff <= 1'b0;
            odata_exp_ff <= 'd0;
            odata_mat_ff <= 'd0;
            out_valid_stage_3 <= 1'b0;
        end
        else begin
            odata_sig_ff <= odata_sig;
            odata_exp_ff <= odata_exp;
            odata_mat_ff <= odata_mat;
            out_valid_stage_3 <= out_valid_stage_2;
        end
    end

    // Assemble Output
    assign  odata = (product_exp_ff < EXP_BASE) ? 'd0 :
                    (idataA_exp_ff == 'd0)      ? 'd0 :
                    (idataB_exp_ff == 'd0)      ? 'd0 :
                    {odata_sig_ff, odata_exp_ff, odata_mat_ff};

    assign out_valid = out_valid_stage_3;
endmodule