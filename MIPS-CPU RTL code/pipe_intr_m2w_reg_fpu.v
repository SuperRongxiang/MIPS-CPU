module pipe_intr_m2w_reg_fpu (clk,rst_n,mwreg,mm2reg,mmo,malu,mrn,wwreg,wm2reg,wmo,wrn,walu,mwfpr,wwfpr);
	input clk,rst_n;
	input mwreg,mm2reg;
	input [31:0] mmo,malu;
	input [4:0] mrn;
    input mwfpr;
	output wwreg,wm2reg;
	output [31:0] wmo,walu;
	output [4:0] wrn;
    output wwfpr;

	dff1 trwfpr (.clk(clk),.rst_n(rst_n),.datain(mwfpr),.dataout(wwfpr));
	dff1 trwreg (.clk(clk),.rst_n(rst_n),.datain(mwreg),.dataout(wwreg));
	dff1 trm2reg (.clk(clk),.rst_n(rst_n),.datain(mm2reg),.dataout(wm2reg));
	dff32 trmmo (.clk(clk),.rst_n(rst_n),.d(mmo),.q(wmo));
	dff32 tralu (.clk(clk),.rst_n(rst_n),.d(malu),.q(walu));
	dff5 trrn (.clk(clk),.rst_n(rst_n),.datain(mrn),.dataout(wrn));
endmodule

