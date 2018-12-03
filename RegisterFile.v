module RegisterFile(
	RD1, RD2, RD3,
	CLK, WE3, RA1, RA2, RA3, WD3, R15
	);
	
	input CLK;
	input WE3;
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
	
	always@(posedge CLK) begin
		A1 <= register[RA1];
		A2 <= register[RA2];
		A3 <= register[RA3];
	end
	
	assign RD1 = A1;
	assign RD2 = A2;
	assign RD3 = A3;
	
	always@(negedge CLK) begin
		if(WE3 == 1'b1)
			begin
				register[A3] <= WD3;
			end
			
		register[15] <= R15;
	end
	
endmodule
