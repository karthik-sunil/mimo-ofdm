module dc_chain_tb();

    parameter DATA_WIDTH = 16;
    parameter CLOCK_PERIOD = 10;

    logic clk;
    logic reset;
    logic [DATA_WIDTH-1:0] x0;
    logic [DATA_WIDTH-1:0] x1;

    logic [DATA_WIDTH-1:0] y0;
    logic [DATA_WIDTH-1:0] y1;

    logic dc_chain_out_valid;

    dc_chain #(
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .clk(clk),
        .reset(reset),
        .x0(x0),
        .x1(x1),
        .y0(y0),
        .y1(y1),
        .dc_chain_out_valid(dc_chain_out_valid)
    );

    always begin
        clk = ~clk;
        #(CLOCK_PERIOD/2);
    end

    always_ff @(negedge clk) begin
        if(dc_chain_out_valid) begin
            $display("%d, %d, %d, %d", x0, x1, y0, y1);
            // $display("%d, %d, %d, %d, [%b], %d, %d, [%b]", x0, x1, dut.x0_dc2, dut.x1_dc2, dut.dc2_out_valid, y0, y1, dut.dc1_out_valid);
        end
    end

    initial begin
        clk = 0;
        reset = 1;
        @(negedge clk);
        reset = 0;

        for(int i=0; i<2*2; i++) begin
            x0 = i;
            x1 = i+2*2;
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