module dff4 (clk,rst_n,datain,dataout);
	input clk,rst_n;
	input [3:0] datain;
	output [3:0] dataout;
	
	reg [3:0] dataout;
	
	always @(posedge clk)
		if (!rst_n)	dataout<=4'b0;
		else	dataout<=datain;
endmodule
