module RegisterFile(
	RD1, RD2, RD3,
	CLK, WE3, A1, A2, WD3, R15
	);
	
	input CLK;
	input [31:0] WE3;
	input [3:0] A1;
	input [3:0] A2;
	input [31:0] WD3;
	input [31:0] R15;
	
	output [3:0] RD1;
	output [3:0] RD2;
	output [3:0] RD3;
	
	reg [31:0] register[15:0]; 	
	
	reg [3:0] A1_R = A1;
	reg [3:0] A2_R = A2;
	reg []
	
	reg [3:0] RD1_R;
	reg [3:0] RD2_R;
	reg [3:0] RD3_R;
	
	always@(posedge CLK) begin
		
		RD1_R <= A1_R;
		RD2_R <= A2_R;
		
		
		assign RD1_R <= RD1;
		assign RD2_R <= RD2;
		assign RD3_R <= RD3;
	end
	
	always@(negedge CLK) begin
		if(R15 == A1_R)
			begin
				RD1_R <= R15;
			end
	end
	
endmodule
