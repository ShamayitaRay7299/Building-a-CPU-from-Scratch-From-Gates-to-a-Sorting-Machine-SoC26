module control(

    input clk,
    input rst,

    input [22:0] decode_out,
    input [1:0] RX,
    input [1:0] RY,

    output reg IRWrite,
    output reg AWrite,
    output reg BWrite,
    output reg ALUOutWrite,
    output reg MDRWrite,
    output reg PCWrite,

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

// FSM STATES

parameter FETCH      = 3'd0;
parameter DECODE     = 3'd1;
parameter EXECUTE    = 3'd2;
parameter MEM_READ   = 3'd3;
parameter MEM_WRITE  = 3'd4;
parameter WRITEBACK  = 3'd5;
parameter BRANCH     = 3'd6;

reg [2:0] state;
reg [2:0] next_state;

// STATE REGISTER

always @(posedge clk or posedge rst) begin

    if(rst)
        state <= FETCH;
    else
        state <= next_state;

end

// COMBINATIONAL FSM

always @(*) begin

    // Defaults

    IRWrite     = 0;
    AWrite      = 0;
    BWrite      = 0;
    ALUOutWrite = 0;
    MDRWrite    = 0;
    PCWrite     = 0;

    c1 = 0;
    c2 = 0;
    c3 = 0;

    c10 = 0;
    c11 = 0;
    c16 = 0;
    c17 = 0;
    c18 = 0;

    c4_5 = RX;
    c6_7 = RY;
    c8_9 = RX;

    c12_14 = 3'b000;

    c15 = decode_out[12] | decode_out[14];

    next_state = FETCH;

    case(state)
    // FETCH

    FETCH: begin

        IRWrite = 1;
        PCWrite = 1;

        next_state = DECODE;

    end

    // DECODE

    DECODE: begin

        AWrite = 1;
        BWrite = 1;

        next_state = EXECUTE;

    end
    // EXECUTE

    EXECUTE: begin

        case (1'b1)

        // MOVE

        decode_out[5]: begin
            next_state = WRITEBACK;
        end

        // LOADI

        decode_out[6]: begin
            next_state = WRITEBACK;
        end

        // ADD

        decode_out[7]: begin
            c12_14 = 3'b001;
            ALUOutWrite = 1;
            next_state = WRITEBACK;
        end
        // ADDI
        decode_out[8]: begin
            c11 = 1;
            c12_14 = 3'b001;
            ALUOutWrite = 1;
            next_state = WRITEBACK;
        end

        // SUB
        decode_out[9]: begin
            c12_14 = 3'b010;
            ALUOutWrite = 1;
            next_state = WRITEBACK;
        end

        // SUBI
        decode_out[10]: begin
            c11 = 1;
            c12_14 = 3'b010;
            ALUOutWrite = 1;
            next_state = WRITEBACK;
        end

        // LOAD / LOADF
        decode_out[11],
        decode_out[12]: begin

            next_state = MEM_READ;

        end

        // STORE / STOREF
        decode_out[13],
        decode_out[14]: begin

            next_state = MEM_WRITE;

        end

        // SHIFTL
        decode_out[15]: begin

            c12_14 = 3'b011;
            ALUOutWrite = 1;

            next_state = WRITEBACK;

        end

        // SHIFTR
        decode_out[16]: begin

            c12_14 = 3'b100;
            ALUOutWrite = 1;

            next_state = WRITEBACK;

        end

        // CMP
        decode_out[17]: begin

            c3 = 1;

            next_state = FETCH;

        end
        // Branches
        decode_out[18],
        decode_out[19],
        decode_out[20],
        decode_out[21],
        decode_out[22]: begin

            next_state = BRANCH;

        end

        default: begin
            next_state = FETCH;
        end

        endcase

    end
    // MEMORY READ
    MEM_READ: begin

        MDRWrite = 1;

        next_state = WRITEBACK;

    end

    // MEMORY WRITE

    MEM_WRITE: begin

        c17 = 1;

        next_state = FETCH;

    end

    // WRITEBACK
    WRITEBACK: begin

        c10 = 1;

        if(decode_out[11] || decode_out[12])
            c18 = 1;

        next_state = FETCH;

    end

    // BRANCH
    BRANCH: begin

        c2 = 1;

        next_state = FETCH;

    end

    default: begin

        next_state = FETCH;

    end

    endcase

end

endmodule