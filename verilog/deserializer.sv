module deserializer #(
    parameter N = 8
)(
    input logic clk, 
    input logic reset,
    input logic enable,

    input complex_product_t data_0,
    input complex_product_t data_1,

    output complex_product_t data_deserialized [N-1:0],
    output logic out_valid
);

    complex_product_t buffer [N-1:0];
    logic [$clog2(N)-1:0] w_ptr;
    logic buffer_ready;


    always_ff @(posedge clk) begin
        if (reset | ~enable) begin
            w_ptr <= N-1;
            buffer_ready <= 0;
            // Clear our buffer
            for (int i=0; i<N; i++) begin
                buffer[i] <= '0;
            end
        end
        else begin
            // Write to buffer, 2 per cycle
            buffer[w_ptr[$clog2(N)-1:0]]       <= data_0;
            buffer[w_ptr[$clog2(N)-1:0] - 1]   <= data_1;

            if (w_ptr == 1) begin
                w_ptr <= N-1;
                buffer_ready <= 1;
            end
            else begin
                w_ptr <= w_ptr - 2;
                buffer_ready <= 0;
            end
        end
    end

    // Output the buffer
    assign data_deserialized = buffer;
    assign out_valid = buffer_ready;

endmodule