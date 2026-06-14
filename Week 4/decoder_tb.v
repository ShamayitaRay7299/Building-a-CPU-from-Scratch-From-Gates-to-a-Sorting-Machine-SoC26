module decoder_tb;

reg [15:0] instructions;
wire [22:0] decode_out;
wire [1:0] RX;
wire [1:0] RY;

decoder uut (
    .instructions(instructions),
    .decode_out(decode_out),
    .RX(RX),
    .RY(RY)
);

integer errors = 0;

task test_case;
    input [15:0] instr;
    input [22:0] expected_decode;
    input [1:0] expected_rx;
    input [1:0] expected_ry;

    begin
        instructions = instr;
		  #10;
        if ((decode_out === expected_decode) &&
            (RX === expected_rx) &&
            (RY === expected_ry)) begin

            $display("Pass: instr=%b decode=%b RX=%b RY=%b",
                     instr, decode_out, RX, RY);
        end
        else begin
            $display("Fail: instr=%b", instr);
            $display(" Expected decode=%b RX=%b RY=%b",
                     expected_decode, expected_rx, expected_ry);
            $display(" Got      decode=%b RX=%b RY=%b",
                     decode_out, RX, RY);
            errors = errors + 1;
        end
    end
endtask

initial begin
    $display("Decoder test starting");

    // NOOP
    test_case(16'b0000_00_00_00000000,
              23'b00000000000000000000001,
              2'b00, 2'b00);

    // INPUT group
    test_case(16'b0001_01_00_00000000,
              23'b00000000000000000000010,
              2'b01, 2'b00); // INPUTC

    test_case(16'b0001_10_01_00000000,
              23'b00000000000000000000100,
              2'b10, 2'b01); // INPUTCF

    test_case(16'b0001_11_10_00000000,
              23'b00000000000000000001000,
              2'b11, 2'b10); // INPUTD

    test_case(16'b0001_00_11_00000000,
              23'b00000000000000000010000,
              2'b00, 2'b11); // INPUTDF

    // MOVE
    test_case(16'b0010_01_10_00000000,
              23'b00000000000000000100000,
              2'b01, 2'b10);

    // LOADI
    test_case(16'b0011_10_11_00000000,
              23'b00000000000000001000000,
              2'b10, 2'b11);

    // ADD
    test_case(16'b0100_01_00_00000000,
              23'b00000000000000010000000,
              2'b01, 2'b00);

    // ADDI
    test_case(16'b0101_11_10_00000000,
              23'b00000000000000100000000,
              2'b11, 2'b10);

    // SUB
    test_case(16'b0110_10_01_00000000,
              23'b00000000000001000000000,
              2'b10, 2'b01);

    // SUBI
    test_case(16'b0111_00_11_00000000,
              23'b00000000000010000000000,
              2'b00, 2'b11);

    // LOAD
    test_case(16'b1000_01_10_00000000,
              23'b00000000000100000000000,
              2'b01, 2'b10);

    // LOADF
    test_case(16'b1001_11_00_00000000,
              23'b00000000001000000000000,
              2'b11, 2'b00);

    // STORE
    test_case(16'b1010_10_11_00000000,
              23'b00000000010000000000000,
              2'b10, 2'b11);

    // STOREF
    test_case(16'b1011_01_01_00000000,
              23'b00000000100000000000000,
              2'b01, 2'b01);

    // SHIFTL
    test_case(16'b1100_10_00_00000000,
              23'b00000001000000000000000,
              2'b10, 2'b00);

    // SHIFTR
    test_case(16'b1100_01_01_00000000,
              23'b00000010000000000000000,
              2'b01, 2'b01);

    // CMP
    test_case(16'b1101_11_10_00000000,
              23'b00000100000000000000000,
              2'b11, 2'b10);

    // JUMP
    test_case(16'b1110_00_01_00000000,
              23'b00001000000000000000000,
              2'b00, 2'b01);

    // BRE
    test_case(16'b1111_10_00_00000000,
              23'b00010000000000000000000,
              2'b10, 2'b00);

    // BRNE
    test_case(16'b1111_01_01_00000000,
              23'b00100000000000000000000,
              2'b01, 2'b01);

    // BRG
    test_case(16'b1111_11_10_00000000,
              23'b01000000000000000000000,
              2'b11, 2'b10);

    // BRGE
    test_case(16'b1111_00_11_00000000,
              23'b10000000000000000000000,
              2'b00, 2'b11);

    $display("Test completed");

    if (errors == 0)
        $display("All tests passed");
    else
        $display("Total failures = %0d", errors);

    $finish;
end

endmodule