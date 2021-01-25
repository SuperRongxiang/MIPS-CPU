module mux4x32(data1,data2,data3,data4,sel,dataout);
	input [31:0] data1,data2,data3,data4;
	input [1:0] sel;
	output [31:0] dataout;
	
	assign dataout=(data1&{32{!sel[0]&!sel[1]}})
			|(data2&{32{sel[0]&!sel[1]}})
			|(data3&{32{!sel[0]&sel[1]}})
			|(data4&{32{sel[0]&sel[1]}});
endmodule

	