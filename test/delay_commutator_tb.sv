module delay_commutator_tb();

    parameter DELAY = 4;
    parameter DATA_WIDTH = 16;
    parameter CLOCK_PERIOD = 10;

    logic clk;
    logic reset;
    logic enable;

    complex_product_t x0;
    complex_product_t x1;

    complex_product_t y0;
    complex_product_t y1;

    logic switch_enable;
    logic commutator_out_valid;

    delay_commutator #(
        .DELAY(DELAY),
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
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
        if(1) begin
            // $display("%d,%d,%d,%d,[%b]", x0, x1, x0, dut.x1_delayed,dut.switch_enable);
            $display("%d,%d,%d,%d,%d", x0.r, x1.r, y0.r, y1.r, commutator_out_valid);
        end
        // $display("%d,%d,%d,%d", x1,dut.x1_delayed, dut.delay_x1.delay_counter, dut.delay_x1.out_valid);
    end

    initial begin
        clk = 0;
        reset = 1;
        enable = 0;

        @(negedge clk);
        reset = 0;
        enable = 1;
        
        for(int i=0; i<2*DELAY; i++) begin
            x0.r = i;
            x0.i = 0;
            x1.r = i+2*DELAY;
            x1.i = 0;
            @(negedge clk);
        end

        repeat(10) begin
            x0.r = 0;
            x0.i = 0;
            x1.r = 0;
            x1.i = 0;
            @(negedge clk);
        end

        $finish;

    end




endmodule