module RegisterFile(
	RD1, RD2, RD3,
	CLK, WE3, RA1, RA2, RA3, WD3, R15
	);
	
	input CLK;
	input [31:0] WE3;
	input [3:0] RA1;
	input [3:0] RA2;
	input [3:0] RA3;
	input [31:0] WD3;
	input [31:0] R15;
	
	output [31:0] RD1;
	output [31:0] RD2;
	output [31:0] RD3;
	
	reg [31:0] register[15:0]; 	
	
	reg [31:0] A1;
	reg [31:0] A2;
	reg [31:0] A3;
	
	reg [3:0] RD1_R;
	reg [3:0] RD2_R;
	reg [3:0] RD3_R;
	
	always@(posedge CLK) begin
		
		
	end
	
	always@(negedge CLK) begin
		register[A3_R] <= WD3;
	end
	
endmodule
