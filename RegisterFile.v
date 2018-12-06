module RegisterFile(
	RD1, RD2,
	CLK, A1, A2, A3, R15, WD3, WE3
	);
	
	input CLK;
	input [3:0] A1;
	input [3:0] A2;
	input [3:0] A3;
	input [31:0] R15;
	input [31:0] WD3;
	input WE3;
	
	output [31:0] RD1;
	output [31:0] RD2;
	
	reg [31:0] register[15:0];
	
	assign RD1 = (A1 == 4'b1111 ? R15 : register[A1]);
	assign RD2 = (A2 == 4'b1111 ? R15 : register[A2]);
	
	always@(negedge CLK) begin
		if(WE3)
			begin
				register[A3] <= WD3;
				
			end
	end
endmodule
