module ALU(
	ALUResult, ALUFlags,
	ScrA, ScrB, ALUControl, InstrCode
	);
	
	input [31:0] ScrA, ScrB;
	input ALUControl;
	input [2:0] InstrCode;
	
	output reg [31:0] ALUResult;
	output reg ALUFlags;
	
	always@ (*) begin
		case(ALUControl)
			1'b0: //ADD
				begin
					ALUResult = ScrA + ScrB;
				
					if(InstrCode == 3'b010) //MOV
						ALUResult = ScrB;
				end
			1'b1: //SUB
				ALUResult = ScrA - ScrB;
			default: //default is always needed in case statement
				ALUResult <= 31'b0;
		endcase
		
		case(ALUResult)
			32'b0:
				ALUFlags = 1'b1;
			default:
				ALUFlags = 1'b0;
		endcase
	end
endmodule
		