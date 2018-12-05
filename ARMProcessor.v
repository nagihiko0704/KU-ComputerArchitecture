module armreduced(
	input clk,
	input reset,
	output[31:0] pc,
	input[31:0] inst,
	input nIRQ,
	output[3:0] be,
	output[31:0] memaddr,
	output memwrite,
	output memread,
	output[31:0] writedata,
	input[31:0] readdata
	);
	assign be = 4'b1111; // default
	assign memread = 'b1; // default
	
	wire PCSrc;
	wire MemtoReg;
	wire ALUControl;
	wire ALUSrc;
	wire [1:0] ImmSrc;
	wire RegWrite;
	wire RegSrc;
	wire ALUFlags;
	wire [31:0] SrcA;
	wire [31:0] SrcB;
	wire [31:0] ALUResult;
	//wire [31:0] result;
	wire [31:0] WriteData;
	wire [31:0] ExtImm;
	wire [31:0] Instr;
	wire [2:0] InstrCode;
	
	reg [31:0] PC;
	reg [31:0] PCPlus4;
	reg [31:0] PCPlus8;
	reg [3:0] A1_R;
	reg [3:0] A2_R;
	reg [3:0] A3_R;
	reg [31:0] SrcB_R;
	reg [31:0] result_R;
	reg [31:0] ALUResult_R;
	reg [31:0] readdata_R;
	

	
	RegisterFile registerfile(.CLK(clk), .WE3(RegWrite) ,.RA1(A1_R), .RA2(A2_R), .RA3(A3_R), .WD3(readdata), .R15(PCPlus8), .RD1(SrcA), .RD2(SrcB), .RD3(writedata), .InstrCode(InstrCode));
	ALU alu(.ALUResult(ALUResult), .ALUFlags(ALUFlags), .ScrA(SrcA), .ScrB(SrcB_R), .ALUControl(ALUControl), .InstrCode(InstrCode));
	ControlUnit controlunit(.Instr(inst), .Flags(ALUFlags), .PCSrc(PCSrc), .MemtoReg(MemtoReg), .MemWrite(memwrite), .ALUControl(ALUControl), .ALUSrc(ALUSrc), .ImmSrc(ImmSrc), .RegWrite(RegWrite), .RegSrc(RegSrc), .InstrCode(InstrCode));
	Extend extend(.ExtImm(ExtImm), .Instr(inst), .ImmSrc(ImmSrc));
	
	assign memaddr = ALUResult_R;
	assign pc = PC;
	
	always@(posedge clk) begin
		if(reset)
			begin
				PC = 32'b0;
			end
		
		PCPlus4 = PC + 32'b0000_0000_0000_0000_0000_0000_0000_0100; //pc + 4
		PCPlus8 = PCPlus4 + 32'b0000_0000_0000_0000_0000_0000_0000_0100; //pc + 8
		A3_R <= inst[15:12]; 
		ALUResult_R <= ALUResult;
		readdata_R <= readdata;
				
		case(RegSrc) //mux for input A1, A2
			1'b0:
				begin
					A1_R <= inst[19:16];
					A2_R <= inst[3:0];
				end
			1'b1:
				begin
					A1_R <= 4'b1111;
					A2_R <= inst[15:12];
				end
			default:; //do nothing
		endcase
				
		case(ALUSrc) //mux for SrcB
			1'b0:
				begin
					SrcB_R <= SrcB;
				end
			1'b1:
				begin
					SrcB_R <= ExtImm;
				end
			default:; //do nothing
		endcase
				
		case(MemtoReg) //mux for result
			1'b0:
				begin
					result_R <= ALUResult_R;
				end
			1'b1:
				begin
					result_R <= readdata_R;
				end
			default:; //do nothing
		endcase
		
		case(PCSrc)
			1'b0:
				begin
					PC <= PCPlus4; //
				end
			1'b1:
				begin
					PC <= result_R;
				end
			default:
				PC <= PCPlus4; //do nothing
		endcase
	end
	
endmodule
