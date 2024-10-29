`timescale 1ps/1ps
module delay_tb();
    // must be power of 2
    parameter DELAY = 64;
    parameter DATA_WIDTH = 16;
    parameter CLOCK_PERIOD = 10;

    logic clk;
    logic reset; 

    logic [DATA_WIDTH-1:0] in;
    logic [DATA_WIDTH-1:0] out;
    logic out_valid;
    logic switch_enable;

    integer f_out;

    delay #(
        .DELAY(DELAY),
        .DATA_WIDTH(DATA_WIDTH)
    ) dut(
        .clk(clk),
        .reset(reset),
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
            $fdisplay(f_out,"%5d | %d | %5d |   %d   |    %d   |", ($time/CLOCK_PERIOD)-2, in, 0, out_valid, switch_enable);
        end
        else begin
            $fdisplay(f_out,"%5d | %d | %5d |   %d   |    %d   |", ($time/CLOCK_PERIOD)-2, in, out, out_valid, switch_enable);
        end
    end

    initial begin
        clk = 0;
        reset = 1; 
        @(negedge clk);
        reset = 0;
        @(negedge clk);

        f_out = $fopen("out/delay_tb_output.txt", "w");

        $display("Simulation Starts");
        $fdisplay(f_out,"Cycle | In  | Out | Valid | Switch |");

        for(int i=0; i<DELAY*16; i++) begin
            in = i;
            @(negedge clk);
        end

        repeat(DELAY) begin
            in = 0;
            @(negedge clk);
        end

        $display("Simulation Ends");

        $fclose(f_out);

        #100; 
        
        $finish;        

    end

endmodule