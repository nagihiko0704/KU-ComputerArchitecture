module Extend(
	ExtImm,
	Instr, ImmSrc
	);
 
 input [23:0] Instr;
 input [1:0] ImmSrc;
 output [31:0] ExtImm;
 
 reg [31:0] ext;
 
 always @(*) begin
	case(ImmSrc)
		2'b00: //no action
		2'b01: //data processing type
			begin
				ext[7:0] <= Instr[7:0];
				ext[31:8] <= {24{Instr[7]}};
			end
		2'b10: //LDR/STR type
			begin
				ext[11:0] <= Instr[11:0];
				ext[31:12] <= {20{Instr[11]}};
			end
		2'b11: //branch type
			begin
				ext[31:0] <= {{6{Instr[23]}}, Instr[23:0], 2'b00};
			end
		default: //no action
	endcase
	
	assign ExtImm = ext;
endmodule
