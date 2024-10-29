module delay #(
    parameter DELAY = 4,
    parameter DATA_WIDTH = 8
)(
    input logic clk,
    input logic reset,
    input logic [DATA_WIDTH-1:0] in,
    output logic [DATA_WIDTH-1:0] out,
    output logic out_valid,
    output logic switch_enable
);

    logic [DATA_WIDTH-1:0] delay_reg [DELAY-1:0];
    logic [$clog2(DELAY):0] delay_counter, switch_counter;


    always_ff @(posedge clk) begin
        if (reset) begin
            for (int i=0; i<DELAY; i++) begin
                delay_reg[i] <= 0;
            end
        end
        else begin
            delay_reg[0] <= in;
            for (int i=1; i<DELAY; i++) begin
                delay_reg[i] <= delay_reg[i-1];
            end
        end
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            delay_counter <= 0;
            switch_counter <= 0;
        end
        else begin
            switch_counter <= (out_valid) ? switch_counter + 1 : 0;
            if (delay_counter == DELAY+1) begin
                delay_counter <= DELAY+1;
            end
            else delay_counter <= delay_counter + 1;
        end
    end

    assign out = delay_reg[DELAY-1];
    assign out_valid = (delay_counter == DELAY+1);
    assign switch_enable = (switch_counter[$clog2(DELAY)]);

endmodule