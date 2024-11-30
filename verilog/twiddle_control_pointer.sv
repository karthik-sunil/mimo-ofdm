module twiddle_control_pointer #(
    parameter N = 8,
    parameter STEP = 1, 
    parameter COUNTER_SIZE = $clog2(N) - 1
)(
    input logic clk,
    input logic reset, 
    input logic enable, 

    output logic [COUNTER_SIZE-1:0] pointer
);

logic [COUNTER_SIZE-1:0] counter;

always_ff @(posedge clk) begin
    if (reset | ~enable) begin
        counter <= 0;
    end 
    else begin
        counter <= counter + STEP;
    end
end

assign pointer = counter;

endmodule