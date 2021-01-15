module dff5 (clk,rst_n,datain,dataout);
	input clk,rst_n;
	input [4:0] datain;
	output [4:0] dataout;
	
	reg [4:0] dataout;
	
	always @(posedge clk)
		if (!rst_n)	dataout<=5'b0;
		else	dataout<=datain;
endmodule
