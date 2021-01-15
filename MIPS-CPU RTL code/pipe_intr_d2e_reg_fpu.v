module pipe_intr_d2e_reg_fpu   (clk,rst_n,wreg,m2reg,wmem,jal,aluc,aluimm,shift,pc4,da,db,imm,drn,ewreg0,em2reg,ewmem,ejal,ealuc,ealuimm,eshift,epc4,
                            eda,edb,eimm,ern0,arith,cancel,isbr,mfc0,wsta,wcau,wepc,sta_in,cau_in,epc_in,earith,ecancel,eisbr,emfc0,sta,cau,epc,
                            pce,pcd,fwdfe,wfpr,efwdfe,ewfpr);
	input wreg,m2reg,wmem,jal,aluimm,shift,arith,cancel,isbr,wsta,wcau,wepc;
	input clk,rst_n;
 	input [31:0] pc4,da,db,imm,sta_in,cau_in,epc_in,pcd;
	input [4:0] drn;
	input [3:0] aluc;
	input [1:0] mfc0;
    input fwdfe,wfpr;
	output ewreg0,em2reg,ewmem,ejal,ealuimm,eshift,earith,ecancel,eisbr;
	output [31:0] epc4,eda,edb,eimm,pce,sta,cau,epc;
	output [4:0] ern0;
	output [3:0] ealuc;
	output [1:0] emfc0;
    output efwdfe,ewfpr;


    dff1 trfwdfe (.clk(clk),.rst_n(rst_n),.datain(fwdfe),.dataout(efwdfe));
    dff1 trwfpr (.clk(clk),.rst_n(rst_n),.datain(wfpr),.dataout(ewfpr));
	dff1 trwreg (.clk(clk),.rst_n(rst_n),.datain(wreg),.dataout(ewreg0));
	dff1 trm2reg (.clk(clk),.rst_n(rst_n),.datain(m2reg),.dataout(em2reg));
	dff1 trwmem (.clk(clk),.rst_n(rst_n),.datain(wmem),.dataout(ewmem));
	dff1 trjal (.clk(clk),.rst_n(rst_n),.datain(jal),.dataout(ejal));
	dff4 traluc (.clk(clk),.rst_n(rst_n),.datain(aluc),.dataout(ealuc));
	dff1 traluimm (.clk(clk),.rst_n(rst_n),.datain(aluimm),.dataout(ealuimm));
	dff1 trshift (.clk(clk),.rst_n(rst_n),.datain(shift),.dataout(eshift));
	dff32 trpc4 (.d(pc4),.clk(clk),.rst_n(rst_n),.q(epc4));
	dff32 trda (.d(da),.clk(clk),.rst_n(rst_n),.q(eda));
	dff32 trdb (.d(db),.clk(clk),.rst_n(rst_n),.q(edb));
	dff32 trimm (.d(imm),.clk(clk),.rst_n(rst_n),.q(eimm));
	dff5 trdrn (.clk(clk),.rst_n(rst_n),.datain(drn),.dataout(ern0));
    dff1 trarith (.clk(clk),.rst_n(rst_n),.datain(arith),.dataout(earith));
    dff1 trcancel (.clk(clk),.rst_n(rst_n),.datain(cancel),.dataout(ecancel));
    dff1 trisbr (.clk(clk),.rst_n(rst_n),.datain(isbr),.dataout(eisbr));
    dff2 trmfc0 (.clk(clk),.rst_n(rst_n),.datain(mfc0),.dataout(emfc0));
    dffe32 sta_reg (.d(sta_in),.clk(clk),.rst_n(rst_n),.en(wsta),.q(sta));
    dffe32 cau_reg (.d(cau_in),.clk(clk),.rst_n(rst_n),.en(wcau),.q(cau));
    dffe32 epc_reg (.d(epc_in),.clk(clk),.rst_n(rst_n),.en(wepc),.q(epc));
    dff32 trpc (.d(pcd),.clk(clk),.rst_n(rst_n),.q(pce));
endmodule

	

