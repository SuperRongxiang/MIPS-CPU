module pipe_intr_e2m_reg_fpu (clk,rst_n,ewreg,em2reg,ewmem,ealu,eb,ern1,mwreg,mm2reg,mwmem,mdb,mrn,malu,eisbr,misbr,pce,pcm,ewfpr,mwfpr);
	input clk,rst_n;
	input ewreg,em2reg,ewmem,eisbr;
	input [31:0] ealu,eb,pce;
	input [4:0] ern1;
    input ewfpr;
	output [31:0] malu,mdb,pcm;
	output mwreg,mm2reg,mwmem,misbr;
	output [4:0] mrn;
    output mwfpr;

    dff1 trwfpr (.clk(clk),.rst_n(rst_n),.datain(ewfpr),.dataout(mwfpr));
    dff32 trpc (.clk(clk),.rst_n(rst_n),.d(pce),.q(pcm));  
    dff1 trisbr (.clk(clk),.rst_n(rst_n),.datain(eisbr),.dataout(misbr));
	dff1 trwreg (.clk(clk),.rst_n(rst_n),.datain(ewreg),.dataout(mwreg));
	dff1 trm2reg (.clk(clk),.rst_n(rst_n),.datain(em2reg),.dataout(mm2reg));
	dff1 trwmem (.clk(clk),.rst_n(rst_n),.datain(ewmem),.dataout(mwmem));
	dff32 tralu (.clk(clk),.rst_n(rst_n),.d(ealu),.q(malu));
	dff32 trdb (.clk(clk),.rst_n(rst_n),.d(eb),.q(mdb));
	dff5 trrn (.clk(clk),.rst_n(rst_n),.datain(ern1),.dataout(mrn));
endmodule

