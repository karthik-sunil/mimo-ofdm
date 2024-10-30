// In the delay commutator, for each stage, delay by N/k samples where k ranges from 4 to N in powers of two.
module delay_commutator #(
    parameter DELAY = 4,
    parameter DATA_WIDTH = 16
)(
    input logic clk,
    input logic reset,
    input logic enable,
    input logic [DATA_WIDTH-1:0] x0,
    input logic [DATA_WIDTH-1:0] x1,
    output logic [DATA_WIDTH-1:0] y0,
    output logic [DATA_WIDTH-1:0] y1,
    output logic commutator_out_valid
);

    // Delay x1 by D cycles
    // Do not delay x0

    logic out_valid, switch_enable, switch_enable_ff;
    logic [DATA_WIDTH-1:0] x1_delayed;
    logic [DATA_WIDTH-1:0] x0_ff, x1_ff;
    logic [DATA_WIDTH-1:0] y0_comb, y1_comb;

    delay #(
        .DELAY(DELAY),
        .DATA_WIDTH(DATA_WIDTH)
    ) delay_x1 (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .in(x1),
        .out(x1_delayed),
        .out_valid(out_valid),
        .switch_enable(switch_enable)
    );    

    // Synchronize x0 and x1_delayed 
    always_ff @(posedge clk) begin
        if (reset | ~enable) begin
            x0_ff <= 0;
            x1_ff <= 0;
            switch_enable_ff <= 0;
        end
        else begin
            x0_ff <= x0;
            x1_ff <= x1_delayed;
            switch_enable_ff <= switch_enable;
        end
    end

    assign {y0_comb,y1_comb} = (switch_enable_ff)? {x1_ff,x0_ff} : {x0_ff, x1_ff};

    // Delay y0 by D cycles
    // Do not delay y1

    logic [DATA_WIDTH-1:0] y0_delayed;
    logic commutator_out_valid_comb, commutator_out_valid_ff;

    delay #(
        .DELAY(DELAY),
        .DATA_WIDTH(DATA_WIDTH)
    ) delay_y0 (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .in(y0_comb),
        .out(y0_delayed),
        .out_valid(commutator_out_valid_comb),
        .switch_enable()
    );

    always_ff @(posedge clk) begin
        if (reset | ~enable) begin
            commutator_out_valid_ff <= 0;
        end
        else begin
        commutator_out_valid_ff <= commutator_out_valid_comb;
    end
    end

    assign y0 = y0_delayed;
    assign y1 = y1_comb;
    assign commutator_out_valid = commutator_out_valid_ff;

endmodule