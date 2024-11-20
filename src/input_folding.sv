module input_folding #(
    parameter N = 8
)(
    input logic clk,
    input logic reset,
    input logic enable,

    input complex_product_t data_in,
    output complex_product_t data_out_0,
    output complex_product_t data_out_1,

    output logic out_valid
);

// Delay data_in by N/2 cycles
// When out_valid of delay is 1, data_out_0 and data_out_1 are valid
// data_0 = delayed(data_in, N/2)
// data_1 = data_in

complex_product_t data_in_delayed;
logic out_valid_delayed;

delay #(
    .DELAY(N/2)
) delay_inst (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .in(data_in),
    .out(data_in_delayed),
    .out_valid(out_valid_delayed),
    .switch_enable()
);    

assign data_out_0 = data_in_delayed;
assign data_out_1 = data_in;
assign out_valid = out_valid_delayed;

endmodule