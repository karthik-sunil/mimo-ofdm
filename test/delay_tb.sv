`timescale 1ps/1ps
`include "verilog/headers.svh"

module delay_tb();
    // must be power of 2
    parameter DELAY = 2;
    parameter DATA_WIDTH = 16;
    parameter CLOCK_PERIOD = 10;

    logic clk;
    logic reset; 
    logic enable;

    complex_product_t in;
    complex_product_t out;
    logic out_valid;
    logic switch_enable;

    integer f_out;

    delay #(
        .DELAY(DELAY),
        .DATA_WIDTH(DATA_WIDTH)
    ) dut(
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .in(in),
        .out(out),
        .out_valid(out_valid),
        .switch_enable(switch_enable)
    );

    always begin
        clk = ~clk;
        #(CLOCK_PERIOD/2);
    end

    always @(negedge clk) begin
        if($isunknown(out)) begin
            // $fdisplay(f_out,"%5d | %d | %d |   %d   |    %d   |", ($time/CLOCK_PERIOD)-1, in.r, 0, out_valid, switch_enable);

        end
        else begin
            // $fdisplay(f_out,"%5d | %d | %d |   %d   |    %d   |", ($time/CLOCK_PERIOD)-1, in.r, out, out_valid, switch_enable);
            $fdisplay(f_out,"%d %d, %d %d, %d", in.r, in.i, out.r, out.i, out_valid);
        end
    end

    initial begin
        clk = 0;
        reset = 1; 
        enable = 0;
        @(negedge clk);
        reset = 0;
        enable = 1;

        f_out = $fopen("out/delay_tb_output.txt", "w");

        $display("Simulation Starts");
        $fdisplay(f_out,"Cycle | In  | Out | Valid | Switch |");

        for(int i=0; i<4; i++) begin
            in.r = i+4;
            in.i = 0;
            @(negedge clk);
        end

        repeat(DELAY) begin
            in.r = 0;
            in.i = 0;
            @(negedge clk);
        end

        $display("Simulation Ends");

        $fclose(f_out);

        #100; 
        
        $finish;        

    end

endmodule