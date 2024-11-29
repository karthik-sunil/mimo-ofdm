module twiddle_pointers#(
    parameter N = 8,
    parameter NUM_STAGES = $clog2(N),
    parameter NUM_BUTTERFLIES = N/2
)(
    input logic clk,
    input logic reset, 
    input logic enable,

    output logic [$clog2(NUM_BUTTERFLIES)-1:0] twiddle_pointers [NUM_STAGES-1:0]
);

logic [$clog2(NUM_BUTTERFLIES)-1:0] twiddle_counters [NUM_STAGES-1:0];

always_ff @(posedge clk) begin
    if (reset | ~enable) begin
        for(int i=0; i<NUM_STAGES; i++) begin
            twiddle_counters[i] <= 0;
        end
    end 
    else begin
        for(int i=0; i<NUM_STAGES; i++) begin
            twiddle_counters[i] <= twiddle_counters[i] + (1<<i);
        end
    end
end

assign twiddle_pointers = twiddle_counters;

endmodule