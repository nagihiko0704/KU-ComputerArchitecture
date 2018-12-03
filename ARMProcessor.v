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
	wire MemWrite;
	wire ALUControl;
	wire ALUSrc;
	wire [1:0] ImmSrc;
	wire RegWrite;
	wire ALUFlags;
	wire [31:0] SrcA;
	wire [31:0] SrcB;
	wire [31:0] ALUResult;
	wire [3:0] RA1;
	wire [3:0] RA2;
	wire [3:0] RA3;
	wire [31:0] result;
	wire [31:0] PCPlus8;
	wire [31:0] WriteData;
	wire [31:0] ExtImm;
	wire [31:0] Instr;
	
	
	RegisterFile registerfile(.RA1(RA1), .RA2(RA2), .RA3(RA3), .WD3(Result), .R15(PCPlus8), .RD1(SrcA), .RD2(), .RD3());
	ALU alu(.ALUResult(ALUResult), .ALUFlags(ALUFlags), .ScrA(ScrA), .ScrB(SrcB), .ALUControl(ALUControl));
	ControlUnit controlunit(.Instr(Instr), .Flags(ALURlags), .PCSrc(PCSrc), .MemtoReg(), .ALUControl(), .ALUSrc(), .ImmSrc(), .RegWrite(), .RegSrc());
	Extend extend(.ExtImm(ExtImm), .Instr(), .ImmSrc(ImmSrc));
	
	always@(posedge clk or negedge reset) begin
		
	end
	
endmodule
