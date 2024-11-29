module twiddle_pointers_tb();

parameter N = 8;

logic clk;
logic reset;
logic enable;

parameter NUM_STAGES = $clog2(N);
parameter NUM_BUTTERFLIES = N/2;

logic [$clog2(NUM_BUTTERFLIES)-1:0] twiddle_pointers [NUM_STAGES-1:0];

logic signed [15:0] twiddle_factors_real [N/2-1:0];
logic signed [15:0] twiddle_factors_imag [N/2-1:0];

assign twiddle_factors_real[0] = 256;
assign twiddle_factors_imag[0] = 0;
assign twiddle_factors_real[1] = 181;
assign twiddle_factors_imag[1] = -181;
assign twiddle_factors_real[2] = 0;
assign twiddle_factors_imag[2] = -256;
assign twiddle_factors_real[3] = -181;
assign twiddle_factors_imag[3] = -181;

twiddle_pointers #(
    .N(N),
    .NUM_STAGES(NUM_STAGES),
    .NUM_BUTTERFLIES(NUM_BUTTERFLIES)
) twiddle_pointers_inst (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .twiddle_pointers(twiddle_pointers)
);

always begin
    clk = ~clk; 
    #5;
end

always @(negedge clk) begin
    if (enable) begin
        for(int i=0; i<NUM_STAGES; i++) begin
            $display("%0d, %0d", twiddle_pointers[i], twiddle_factors_real[twiddle_pointers[i]], twiddle_factors_imag[twiddle_pointers[i]]);
        end
        $display("--------------------");
    end
end

initial begin
    clk = 0;
    reset = 1;
    enable = 0;
    @(negedge clk);
    reset = 0;
    enable = 1;
    repeat(N) begin
        @(negedge clk);
    end

    #100;
    $finish;
end


endmodule