module ALU(
	ALUResult, ALUFlags,
	ScrA, ScrB, ALUControl
	);
	
	input [31:0] ScrA, ScrB;
	input ALUControl;
	
	output [31:0] ALUResult;
	output ALUFlags;
	
	reg [31:0] result;
	reg flag;
	
	always@ (*) begin
		case(ALUControl)
			1'b0: //ADD
				result <= ScrA + ScrB;
			1'b1: //SUB
				result <= ScrA - ScrB;
			default: //default is always needed in case statement
				result <= 31'b0;
		endcase
		
		case(result)
			32'b0:
				flag <= 1'b1;
			default:
				flag <= 0'b1;
		endcase
		
		assign ALUResult = result;
		assign ALUFlags = flag;
	end
	
endmodule
		