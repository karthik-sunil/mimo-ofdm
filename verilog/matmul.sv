
module matmul(
    input logic clk,
    input logic reset,
    input logic signed [31:0] a [0:3][0:3],  // Input matrix A
    input logic signed [31:0] b [0:3][0:3],  // Input matrix B
    output logic signed [31:0] out [0:3][0:3] // Output matrix
);

    // Product and sum registers
    logic [31:0] product [0:3][0:3][0:3];     // Products of multiplication
    logic [31:0] sum [0:3][0:3];               // Final sum for output matrix
    logic [31:0] intermediate_sum_1 [0:3][0:3]; // First intermediate sum
    logic [31:0] intermediate_sum_2 [0:3][0:3]; // Second intermediate sum

    // Valid signals for multiplication and addition
    logic out_valid_mul [0:3][0:3][0:3];       // Valid signals for multiplication
    logic out_valid_add_1 [0:3][0:3];          // Valid signals for first addition
    logic out_valid_add_2 [0:3][0:3];          // Valid signals for second addition
    logic out_valid_add_3 [0:3][0:3];          // Valid signals for third addition

    parameter I_EXP = 8;
    parameter I_MNT = 23;
    parameter I_DATA = I_EXP + I_MNT + 1;


    generate
        for (genvar i = 0; i < 4; i++) begin : row
            for (genvar j = 0; j < 4; j++) begin : col
                for (genvar k = 0; k < 4; k++) begin : mult_add
                    fp_mul #(
                        .I_EXP(I_EXP),
                        .I_MNT(I_MNT),
                        .I_DATA(I_DATA)
                    ) mul_inst (
                        .clk(clk),
                        .reset(reset),
                        .enable(1'b1),
                        .idataA(a[i][k]),
                        .idataB(b[k][j]),
                        .odata(product[i][j][k]),
                        .out_valid(out_valid_mul[i][j][k])
                    );


                end


                fp_add #(
                    .I_EXP(I_EXP),
                    .I_MNT(I_MNT),
                    .I_DATA(I_DATA)
                ) add_inst_1 (
                    .clk(clk),
                    .reset(reset),
                    .enable(out_valid_mul[i][j][0] && out_valid_mul[i][j][1]), // Wait for both products 0 and 1 to be valid
                    .idataA(product[i][j][0]),
                    .idataB(product[i][j][1]),
                    .odata(intermediate_sum_1[i][j]),
                    .out_valid(out_valid_add_1[i][j])
                );



                fp_add #(
                    .I_EXP(I_EXP),
                    .I_MNT(I_MNT),
                    .I_DATA(I_DATA)
                ) add_inst_2 (
                    .clk(clk),
                    .reset(reset),
                    .enable(out_valid_mul[i][j][2] && out_valid_mul[i][j][3]), // Wait for both products 2 and 3 to be valid
                    .idataA(product[i][j][2]),
                    .idataB(product[i][j][3]),
                    .odata(intermediate_sum_2[i][j]),
                    .out_valid(out_valid_add_2[i][j])
                );


                fp_add #(
                    .I_EXP(I_EXP),
                    .I_MNT(I_MNT),
                    .I_DATA(I_DATA)
                ) add_inst_3 (
                    .clk(clk),
                    .reset(reset),
                    .enable(out_valid_add_1[i][j] && out_valid_add_2[i][j]), // Wait for both intermediate sums to be valid
                    .idataA(intermediate_sum_1[i][j]),
                    .idataB(intermediate_sum_2[i][j]),
                    .odata(sum[i][j]),
                    .out_valid(out_valid_add_3[i][j])
                );

                always_ff @(posedge clk) begin
                    if (out_valid_add_3[i][j]) begin
                        out[i][j] <= sum[i][j];
                    end else begin 
                        out[i][j] <= sum[i][j];
                    end
                end
                
 
            end
        end
    endgenerate

endmodule