module instruction_memory(
    input [7:0] addr,
    output [15:0] instruction
);

reg [15:0] mem [0:255];
integer i;

initial begin
    for (i=0; i<256; i=i+1)
        mem[i] = 16'b0000_00_00_00000000;

    mem[0]  = 16'b1000_11_00_11111011; // LOAD D,[251]
    mem[1]  = 16'b0011_00_00_00000000; // LOADI A,0
    mem[2]  = 16'b0011_01_00_00000000; // LOADI B,0

    mem[3]  = 16'b1001_10_01_00000000; // LOADF C,[B]
    mem[4]  = 16'b1001_11_01_00000001; // LOADF D,[B+1]

    mem[5]  = 16'b1101_10_11_00000000; // CMP C,D
    mem[6]  = 16'b1111_00_10_00001000; // BRG 8
    mem[7]  = 16'b1110_00_00_00001010; // JUMP 10

    mem[8]  = 16'b1011_11_01_00000000; // STOREF D,[B]
    mem[9]  = 16'b1011_10_01_00000001; // STOREF C,[B+1]

    mem[10] = 16'b0101_01_00_00000001; // ADDI B,1
    mem[11] = 16'b1000_11_00_11111011; // LOAD D,[251]
    mem[12] = 16'b1101_01_11_00000000; // CMP B,D
    mem[13] = 16'b1111_00_01_00000011; // BRNE 3

    mem[14] = 16'b0101_00_00_00000001; // ADDI A,1
    mem[15] = 16'b1000_11_00_11111011; // LOAD D,[251]
    mem[16] = 16'b1101_00_11_00000000; // CMP A,D
    mem[17] = 16'b1111_00_01_00000010; // BRNE 2

    mem[18] = 16'b0000_00_00_00000000; // STOP
end

assign instruction = mem[addr];

endmodule