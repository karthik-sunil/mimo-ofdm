module twiddle_control_pointer_tb();

parameter N = 16;

parameter NUM_STAGES = $clog2(N);
parameter COUNTER_SIZE = $clog2(N) - 1;


logic clk; 
logic reset;

// Vector of enables 
logic [NUM_STAGES-1:0] enable;
logic [NUM_STAGES-1:0] twiddle_pointers [COUNTER_SIZE-1:0];


assign twiddle_pointers [NUM_STAGES-1] = 0;

genvar i;
generate
    for (i=0; i<NUM_STAGES; i++) begin 
        twiddle_control_pointer #(
            .N(N),
            .STEP(1<<i)
        ) twiddle_control_pointer_inst (
            .clk(clk),
            .reset(reset),
            .enable(enable[i]),
            .pointer(twiddle_pointers[i])
        );
    end
endgenerate

always begin
    clk = ~clk; 
    #5;
end

always @(negedge clk) begin
        for(int i=0; i<NUM_STAGES-1; i++) begin
            $display("%0d, %0d, %b", i, twiddle_pointers[i], enable);
        end
        $display("final_pointer: %0d", 0);
end

initial begin
    clk = 0;
    reset = 1;
    enable = 0;
    @(negedge clk);
    reset = 0;
    enable[0] = 1;
    @(negedge clk);
    enable[1] = 1;
    @(negedge clk);
    enable[2] = 1;
    @(negedge clk);
    repeat(100) begin
        @(negedge clk);
    end

    #100;
    $finish;
end

endmodule