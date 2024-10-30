module delay_commutator_tb();

    parameter DELAY = 2;
    parameter DATA_WIDTH = 16;
    parameter CLOCK_PERIOD = 10;

    logic clk;
    logic reset;
    logic [DATA_WIDTH-1:0] x0;
    logic [DATA_WIDTH-1:0] x1;

    logic [DATA_WIDTH-1:0] y0;
    logic [DATA_WIDTH-1:0] y1;

    logic switch_enable;
    logic commutator_out_valid;

    delay_commutator #(
        .DELAY(DELAY),
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .clk(clk),
        .reset(reset),
        .x0(x0),
        .x1(x1),
        .y0(y0),
        .y1(y1),
        .commutator_out_valid(commutator_out_valid)
    );

    always begin
        clk = ~clk;
        #(CLOCK_PERIOD/2);
    end

    always_ff @(negedge clk) begin

        // $display("%d,%d",x1,dut.x1_delayed);
        $display("%d,%d,%d,%d,%d", x0, x1, y0, y1, commutator_out_valid);
        // $display("%d,%d,%d,%d", x1,dut.x1_delayed, dut.delay_x1.delay_counter, dut.delay_x1.out_valid);
    end

    initial begin
        clk = 0;
        reset = 1;
        @(negedge clk);
        reset = 0;
        // @(negedge clk);
        for(int i=0; i<4; i++) begin
            x0 = i;
            x1 = i+4;
            @(negedge clk);
        end

        repeat(10) begin
            x0 = 0;
            x1 = 0;
            @(negedge clk);
        end

        $finish;

    end




endmodule