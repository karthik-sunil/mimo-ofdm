module commutator(
    input logic [2:0] in1;
    input logic [2:0] in2;
    input logic valid;
    output logic [2:0] out1;
    output logic [2:0] out2;
);
    always_comb begin
        if (valid) begin
            //swap
            out1 = in2;
            out2 = in1;
        end else begin
            //direct pass, no swap
            out1 = in1;
            out2 = in2;
        end
    end
endmodule