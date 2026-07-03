module alu(
    input [7:0] a,
    input [7:0] b,
    input [2:0] op,

    output reg [7:0] result,
    output zero,
    output equal,
    output greater
);

always @(*) begin
    case(op)
        3'b000: result = b;       // MOVE / PASS
        3'b001: result = a + b;   // ADD
        3'b010: result = a - b;   // SUB
        3'b011: result = a << 1;  // SHIFTL
        3'b100: result = a >> 1;  // SHIFTR
        3'b101: result = 8'd0;    // CMP dummy
        default: result = 8'd0;
    endcase
end

assign zero    = (result == 8'd0);
assign equal   = (a == b);
assign greater = (a > b);

endmodule