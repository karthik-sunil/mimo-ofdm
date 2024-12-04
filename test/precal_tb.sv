`timescale 1ns/100ps

module testbench();

    logic clock;
    logic reset;
    logic [31:0] H_matrix[0:3][0:3];
    logic [31:0] signal_receive[0:3];
    logic [31:0] snr;
    logic [31:0] matrix_A [0:3][0:3];
    logic [31:0] vector_b [0:3];

    pre_cal cal(

        //input
        .clk(clock),
        .reset(reset),
        .H_matrix(H_matrix),
        .signal_receive(signal_receive),
        .snr(snr),

        //output
        .matrix_A(matrix_A),
        .vector_b(vector_b)
    );
    task show_the_matrix;
        begin
            $display("show the matrix result:");
            for(int i=0;i<4;i++) begin
                for(int j=0;j<4;j++)begin
                    $write(" %d",matrix_A[i][j]);
                end
                $write("/n");
            end
            $display("matrix end");
        end
    endtask //
    

    always begin
        #5;
        clock=~clock;
    end

    initial begin
        $display("@@@");
        clock =1'b0;
        reset =1'b1;
        
        snr=32'b1;
        H_matrix[0][0]=32'h3f800000;//1
        H_matrix[0][1]=32'h3f800000;
        H_matrix[0][2]=32'h3f800000;
        H_matrix[0][3]=32'h3f800000;
        H_matrix[1][0]=32'h3f800000;
        H_matrix[1][1]=32'h3f800000;
        H_matrix[1][2]=32'h3f800000;
        H_matrix[1][3]=32'h3f800000;
        H_matrix[2][0]=32'h3f800000;
        H_matrix[2][1]=32'h3f800000;
        H_matrix[2][2]=32'h3f800000;
        H_matrix[2][3]=32'h3f800000;
        H_matrix[3][0]=32'h3f800000;
        H_matrix[3][1]=32'h3f800000;
        H_matrix[3][2]=32'h3f800000;
        H_matrix[3][3]=32'h3f800000;
        signal_receive[0]=32'h3f800000;
        signal_receive[1]=32'h3f800000;
        signal_receive[2]=32'h3f800000;
        signal_receive[3]=32'h3f800000;

        show_the_matrix();
        @(negedge clock);
        @(negedge clock);
        $finish;

    end


endmodule