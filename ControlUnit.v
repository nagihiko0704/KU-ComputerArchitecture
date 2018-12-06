module ControlUnit(
	PCSrc, MemtoReg, MemWrite, ALUControl, ALUSrc, ImmSrc, RegWrite, RegSrc, InstrCode, FlagWrite,
	Instr, Flags
	);
	
	input [31:0] Instr;
	input Flags;
	
	output PCSrc;
	output MemtoReg;
	output MemWrite;
	output ALUControl;
	output ALUSrc;
	output [1:0] ImmSrc;
	output RegWrite;
	output RegSrc;
	output [2:0] InstrCode;
	output reg FlagWrite;
	
	reg [3:0] Cond;
	reg [1:0] Op;
	reg [5:0] Funct;
	reg [3:0] Rd;
	reg Zbit;
	
	reg [3:0] OpCode; 
	
	reg PCSrc_R;
	reg MemtoReg_R;
	reg MemWrite_R;
	reg ALUControl_R;
	reg ALUSrc_R;
	reg [1:0] ImmSrc_R;
	reg RegWirte_R;
	reg RegSrc_R;
	reg [2:0] InstrCode_R; //ADD 000 SUB 001 MOV 010 CMP 011 STR 100 LDR 101 B 110 BL 111

	
	always@(*) begin
	
		Cond <= Instr[31:28];
		Op <= Instr[27:26];
		Funct <= Instr[25:20];
		Rd <= Instr[15:12] ;
		Zbit <= Flags;
		
		OpCode <= Instr[24:21];
		
		if (Cond == 4'b1110
			|| (Cond == 4'b0000 && Zbit == 1'b1)
			|| (Cond == 4'b0001 && Zbit == 1'b0))
			begin
				case(Op)
					2'b00: //ADD, SUB, MOV, CMP
						begin
							case(OpCode)
								4'b0100: //ADD
									begin
										PCSrc_R <= 1'b0;
										MemtoReg_R <= 1'b0;
										MemWrite_R <= 1'b0;
										ALUControl_R <= 1'b0;
										ALUSrc_R <= (Instr[25] == 0 ? 1'b0 : 1'b1);
										ImmSrc_R <= (Instr[25] == 0 ? 2'b00 : 2'b01);
										RegWirte_R <= 1'b1;
										RegSrc_R <= 1'b0;
										InstrCode_R <= 3'b000;
										FlagWrite <= (Instr[20] == 0 ? 1'b1 : 1'b0);
									end
								4'b0010: //SUB
									begin
										PCSrc_R <= 1'b0;
										MemtoReg_R <= 1'b0;
										MemWrite_R <= 1'b0;
										ALUControl_R <= 1'b1;
										ALUSrc_R <= (Instr[25] == 0 ? 1'b0 : 1'b1);
										ImmSrc_R <= (Instr[25] == 0 ? 2'b00 : 2'b01);
										RegWirte_R <= 1'b1;
										RegSrc_R <= 1'b0;
										InstrCode_R <= 3'b001;
										FlagWrite <= (Instr[20] == 0 ? 1'b1 : 1'b0);
										end
								4'b1101: //MOV
									begin
										PCSrc_R <= 1'b0;
										MemtoReg_R <= 1'b0;
										MemWrite_R <= 1'b0;
										ALUControl_R <= 1'b0;
										ALUSrc_R <= (Instr[25] == 0 ? 1'b0 : 1'b1);
										ImmSrc_R <= (Instr[25] == 0 ? 2'b00 : 2'b01);
										RegWirte_R <= 1'b1;
										RegSrc_R <= 1'b0;
										InstrCode_R <= 3'b010;
										FlagWrite <= (Instr[20] == 0 ? 1'b1 : 1'b0);
									end
								4'b1010: //CMP
									begin
										PCSrc_R <= 1'b0;
										MemtoReg_R <= 1'bx;
										MemWrite_R <= 1'b0;
										ALUControl_R <= 1'b1;
										ALUSrc_R <= (Instr[25] == 0 ? 1'b0 : 1'b1);
										ImmSrc_R <= (Instr[25] == 0 ? 2'b00 : 2'b01);
										RegWirte_R <= 1'b0;
										RegSrc_R <= 1'b0;
										InstrCode_R <= 3'b011;
										FlagWrite <= 1'b1;
									end
								default:; //do nothing
							endcase
						end
					2'b01: //LDR, STR
						begin
							case(Instr[20])
								1'b0: //STR
									begin
										PCSrc_R <= 1'b0;
										MemtoReg_R <= 1'bx;
										MemWrite_R <= 1'b1;
										ALUControl_R <= (Instr[23] == 0 ? 1'b1 : 1'b0);
										ALUSrc_R <= (Instr[25] == 1 ? 1'b0 : 1'b1);
										ImmSrc_R <= (Instr[25] == 1 ? 2'b00 : 2'b10);
										RegWirte_R <= 1'b0;
										RegSrc_R <= 1'b0;
										InstrCode_R <= 3'b100;
									end
								1'b1: //LDR
									begin
										PCSrc_R <= 1'b0;
										MemtoReg_R <= 1'b1;
										MemWrite_R <= 1'b0;
										ALUControl_R <= (Instr[23] == 0 ? 1'b1 : 1'b0);
										ALUSrc_R <= (Instr[25] == 1 ? 1'b0 : 1'b1);
										ImmSrc_R <= (Instr[25] == 1 ? 2'b00 : 2'b10);
										RegWirte_R <= 1'b1;
										RegSrc_R <= 1'b0;
										InstrCode_R <= 3'b101;
									end
								default:; //do nothing
							endcase
						end
					2'b10: //B, BL
						begin
							case(Instr[24])
								1'b0: //B
									begin
										PCSrc_R <= 1'b1;
										MemtoReg_R <= 1'b0;
										MemWrite_R <= 1'b0;
										ALUControl_R <= 1'b0;
										ALUSrc_R <= 1'b1;
										ImmSrc_R <= 2'b11;
										RegWirte_R <= 1'b0;
										RegSrc_R <= 1'b1;
										InstrCode_R <= 3'b110;
									end
								1'b1: //BL
									begin
										PCSrc_R <= 1'b1;
										MemtoReg_R <= 1'b0;
										MemWrite_R <= 1'b0;
										ALUControl_R <= 1'b0;
										ALUSrc_R <= 1'b1;
										ImmSrc_R <= 2'b11;
										RegWirte_R <= 1'b0;
										RegSrc_R <= 1'b1;
										InstrCode_R <= 3'b111;
									end
								default:; //do nothing
							endcase
						end
					default:; //do nothing
				endcase
			end
	end
	
	assign PCSrc = PCSrc_R;
	assign MemtoReg = MemtoReg_R;
	assign MemWrite = MemWrite_R;
	assign ALUControl = ALUControl_R;
	assign ALUSrc = ALUSrc_R;
	assign ImmSrc = ImmSrc_R;
	assign RegWrite = RegWirte_R;
	assign RegSrc = RegSrc_R;
	assign InstrCode = InstrCode_R;
endmodule
