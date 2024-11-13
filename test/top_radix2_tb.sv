`timescale 1ns/1ps
`include "verilog/headers.svh"

module top_all_tb;

    localparam DATA_WIDTH = 16;
    localparam N = 8;
    localparam CLK_PERIOD = 10;

    logic clk;
    logic reset;
    complex_t x[N-1:0];
    complex_product_t y[N-1:0]; 
    logic dc_chain_out_valid;

    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    top_all #(
        .DATA_WIDTH(DATA_WIDTH),
        .N(N)
    ) dut (
        .clk(clk),
        .reset(reset),
        .x(x),
        .y(y),
        .dc_chain_out_valid(dc_chain_out_valid)
    );

    initial begin
        reset = 1;

        // intitial values we want to test for once cycle
        x[0].r = 0; x[0].i = 0;
        x[1].r = 1; x[1].i = 0;
        x[2].r = 2; x[2].i = 0;
        x[3].r = 3; x[3].i = 0;
        x[4].r = 4; x[4].i = 0;
        x[5].r = 5; x[5].i = 0;
        x[6].r = 6; x[6].i = 0;
        x[7].r = 7; x[7].i = 0;

        @(negedge clk);
        reset = 0;

        @(negedge clk);
        
        $display("Final FFT Output:");
        for (int i = 0; i < N; i++) begin
            $display("y[%0d] = %0d + %0dj", i, y[i].r, y[i].i);
        end

        repeat (20) @(posedge clk) begin
            $display("Clock Cycle: %0t", $time);

            $display("butterfly 0 input: A = %0d +%0dj , B = %0d + %0dj", dut.x[0].r, dut.x[0].i, dut.x[N/2].r, dut.x[N/2].i);
            //iniitial butterfly outputs and DC inputs at each stage
            $display("Stage 1 Butterfly Outputs:");
            $display("Butterfly 0 Output: X = %0d + %0dj, Y = %0d + %0dj", 
                        dut.butterfly_out0[0].r, dut.butterfly_out0[0].i,
                        dut.butterfly_out1[0].r, dut.butterfly_out1[0].i);

                        
            for (int i = 1; i < $clog2(N); i++) begin
                // dc for each stage
                $display("Stage %0d Delay Commutator Inputs:", i+1);
                $display("DC Input X0 = %0d + %0dj, X1 = %0d + %0dj", 
                            dut.butterfly_out0[i-1].r, dut.butterfly_out0[i-1].i,
                            dut.butterfly_out1[i-1].r, dut.butterfly_out1[i-1].i);
                
                $display("Stage %0d Delay Commutator Outputs:", i+1);
                $display("DC Output Y0 = %0d + %0dj, Y1 = %0d + %0dj", 
                            dut.dc_out0[i-1].r, dut.dc_out0[i-1].i,
                            dut.dc_out1[i-1].r, dut.dc_out1[i-1].i);

                //  butterfly inputs and outputs for each stage
                $display("Stage %0d Butterfly Inputs:", i+1);
                $display("Butterfly Input A = %0d + %0dj, B = %0d + %0dj", 
                            dut.dc_out0[i-1].r, dut.dc_out0[i-1].i,
                            dut.dc_out1[i-1].r, dut.dc_out1[i-1].i);

                $display("Stage %0d Butterfly Outputs:", i+1);
                $display("Butterfly Output X = %0d + %0dj, Y = %0d + %0dj", 
                            dut.butterfly_out0[i].r, dut.butterfly_out0[i].i,
                            dut.butterfly_out1[i].r, dut.butterfly_out1[i].i);
            end
            $display("------------------------------------------------");
        end
        
        $finish;
    end

endmodule