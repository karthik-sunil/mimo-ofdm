module delay_by_d #(
    parameter DELAY = 4;
)(
    input logic clk,
    input logic [2:0] in,
    input logic [2:0] out
);
// delay shift register
logic [2:0] delay_reg [DELAY-1:0];

always_ff @(posedge clk) begin
    delay_reg[0] <= in;
    for(int i=1; i< DELAY; i++) begin
        delay_reg[i] <= delay_reg[i-1];
    end
end

assign out = delay_reg[DELAY-1];

endmodule