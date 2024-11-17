module pointers #(
    parameter N = 16
)(
    input logic clk,
    input logic reset,
    input logic enable,

    output logic [$clog2(N)-2:0] read_pointer,
    output logic [$clog2(N)-2:0] buffer_pointer
);


logic [$clog2(N)-1:0] read_pointer_ff;
logic [$clog2(N)-1:0] buffer_pointer_ff;

always_ff @(posedge clk) begin
    if(reset | ~enable) begin
        read_pointer_ff <= 0;
        buffer_pointer_ff <= 0;
    end
    else begin
        read_pointer_ff <= read_pointer_ff + 1;
        if(read_pointer_ff == (N/2-1)) begin
            read_pointer_ff <= 0;
            buffer_pointer_ff <= buffer_pointer_ff + 1;
        end
    end
end

assign read_pointer = read_pointer_ff[$clog2(N)-2:0];
assign buffer_pointer = buffer_pointer_ff;

endmodule 