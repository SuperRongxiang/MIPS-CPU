module pipe_intr_ALU(a,b,aluc,r,z,v);
	input [31:0] a,b;	//operand
	input [3:0] aluc;	//function
	output [31:0] r;	//result
	output z;		//flag bit
	output v;		//overflow

	wire [31:0] ab_and,ab_or,ab_xor,ab_lui,ab_and_or,ab_xor_lui,addsub_result,shift_result;

	assign ab_and=a&b;
	assign ab_or=a|b;
	assign ab_xor=a^b;
	assign ab_lui={b[15:0],16'b0};

	assign ab_and_or=aluc[2]?ab_or:ab_and;
	assign ab_xor_lui=aluc[2]?ab_lui:ab_xor;
	
	addsub32 addsuber1(.a(a),.b(b),.sub(aluc[2]),.r(addsub_result));
	shifter shifter1(.d(b),.sa(a[10:6]),.right(aluc[2]),.arith(aluc[3]),.sh(shift_result));
	mux4x32 MUX1(.data1(addsub_result),.data2(ab_and_or),.data3(ab_xor_lui),.data4(shift_result),.dataout(r),.sel(aluc[1:0]));
	
	assign z=~|r;
	assign v=~aluc[2]&~a[31]&~b[31]&r[31]&~aluc[1]&~aluc[0]|~aluc[2]&a[31]&b[31]&~r[31]&~aluc[1]&~aluc[0]|
		aluc[2]&~a[31]&b[31]&r[31]&~aluc[1]&~aluc[0]|aluc[2]&a[31]&~b[31]&~r[31]&~aluc[1]&~aluc[0];
endmodule
