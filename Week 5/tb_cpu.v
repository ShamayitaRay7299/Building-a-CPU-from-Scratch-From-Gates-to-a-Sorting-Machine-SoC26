module tb_cpu;

reg clk;
reg rst;

cpu uut(
    .clk(clk),
    .rst(rst)
);

// Clock
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

integer i;

// Debug print every cycle
always @(posedge clk) begin
   $display(
"PC=%d Instr=%b c3=%b BRE=%b BRNE=%b EQ=%b GT=%b branch=%b",
uut.pc_out,
uut.instruction,
uut.c3,
uut.decode_out[19],
uut.decode_out[20],
uut.flag_equal,
uut.flag_greater,
uut.branch_taken
);
end

always @(posedge clk) begin
    if (uut.c17)
        $display("STORE addr=%d data=%d", uut.mem_addr, uut.reg_a);
end
always @(posedge clk) begin
    $display("PC=%0d A=%0d B=%0d EQ=%b GT=%b",
        uut.pc_out,
        uut.RF.regs[0],   // A
        uut.RF.regs[1],   // B
        uut.flag_equal,
        uut.flag_greater
    );
end
initial begin
    rst = 1;
    #20;
    rst = 0;

    #100000;

    $display("Sorted array:");
    for(i=0; i<8; i=i+1)
        $display("mem[%0d] = %0d", i, uut.DMEM.mem[i]);

    $finish;
end

endmodule