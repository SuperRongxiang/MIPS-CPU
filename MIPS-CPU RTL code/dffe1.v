
module dffe1 (clk,rst_n,en,datain,dataout);
	input clk,datain,rst_n,en;
	output dataout;
	
	reg dataout;
	
	always @(posedge clk)
		if (!rst_n)	dataout<=1'b0;
		else if (en)	dataout<=datain;
endmodule
