module fifo_serializer #(
    parameter N = 8,
    parameter DATA_WIDTH = 32
)(
    input logic clk,
    input logic reset,
    input logic enabl
, // when empty fill it
    input logic [DATA_WIDTH-1:0] data_in [N-1:0],
    output logic [DATA_WIDTH-1:0] data_out_0,
    output logic [DATA_WIDTH-1:0] data_out_1,       
    output logic out_valid
);

/*
Input is received in bursts of N elements from antenna. 
Output is serialized in two streams of N/2 elements each.

data_in_0 and data_in_1 are read out from the head of the FIFO
FIFO drains in N/2 cycles
So, N/2 buffers are needed to hold the incoming bursts

[], [], [], [] <- data_out_0
[], [], [], []    .
[], [], [], []    . N/2
[], [], [], []    .
[], [], [], [] <- data_out_1
[], [], [], []
[], [], [], []
[], [], [], []
*/

logic [DATA_WIDTH-1:0] buffer [N-1:0][N/2-1:0];
logic [DATA_WIDTH-1:0] buffer_ff [N-1:0][N/2-1:0];


always_comb begin
    
end

// Set up read pointer as counter from 0 to N/2
logic [$clog2(N)-2:0] data_read_pointer;
logic [$clog2(N)-2:0] buffer_read_pointer, buffer_write_pointer;

logic [$clog2(N)-1:0] data_read_pointer_ff;
logic [$clog2(N)-1:0] buffer_pointer_ff;


always_ff @(posedge clk) begin
    if(reset | ~enable) begin
        data_read_pointer_ff <= 0;
        buffer_pointer_ff <= 0;
    end
    else begin
        data_read_pointer_ff <= data_read_pointer_ff + 1;
        if(data_read_pointer_ff == (N/2-1)) begin
            data_read_pointer_ff <= 0;
            buffer_pointer_ff <= buffer_pointer_ff + 1;
        end
    end
end

assign data_read_pointer = data_read_pointer_ff[$clog2(N)-2:0]; // Increments every cycle
assign buffer_read_pointer = buffer_pointer_ff; // Slower than data read pointer - increments every N/2 cycles
assign buffer_write_pointer = data_read_pointer_ff[$clog2(N)-2:0];

always_comb begin
    buffer = buffer_ff;
    for(int i = 0; i < N; i++) begin
       buffer[i][buffer_write_pointer] = data_in[i]; 
    end
end

always_ff @(posedge clk) begin
    if(reset | ~enable) begin
        // might have to use loop here
        buffer_ff <= '0;
    end
    else begin
        // might have to use loop here
        buffer_ff <= buffer;
    end
end

assign data_out_0 = buffer_ff[data_read_pointer][buffer_read_pointer];
assign data_out_1 = buffer_ff[data_read_pointer + N/2][buffer_read_pointer];

logic [N-1:0] buffer;


endmodule



// always_ff @(posedge clk or negedge reset) begin
//     if (reset) begin
//         data_read_pointer <=0;
//         out_valid <= 1'b0;
//     end else if (buffer_full) begin
//         data_out_0 <= buffer[data_read_ptr][buffer_read_pointer];
//         data_out_1 <= buffer[data_read_ptr + N/2][buffer_read_pointer]; //not sure
//         out_valid <= 1'b1;
//         data_read_pointer <= data_read_pointer + 1;
//         if (data_read_pointer == (N/2-1)) begin
//             buffer_full <= 1'b0; //empty
//             read_ptr <= 0;
//             out_valid <=1'b0;
//         end
//     end
// end
