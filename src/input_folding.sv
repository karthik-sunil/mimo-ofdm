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

complex_product_t data_in_delayed;
logic out_valid_delayed;
logic switch_enable;

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

complex_product_t data_in_ff; 
complex_product_t data_in_delayed_ff; 
logic out_valid_delayed_ff; 

always_ff @(posedge clk) begin
    if (reset | ~enable) begin
        data_in_delayed_ff <= '0;
        data_in_ff <= '0;
        out_valid_delayed_ff <= 0;
    end 
    else begin
        data_in_delayed_ff <= data_in_delayed;
        data_in_ff <= data_in;
        out_valid_delayed_ff <= out_valid_delayed;
    end
end

assign data_out_0 = data_in_delayed_ff;
assign data_out_1 = data_in_ff;
assign out_valid = out_valid_delayed_ff;


endmodule