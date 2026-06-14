module decoder(
	input [15:0] instructions,
	output reg [22:0] decode_out,
	output [1:0] RY,
	output [1:0] RX
);
wire [3:0] opcode;
wire w0, w1;

assign opcode[3:0] = instructions[15:12];
assign RY[1:0] = instructions[9:8];
assign RX[1:0] = instructions[11:10];
assign w0 = instructions[8];
assign w1 = instructions[9];

always @(*) begin
	decode_out = 23'b0;

	case(opcode)
	4'd0: decode_out[0] = 1; //NOOP
	4'd1: begin
		case ({w1, w0})
			2'b00: decode_out[1] = 1; //INPUTC
			2'b01: decode_out[2] = 1; //INPUTCF
			2'b10: decode_out[3] = 1; //INPUTD
			2'b11: decode_out[4] = 1; //INPUTDF
		endcase
	end
	4'd2: decode_out[5] = 1; //MOVE
	4'd3: decode_out[6] = 1; //LOADI/LOADP
	4'd4: decode_out[7] = 1; //ADD
	4'd5: decode_out[8] = 1; //ADDI
	4'd6: decode_out[9] = 1; //SUB
	4'd7: decode_out[10] = 1; //SUBI
	4'd8: decode_out[11] = 1; // LOAD
	4'd9: decode_out[12] = 1; //LOADF
	4'd10: decode_out[13] = 1; //STORE
	4'd11: decode_out[14] = 1; //STOREF
	4'd12: begin
		case (w0)
			1'b0: decode_out[15] = 1; //SHIFTL;
			1'b1: decode_out[16] = 1; //SHIFTR;
		endcase
	end
	4'd13: decode_out[17] = 1; //CMP
	4'd14: decode_out[18] = 1; //JUMP
	4'd15: begin
		case({w1, w0})
			2'b00: decode_out[19] = 1; //BRE/ BRZ
			2'b01: decode_out[20] = 1; //BRNE/ BRNZ
			2'b10: decode_out[21] = 1; //BRG
			2'b11: decode_out[22] = 1; //BRGE
		endcase
	end
	endcase
end

endmodule
 