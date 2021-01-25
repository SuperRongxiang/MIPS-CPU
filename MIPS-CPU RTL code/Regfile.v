module regfile(rna,rnb,wn,datain,we,clk,clr_n,qa,qb);
	input [4:0] rna,rnb,wn;	//read a,b;write
	input [31:0] datain;	//data input
	input we,clk,clr_n;	//write enable;clock;clear_n
	output [31:0] qa,qb;	//data output a;data output b
	
	reg [31:0] register [1:31];	//31*32-bit regs

	integer i;
	// 2 readd ports
	assign qa={32{|rna}}&register[rna];
	assign qb={32{|rnb}}&register[rnb];
	assign qwn=register[wn];

	// 1 write port
	always@(posedge clk or negedge clr_n)
		if(!clr_n) begin
			for(i=1;i<32;i=i+1)
				register[i]<=32'b0;
			end
		else if((wn!=0)&&we)
			register[wn]<=datain;
endmodule