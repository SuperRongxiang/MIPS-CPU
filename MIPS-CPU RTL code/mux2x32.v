module mux2x32(data1,data2,sel,dataout);
	input [31:0] data1,data2;
	input sel;
	output [31:0] dataout;

	assign dataout=(data1&{32{!sel}})
			|(data2&{32{sel}});
endmodule