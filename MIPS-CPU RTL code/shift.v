module shifter (d,sa,right,arith,sh);
	input [31:0] 	d;
	input [4:0] 	sa;
	input 		right,arith;
	output [31:0] 	sh;
	reg [31:0] 	sh;
	always@ (*) begin
		if(!right) sh=d<<sa;
		else if (!arith) sh=d>>sa;
		else sh=$signed(d)>>>sa;
	end
endmodule