module cpu(
    input clk,
    input rst
);

wire [7:0] pc_out;
wire [15:0] instruction;
wire [22:0] decode_out;
wire [1:0] RX;
wire [1:0] RY;

wire c1,c2,c3,c10,c11,c15,c16,c17,c18;
wire [1:0] c4_5,c6_7,c8_9;
wire [2:0] c12_14;

wire [7:0] reg_a;
wire [7:0] reg_b;
wire [7:0] alu_b;
wire [7:0] alu_result;
wire zero;
wire equal;
wire greater;
wire [7:0] mem_out;
wire [7:0] writeback_data;

reg flag_equal;
reg flag_greater;

wire branch_taken;
wire [7:0] mem_addr;

assign branch_taken =
       decode_out[18] ||
      (decode_out[19] && flag_equal) ||
      (decode_out[20] && ~flag_equal) ||
      (decode_out[21] && flag_greater) ||
      (decode_out[22] && (flag_equal || flag_greater));

pc PC(
    .clk(clk),
    .rst(rst),
    .load(c2 && branch_taken),
    .inc(~(c2 && branch_taken)),
    .load_val(instruction[7:0]),
    .pc_out(pc_out)
);

instruction_memory IMEM(
    .addr(pc_out),
    .instruction(instruction)
);

decoder DEC(
    .instructions(instruction),
    .decode_out(decode_out),
    .RX(RX),
    .RY(RY)
);

control CTRL(
    .decode_out(decode_out),
    .RX(RX),
    .RY(RY),
    .c1(c1),
    .c2(c2),
    .c3(c3),
    .c4_5(c4_5),
    .c6_7(c6_7),
    .c8_9(c8_9),
    .c10(c10),
    .c11(c11),
    .c12_14(c12_14),
    .c15(c15),
    .c16(c16),
    .c17(c17),
    .c18(c18)
);

regfile RF(
    .clk(clk),
    .we(c10),
    .raddr0(c4_5),
    .raddr1(c6_7),
    .waddr(c8_9),
    .wdata(writeback_data),
    .rdata0(reg_a),
    .rdata1(reg_b)
);

assign alu_b = c11 ? instruction[7:0] : reg_b;

alu ALU(
    .a(reg_a),
    .b(alu_b),
    .op(c12_14),
    .result(alu_result),
    .zero(zero),
    .equal(equal),
    .greater(greater)
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        flag_equal <= 0;
        flag_greater <= 0;
    end
    else if (c3) begin
        flag_equal <= equal;
        flag_greater <= greater;
    end
end

always @(posedge clk) begin
    $display(
      "PC=%0d Instr=%b A=%0d B=%0d C=%0d D=%0d EQ=%b GT=%b",
      pc_out,
      instruction,
      RF.regs[0],
      RF.regs[1],
      RF.regs[2],
      RF.regs[3],
      flag_equal,
      flag_greater
    );
end
assign mem_addr =
    c15 ? (reg_b + instruction[7:0]) :
          instruction[7:0];

data_memory DMEM(
    .clk(clk),
    .we(c17),
    .addr(mem_addr),
    .wdata(reg_a),
    .rdata(mem_out)
);

assign writeback_data =
    c18 ? mem_out :
    decode_out[6] ? instruction[7:0] : // LOADI only
    decode_out[5] ? reg_b :            // MOVE
    alu_result;                        // ADD, ADDI, SUB, SUBI, shifts

endmodule