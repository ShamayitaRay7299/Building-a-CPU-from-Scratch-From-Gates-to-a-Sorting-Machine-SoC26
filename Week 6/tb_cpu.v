module tb_cpu;

reg clk;
reg rst;

cpu uut(
    .clk(clk),
    .rst(rst)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

integer i;

always @(posedge clk) begin
    $display(
    "State=%0d PC=%0d IR=%h A=%0d B=%0d EQ=%b GT=%b",
        uut.CTRL.state,
        uut.pc_out,
        uut.IR,
        uut.A,
        uut.B,
        uut.flag_equal,
        uut.flag_greater
    );
end
always @(posedge clk) begin
    $display(
    "S=%0d PC=%0d IR=%h c2=%b branch=%b EQ=%b GT=%b",
        uut.CTRL.state,
        uut.pc_out,
        uut.IR,
        uut.c2,
        uut.branch_taken,
        uut.flag_equal,
        uut.flag_greater
    );
end

always @(posedge clk) begin
    $display(
      "R0=%0d R1=%0d R2=%0d R3=%0d",
      uut.RF.regs[0],
      uut.RF.regs[1],
      uut.RF.regs[2],
      uut.RF.regs[3]
    );
end

always @(posedge clk) begin
    $display(
      "M0=%0d M1=%0d M2=%0d M3=%0d",
      uut.DMEM.mem[0],
      uut.DMEM.mem[1],
      uut.DMEM.mem[2],
      uut.DMEM.mem[3]
    );
end

always @(posedge clk) begin
    $display(
        "WE=%b WADDR=%0d WDATA=%0d",
        uut.c10,
        uut.c8_9,
        uut.writeback_data
    );
end

always @(posedge clk) begin
    $display(
        "READ0=%0d READ1=%0d",
        uut.c4_5,
        uut.c6_7
    );
end
initial begin
    rst = 1;
    #20;
    rst = 0;

    #20000;

    $display("Sorted array:");
    for(i=0;i<8;i=i+1)
        $display("mem[%0d] = %0d", i, uut.DMEM.mem[i]);

    $finish;
end
initial begin
$monitor(
"S=%0d PC=%0d IR=%h load=%b inc=%b branch=%b target=%0d",
uut.CTRL.state,
uut.pc_out,
uut.IR,
uut.c2,
uut.PCWrite,
uut.branch_taken,
uut.IR[7:0]
);
	 end
endmodule