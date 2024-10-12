module bit_reverser #(
  parameter NUM_ENTRIES = 8,
  parameter ENTRY_WIDTH = $clog2(NUM_ENTRIES)
)(
  input logic clk,
  input logic reset,
  input logic [ENTRY_WIDTH-1:0] input_array [NUM_ENTRIES-1:0],
  output logic [ENTRY_WIDTH-1:0] output_array [NUM_ENTRIES-1:0]
);

    logic [ENTRY_WIDTH-1:0] reversed_array_comb [NUM_ENTRIES-1:0];

    genvar i;
    genvar j;
    generate
        for(i=0;i<NUM_ENTRIES;i=i+1) begin
            for(j=0; j<ENTRY_WIDTH; j = j+1) begin
            assign reversed_array_comb[i][j] = input_array[i][ENTRY_WIDTH-1-j];
            end
        end
    endgenerate


    always_ff @(posedge clk) begin
    if (reset) begin
        for (int i = 0; i < NUM_ENTRIES; i = i + 1) begin
            output_array[i] <= '0;
        end
    end else begin
        output_array <= reversed_array_comb;
    end

    end

endmodule
