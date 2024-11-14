module pointers_tb();

parameter N = 8;

logic clk;
logic reset;
logic enable;

logic [$clog2(N)-1:0] read_pointer;
logic [$clog2(N)-1:0] buffer_pointer;

pointers #(
    .N(N)
) dut (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .read_pointer(read_pointer),
    .buffer_pointer(buffer_pointer)
);

always begin
    clk = ~clk;
    #10;
end

initial begin
clk = 0;
reset = 1;
enable = 0;

@(negedge clk);
reset = 0;
enable = 1;

for(int i = 0; i < 32; i++) begin
    $display("read_pointer = %d, %d, buffer_pointer = %d", read_pointer, read_pointer + N/2, buffer_pointer);
    @(negedge clk);
end


$finish();
end


endmodule