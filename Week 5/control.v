module control(
    input [22:0] decode_out,
    input [1:0] RX,
    input [1:0] RY,

    output reg c1,
    output reg c2,
    output reg c3,

    output reg [1:0] c4_5,
    output reg [1:0] c6_7,
    output reg [1:0] c8_9,

    output reg c10,
    output reg c11,
    output reg [2:0] c12_14,

    output reg c15,
    output reg c16,
    output reg c17,
    output reg c18
);

always @(*) begin
    c1 = 0;
    c2 = 0;
    c3 = 0;

    c4_5 = RX;
    c6_7 = RY;
    c8_9 = RX;

    c10 = 0;
    c11 = 0;
    c12_14 = 3'b000;

    c15 = 0;
    c16 = 0;
    c17 = 0;
    c18 = 0;

    case (1'b1)

        decode_out[5]: begin // MOVE
            c10 = 1;
            c12_14 = 3'b000;
        end

        decode_out[6]: begin // LOADI
            c10 = 1;
            c11 = 1;
        end

        decode_out[7]: begin // ADD
            c10 = 1;
            c12_14 = 3'b001;
        end

        decode_out[8]: begin // ADDI
            c10 = 1;
            c11 = 1;
            c12_14 = 3'b001;
        end

        decode_out[9]: begin // SUB
            c10 = 1;
            c12_14 = 3'b010;
        end

        decode_out[10]: begin // SUBI
            c10 = 1;
            c11 = 1;
            c12_14 = 3'b010;
        end

        decode_out[11]: begin // LOAD
            c10 = 1;
            c18 = 1;
        end

        decode_out[12]: begin // LOADF
            c10 = 1;
            c15 = 1;
            c18 = 1;
        end

        decode_out[13]: begin // STORE
            c17 = 1;
        end

        decode_out[14]: begin // STOREF
            c15 = 1;
            c17 = 1;
        end

        decode_out[15]: begin // SHIFTL
            c10 = 1;
            c12_14 = 3'b011;
        end

        decode_out[16]: begin // SHIFTR
            c10 = 1;
            c12_14 = 3'b100;
        end

        decode_out[17]: begin // CMP
            c3 = 1;
            c12_14 = 3'b101;
        end

        decode_out[18]: begin // JUMP
            c2 = 1;
        end

        decode_out[19],
        decode_out[20],
        decode_out[21],
        decode_out[22]: begin
            c2 = 1;
        end
    endcase
end

endmodule