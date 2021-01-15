module dff1 (clk,rst_n,datain,dataout);
	input clk,datain,rst_n;
	output dataout;
	
	reg dataout;
	
	always @(posedge clk)
		if (!rst_n)	dataout<=1'b0;
		else	dataout<=datain;
endmodule
