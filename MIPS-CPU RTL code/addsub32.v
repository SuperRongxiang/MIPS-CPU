module addsub32(a,b,sub,r);
	input [31:0] a,b;
	input sub;
	output [31:0] r;
	
	wire [31:0] bin;
	wire [2:0] cmid;

	assign bin=b^{32{sub}};
	
	Carry_lookahead_adder_8bit adder1(.a(a[7:0]),.b(bin[7:0]),.cin(sub),.sum(r[7:0]),.cout(cmid[0]));
	Carry_lookahead_adder_8bit adder2(.a(a[15:8]),.b(bin[15:8]),.cin(cmid[0]),.sum(r[15:8]),.cout(cmid[1]));
	Carry_lookahead_adder_8bit adder3(.a(a[23:16]),.b(bin[23:16]),.cin(cmid[1]),.sum(r[23:16]),.cout(cmid[2]));
	Carry_lookahead_adder_8bit adder4(.a(a[31:24]),.b(bin[31:24]),.cin(cmid[2]),.sum(r[31:24]),.cout());
endmodule
