module twiddle_control_pointer #(
    parameter N = 8,
    parameter STEP = 1, 
    parameter COUNTER_SIZE = $clog2(N) - 1
)(
    input logic clk,
    input logic reset, 
    input logic enable, 

    output logic [COUNTER_SIZE-1:0] pointer,
    output logic out_valid
);

logic [COUNTER_SIZE-1:0] counter;
logic out_valid_ff;

always_ff @(posedge clk) begin
    if (reset | ~enable) begin
        counter <= 0;
        out_valid_ff <= 0;
    end 
    else begin
        counter <= counter + STEP;
        out_valid_ff <= 1;
    end
end

assign pointer = counter;
assign out_valid = out_valid_ff;

endmodule