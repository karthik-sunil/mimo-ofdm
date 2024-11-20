module delay #(
    parameter DELAY = 4
)(
    input logic clk,
    input logic reset,
    input logic enable,
    input complex_product_t in,
    output complex_product_t out,
    output logic out_valid,
    output logic switch_enable
);

    complex_product_t delay_reg [DELAY-1:0];
    logic [$clog2(DELAY):0] delay_counter, switch_counter;


    always_ff @(posedge clk) begin
        if (reset | ~enable) begin
            for (int i=0; i<DELAY; i++) begin
                delay_reg[i].r <= 0;
                delay_reg[i].i <= 0;
            end
        end
        else begin
            delay_reg[0] <= in;
            for (int i=1; i<DELAY; i++) begin
                delay_reg[i].r <= delay_reg[i-1].r;
                delay_reg[i].i <= delay_reg[i-1].i;
            end
        end
    end

    always_ff @(posedge clk) begin
        if (reset | ~enable) begin
            delay_counter <= 0;
            switch_counter <= 0;
        end
        else begin
            switch_counter <= (out_valid) ? switch_counter + 1 : 0;
            if (delay_counter == DELAY) begin
                delay_counter <= DELAY;
            end
            else delay_counter <= delay_counter + 1;
        end
    end

    assign out = delay_reg[DELAY-1];
    assign out_valid = (delay_counter == DELAY);
    assign switch_enable = out_valid & (~switch_counter[$clog2(DELAY)]);

endmodule