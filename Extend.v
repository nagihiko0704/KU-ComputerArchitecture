module Extend(
	ExtImm,
	Instr, ImmSrc
	);
 
 input [23:0] Instr;
 input [1:0] ImmSrc;
 output reg [31:0] ExtImm;
 
 wire [3:0] rotValue = Instr[11:8] * 2;
 wire [39:0] rotResult = {Instr[7:0], {24{1'b0}}, Instr[7:0]} >> rotValue;
 
	always @(*) begin
		case(ImmSrc)
			2'b00:; //no action
			2'b01: //data processing type
				begin
					ExtImm = rotResult[31:0];
				end
			2'b10: //LDR/STR type
				begin
					ExtImm = {{20{1'b0}} ,Instr[11:0]};
				end
			2'b11: //branch type
				begin
					ExtImm = {{6{Instr[23]}}, Instr[23:0], 2'b00};
				end
			default:
				ExtImm = {{6{Instr[23]}}, Instr[23:0], 2'b00}; //no action
		endcase
	end
endmodule