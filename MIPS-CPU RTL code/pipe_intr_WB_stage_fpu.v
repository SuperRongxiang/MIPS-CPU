module pipe_intr_WB_stage_fpu (wwreg,wm2reg,walu,wmo,wdi);
	input wwreg,wm2reg;
	input [31:0] wmo,walu;
	output [31:0] wdi;
	
	mux2x32 sel_wdi (.data1(walu),.data2(wmo),.sel(wm2reg),.dataout(wdi));
	
endmodule
