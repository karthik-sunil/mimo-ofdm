
module bit_reverser_tb;

parameter CLOCK_PERIOD = 10;


parameter NUM_ENTRIES = 8;
parameter ENTRY_WIDTH = $clog2(NUM_ENTRIES);

logic clk;
logic reset;
logic [ENTRY_WIDTH-1:0] input_array[NUM_ENTRIES-1:0];
logic [ENTRY_WIDTH-1:0] output_array[NUM_ENTRIES-1:0];

bit_reverser dut (
    .clk(clk),
    .reset(reset),
    .input_array(input_array),
    .output_array(output_array)
);

always begin
    clk = ~clk;
    #(CLOCK_PERIOD/2);
end

initial begin
    clk = 0;
    reset = 1;

    @(negedge clk);
    reset = 0;

    // Input set 1
    for(int i = 0; i < NUM_ENTRIES; i = i + 1) begin
        input_array[i] = i;
    end

    @(negedge clk);

    $display("Output Array");
    for (int i = 0; i < NUM_ENTRIES; i = i + 1) begin
        $display("%b,%b", input_array[i], output_array[i]);
    end

    $finish;
    
end
endmodule