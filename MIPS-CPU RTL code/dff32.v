module dff32 (d,clk,rst_n,q);
	input clk,rst_n;
	input [31:0] d;
	output q;
	reg [31:0] q;
	
	always@(negedge rst_n or posedge clk)
		if (!rst_n) q<=32'h0000_0000;
		else q<=d;
endmodule
