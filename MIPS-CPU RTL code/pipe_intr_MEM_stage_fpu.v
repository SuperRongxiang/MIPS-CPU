module pipe_intr_MEM_stage_fpu (mem_clk,mwreg,mm2reg,mwmem,mdb,mmo,malu);
	input mwreg,mm2reg,mwmem,mem_clk;
	input [31:0] malu,mdb;
	output [31:0] mmo;
	
	pipe_intr_data_mem_fpu datamem (.mem_clk(mem_clk),.dataout(mmo),.datain(mdb),.addr(malu),.we(mwmem));
	
endmodule
