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
	
	wire [31:0] SrcA;
	wire [31:0] D2;
	wire [31:0] ExtImm;
	wire [1:0] RegSrc;
	wire [1:0] ImmSrc;
	wire MemWrite;
	wire [31:0] SrcB;
	wire ALUSrc; 
	wire ALUControl;
	wire ALUFlags;
	wire RegWrite;
	wire MemtoReg;
	wire PCSrc;
	wire [31:0] Result;
	wire [31:0] ALUResult;
	wire [2:0] InstrCode;
	
	reg Flag_R;
	reg [31:0] PC_R;
	
	wire [31:0] PCPlus4 = PC_R + 4;
	wire [31:0] PCPlus8 = PC_R + 8; 

	assign pc = PC_R;
	
	ControlUnit cu (.PCSrc(PCSrc), .MemtoReg(MemtoReg), .MemWrite(MemWrite), .ALUControl(ALUControl), 
					.ALUSrc(ALUSrc), .ImmSrc(ImmSrc), .RegWrite(RegWrite), .RegSrc(RegSrc), .InstrCode(InstrCode),
					.Instr(inst), .Flags(Flag_R), .FlagWrite(FlagWrite));
	Extend ext (.ExtImm(ExtImm),
				.Instr(inst[23:0]), .ImmSrc(ImmSrc));
	ALU alu (.ALUResult(ALUResult), .ALUFlags(ALUFlags),
				.ScrA(SrcA), .ScrB(SrcB), .ALUControl(ALUControl), .InstrCode(InstrCode));
				
	wire [3:0] RA1 = (RegSrc[0] == 0 ? inst[19:16] : 4'b1111);
	wire [3:0] RA2 = (RegSrc[1] == 0 ? inst[3:0] : inst[15:12]);
	wire [3:0] RA3 = (InstrCode == 3'b111 ? 4'b1110 : inst[15:12]);
	wire [31:0] WD3 = (InstrCode == 3'b111 ? PCPlus4 : Result);
	
	RegisterFile rf (.RD1(SrcA), .RD2(D2),
						.CLK(clk), .A1(RA1), .A2(RA2), .A3(RA3), .R15(PCPlus8), 
						.WD3(WD3), .WE3(RegWrite), .InstrCode(InstrCode));

	assign SrcB = (ALUSrc == 0 ? D2 : ExtImm); //?????RTL strange
	assign memwrite = MemWrite;
	assign memaddr = ALUResult;
	assign writedata = D2;
	assign Result = (MemtoReg == 0) ? ALUResult : readdata;
	
	always@(negedge clk) begin
		if(reset)
			begin
				PC_R = 32'b0;
				Flag_R = 1'b0;
			end
		else
			begin
				if(FlagWrite)
					begin
						Flag_R <= ALUFlags;
					end
				
				PC_R <= (PCSrc == 0 ? PCPlus4 : Result);
			end
	end
	
endmodule