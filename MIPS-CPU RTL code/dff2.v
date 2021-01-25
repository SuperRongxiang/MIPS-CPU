module dff2 (clk,rst_n,datain,dataout);
	input clk,rst_n;
	input [1:0] datain;
	output [1:0] dataout;
	
	reg [1:0] dataout;
	
	always @(posedge clk)
		if (!rst_n)	dataout<=2'b0;
		else	dataout<=datain;
endmodule
