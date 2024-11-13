module dc_top_tb();

    parameter DATA_WIDTH = 32;
    parameter CLOCK_PERIOD = 10;

    parameter N = 16;

    localparam NUM_COMMUTATORS = $clog2(N) - 1;

    logic clk;
    logic reset;
    logic [DATA_WIDTH-1:0] x0;
    logic [DATA_WIDTH-1:0] x1;

    logic [DATA_WIDTH-1:0] y0;
    logic [DATA_WIDTH-1:0] y1;

    logic dc_chain_out_valid;

    int f_out;

    dc_top #(
        .DATA_WIDTH(DATA_WIDTH),
        .N(N)
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

    always @(negedge clk) begin
        if (N==8) begin
            $fdisplay(f_out,"%d, %d | %d, %d, [%b] | %d, %d, [%b]", x0, x1, dut.x0_dc[0], dut.x1_dc[0], dut.dc_out_valid[0] ,y0, y1, dc_chain_out_valid);
        end

        else if (N==16) begin
            $fdisplay(f_out,"%d, %d | %d, %d, [%b] | %d, %d, [%b] | %d, %d, [%b]", x0, x1, dut.x0_dc[0], dut.x1_dc[0], dut.dc_out_valid[0], dut.x0_dc[1], dut.x1_dc[1], dut.dc_out_valid[1] ,y0, y1, dc_chain_out_valid);
        end

        else if (N==32) begin
            $fdisplay(f_out,"%d, %d | %d, %d, [%b] | %d, %d, [%b] | %d, %d, [%b] | %d, %d, [%b]", x0, x1, dut.x0_dc[0], dut.x1_dc[0], dut.dc_out_valid[0], dut.x0_dc[1], dut.x1_dc[1], dut.dc_out_valid[1] , dut.x0_dc[2], dut.x1_dc[2], dut.dc_out_valid[2], y0, y1, dc_chain_out_valid);
        end

        else if (N==64) begin
            $fdisplay(f_out,"%d, %d | %d, %d, [%b] | %d, %d, [%b] | %d, %d, [%b] | %d, %d, [%b] | %d, %d, [%b]", x0, x1, dut.x0_dc[0], dut.x1_dc[0], dut.dc_out_valid[0], dut.x0_dc[1], dut.x1_dc[1], dut.dc_out_valid[1] , dut.x0_dc[2], dut.x1_dc[2], dut.dc_out_valid[2], dut.x0_dc[3], dut.x1_dc[3], dut.dc_out_valid[3], y0, y1, dc_chain_out_valid);
        end

        else begin
             $fdisplay(f_out,"%d, %d, %d, %d, [%b]", x0, x1, y0, y1, dc_chain_out_valid);
        end
    end

    initial begin
        clk = 0;
        reset = 1;
        @(negedge clk);
        reset = 0;
        f_out = $fopen("out/delay_commutator_out.csv", "w");

        // Generate N point input
        for(int i=0; i<N/2; i++) begin
            x0 = i;
            x1 = i+N/2;
            @(negedge clk);
        end

        repeat(N) begin
            x0 = 0;
            x1 = 0;
            @(negedge clk);
        end

        $fclose(f_out);

        $finish;

    end




endmodule