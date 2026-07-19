module regfile(
    input clk,
    input we,

    input  [1:0] raddr0,
    input  [1:0] raddr1,
    input  [1:0] waddr,

    input  [7:0] wdata,

    output [7:0] rdata0,
    output [7:0] rdata1
);

reg [7:0] regs [0:3];
integer i;

initial begin
    for (i = 0; i < 4; i = i + 1)
        regs[i] = 8'd0;
end

always @(posedge clk) begin
    if (we)
        regs[waddr] <= wdata;
end

assign rdata0 = regs[raddr0];
assign rdata1 = regs[raddr1];

endmodule