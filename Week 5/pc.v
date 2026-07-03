module pc(
    input clk,
    input rst,
    input load,              // jump/branch
    input inc,               // normal increment
    input [7:0] load_val,    // branch target
    output reg [7:0] pc_out
);

always @(posedge clk) begin
    if (rst)
        pc_out <= 8'd0;
    else if (load)
        pc_out <= load_val;
    else if (inc)
        pc_out <= pc_out + 8'd1;
end

endmodule