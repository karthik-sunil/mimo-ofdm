module interleaver #(
    parameter N = 8
)(
    input logic clk,
    input logic reset,
    input logic enable,

    input complex_product_t x0,
    input complex_product_t x1, 

    output complex_product_t data_out_0,
    output complex_product_t data_out_1,
    output logic out_valid
);

complex_product_t x0_out_0;
complex_product_t x0_out_1;
logic x0_out_valid;

// Fold x0
input_folding #(
    .N(N)
) fold_x0 (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .data_in(x0),
    .data_out_0(x0_out_0),
    .data_out_1(x0_out_1),
    .out_valid(x0_out_valid)
);

complex_product_t x1_delayed; 
logic x1_delayed_out_valid;

// Delay x1
delay #(
    .DELAY(N/2)
) delay_x1 (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .in(x1),
    .out(x1_delayed),
    .out_valid(x1_delayed_out_valid),
    .switch_enable()
);

complex_product_t x1_out_0;
complex_product_t x1_out_1;
logic x1_out_valid;

// Fold x1
input_folding #(
    .N(N)
) fold_x1 (
    .clk(clk),
    .reset(reset),
    .enable(x1_delayed_out_valid),
    .data_in(x1_delayed),
    .data_out_0(x1_out_0),
    .data_out_1(x1_out_1),
    .out_valid(x1_out_valid)
);

// Selection Counter
logic [$clog2(N)-2:0] select_counter;
logic switch_line;

always_ff @(posedge clk) begin
    if (reset | ~enable) begin
        select_counter <= 0;
        switch_line <= 0;
    end
    else if (enable) begin
        select_counter <= select_counter + 1;
        switch_line <= (select_counter == 0) ? ~switch_line : switch_line;
    end
end

assign data_out_0 = switch_line ? x1_out_0 : x0_out_0;
assign data_out_1 = switch_line ? x1_out_1 : x0_out_1;
assign out_valid = x0_out_valid;

endmodule