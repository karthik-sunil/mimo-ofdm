module fp_add_tb();

parameter CLOCK_PERIOD = 10;
parameter I_EXP = 8;
parameter I_MNT = 23;
parameter I_DATA = I_EXP + I_MNT + 1;

parameter DEBUG_MODE = 0;

logic clk;
logic reset;
logic enable;
logic [I_DATA-1:0] idataA;
logic [I_DATA-1:0] idataB;
logic [I_DATA-1:0] odata, odata_expecected;
logic out_valid;

integer f_out;
// shortreal idataA_f;
// shortreal idataB_f;
// shortreal odata_expecected_f;

// generate
//     if(I_DATA == 16) begin
//         assign idataA = shortreal_to_fp16(idataA_f);
//         assign idataB = shortreal_to_fp16(idataB_f);
//         assign odata_expecected = shortreal_to_fp16(odata_expecected_f);
//     end
//     else begin
//         assign idataA = $shortrealtobits(idataA_f);
//         assign idataB = $shortrealtobits(idataB_f);
//         // assign idataA = 32'h4e02b6ca;
//         // assign idataB = 32'h4cac997e;
//         assign odata_expecected = $shortrealtobits(odata_expecected_f);
//     end
// endgenerate

// assign odata_expecected_f = idataA_f + idataB_f;


function logic [I_DATA-1:0] shortreal_to_fp16(shortreal value);
    logic sign;
    int exponent;
    shortreal abs_value, normalized_value;
    logic [I_MNT-1:0] mantissa;
    logic [I_EXP-1:0] biased_exponent;

    sign = (value < 0);
    abs_value = $abs(value);

    if (abs_value == 0.0) return 16'h0000;

    normalized_value = abs_value;
    exponent = 0;

    // Normalize value and find exponent
    while (normalized_value >= 2.0) begin
        normalized_value /= 2.0;
        exponent++;
    end
    while (normalized_value < 1.0) begin
        normalized_value *= 2.0;
        exponent--;
    end

    // Calculate biased exponent
    biased_exponent = exponent + 15;

    // Handle overflow and underflow
    if (biased_exponent >= 31) begin
        return {sign, 5'b11111, 10'b0000000000}; // Infinity
    end
    if (biased_exponent < 0) begin
        return {sign, 15'b0}; // Underflow to zero
    end

    // Calculate mantissa
    mantissa = $floor((normalized_value - 1.0) * 1024.0);
    mantissa = mantissa & 10'h3FF; // Ensure it's 10 bits
    mantissa = (mantissa[0]) ? mantissa + 1 : mantissa; // Round to nearest even

    return {sign, biased_exponent, mantissa};
endfunction

fp_add #(
    .I_EXP(I_EXP),
    .I_MNT(I_MNT),
    .I_DATA(I_DATA)
) dut (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .idataA(idataA),
    .idataB(idataB),
    .odata(odata),
    .out_valid(out_valid)
);

always begin
    clk = ~clk;
    #(CLOCK_PERIOD/2);
end

initial begin
    clk = 1'b0;
    reset = 1'b1;
    enable = 1'b0;

    @(negedge clk);

    reset = 1'b0;
    enable = 1'b1;
    f_out = $fopen("out/fp_add_out.csv", "w");

    for(int i=0; i<65535; i++) begin
        if (i >= 0) begin
            idataA = 32'h5F3759DF; 
            idataB = $urandom();
        end
        else begin
            idataA = 32'h3F800000;
            idataB = 32'h3F800000;
        end
        repeat(1) @(negedge clk);
        $fdisplay(f_out,"%h,%h,%h,%d", idataA, idataB,odata, out_valid);        

    end

    $fclose(f_out);

$finish;
end


endmodule