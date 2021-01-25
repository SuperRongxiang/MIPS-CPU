module mux2x5(data1,data2,sel,dataout);
	input [4:0] data1,data2;
	input sel;
	output [4:0] dataout;

	assign dataout=(data1&{5{!sel}})
			|(data2&{5{sel}});
endmodule