module data_memory(
    input clk,
    input we,                // write enable
    input [7:0] addr,        // memory address
    input [7:0] wdata,       // data to write
    output [7:0] rdata       // data read
);

reg [7:0] mem [0:255];      // 256 bytes memory

// Initialize unsorted array
initial begin
    mem[0] = 8'd7;
    mem[1] = 8'd3;
    mem[2] = 8'd2;
    mem[3] = 8'd8;
    mem[4] = 8'd1;
    mem[5] = 8'd5;
    mem[6] = 8'd4;
    mem[7] = 8'd6;

    mem[250] = 8'd0; // temp
    mem[251] = 8'd7; // constant 7
end

// synchronous write
always @(posedge clk) begin
    if (we)
        mem[addr] <= wdata;
end

// asynchronous read
assign rdata = mem[addr];

endmodule