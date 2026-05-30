// Week 2 — 8-bit ALU
// op: 000=ADD 001=SUB 010=AND 011=OR 100=XOR 101=SHIFTL 110=SHIFTR
// Run: iverilog -o sim ../testbenches/tb_alu.v alu.v && vvp sim

module alu(
    input  [7:0]     a, b,
    input  [2:0]     op,
    output reg [7:0] result,
    output           zero,
    output reg       carry,
    output reg       overflow
);
    reg [8:0] actual;
    always @(*) begin
        result  = 8'b0;
        carry = 1'b0;
        overflow = 1'b0;
        actual = 9'b0;

        case(op)
            3'b000: begin
                actual = a + b;
                result = actual[7:0];
                carry = actual[8];
                overflow = (~(a[7]^b[7])) & (result[7] ^ a[7]);
            end;
            3'b001: begin
                actual = a - b;
                result = actual[7:0];
                carry = actual[8];
                overflow = (a[7]^b[7]) & (result[7] ^ a[7]);
            end;
            3'b010: result = a & b;
            3'b011: result = a | b;
            3'b100: result = a ^ b;
            3'b101: begin
                carry = a[7];
                result = a << 1;
            end;
            3'b110: begin
                carry = a[0];
                result = a >> 1;      
            end;
            default: result = 8'b0;
        endcase
    end

    assign zero = (result == 8'b0);
    
endmodule
