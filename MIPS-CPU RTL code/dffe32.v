module dffe32 (d,clk,rst_n,en,q);
	input clk,rst_n,en;
	input [31:0] d;
	output q;
	reg [31:0] q;
	
	always@(negedge rst_n or posedge clk)
		if (!rst_n) q<=32'h0000_0000;
		else if (en) q<=d;
endmodule
