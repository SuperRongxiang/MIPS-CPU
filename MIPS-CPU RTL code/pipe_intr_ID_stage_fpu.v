module pipe_intr_ID_stage_fpu   (clk,rst_n,inst,pc4_in,wdi,wrn,ealu,malu,mmo,wwreg,ern,em2reg,ewreg,mrn,mm2reg,mwreg,
		                    wreg,m2reg,wmem,jal,aluc,aluimm,shift,pc4_out,da,dd,ext_imm,drn,wpcir,pcsource,jpc,bpc,
                            intr,inta,isbr,misbr,eisbr,ecancel,earith,arith,cancel,mfc0,wsta,wcau,wepc,pc,pcd,pce,
                            pcm,sta_in,cau_in,epc_in,sta,ov,selpc,e1n,e2n,e3n,e1w,e2w,e3w,stall_div_sqrt,fwdla,fwdlb,
							fwdfa,fwdfb,fc,fwdfe,wfpr,wf,fasmds,stall_lw,stall_fp,stall_lwc1,stall_swc1,st,dfb,e3d,ewfpr,mwfpr,
							fs,ft,fd,
							pre_bjpc,pre_taken,ud_BTB,ud_pdt,pre_fch_wrong,real_bjpc);
	input clk,rst_n;
	input [31:0] inst,pc4_in,ealu,malu,mmo,pc,pcd,pce,pcm,wdi,sta;
	input mm2reg,mwreg,em2reg,ewreg,wwreg,intr,misbr,eisbr,ecancel,earith,ov;
	input [4:0] ern,mrn,wrn;
	output wreg,m2reg,wmem,jal,aluimm,shift,wpcir,inta,isbr,arith,cancel,wsta,wcau,wepc;
	output [31:0] pc4_out,da,dd,ext_imm,jpc,bpc,sta_in,cau_in,epc_in;
	output [3:0] aluc;
	output [4:0] drn;
	output [1:0] pcsource,selpc,mfc0;

	//input from IU (fp op related)
	input ewfpr,mwfpr;

	//input from fp reg
	input [31:0] dfb;

	//input from FPU (fp op related)
	input [31:0] e3d;
	input [4:0] e1n,e2n,e3n;
	input e1w,e2w,e3w;
	input stall_div_sqrt;

	//output (fp op related)
	output fwdla,fwdlb,fwdfa,fwdfb;
	output [2:0] fc;
	output [4:0] fs,ft,fd;
	output fwdfe,wfpr;
	output wf;
	output fasmds;
	output stall_lw,stall_fp,stall_lwc1,stall_swc1;

	//multithread related
	input st;

	//input(output) from(to) branch predictor
	input [31:0] pre_bjpc;
	input pre_taken;
	output ud_BTB,ud_pdt,pre_fch_wrong;
	output [31:0] real_bjpc;

	//instruction decode
	wire [5:0] op,func;
	wire [4:0] fs,ft,fd;
	wire [4:0] rs,rt,rd,sa;
	wire [15:0] imm;
	wire [25:0] address;
	
	assign op=inst[31:26];
	assign rs=inst[25:21];
	assign rt=inst[20:16];
	assign rd=inst[15:11];
	assign sa=inst[10:6];
	assign func=inst[5:0];
	assign imm=inst[15:0];
	assign address=inst[25:0];
	assign fs=inst[15:11];
	assign ft=inst[20:16];
	assign fd=inst[10:6];
	
	//control unit signals
	wire [1:0] fwda,fwdb;
	wire rsrtequ,regrt,sext;

	//registerfile signals
	wire [31:0] RF_qa,RF_qb;
	
	//formation of jpc and bpc
	wire [31:0] pc4=pc4_in;
	wire [31:0] offset={ext_imm[29:0],2'b00};
	assign jpc={pc4[31:28],address,2'b00};
	addsub32 form_bpc (.a(pc4),.b(offset),.sub(1'b0),.r(bpc));

	//comparison of predicted target pc and real target pc
	wire [31:0] real_bjpc;
	mux4x32 selnpc (.data1(pc4),.data2(bpc),.data3(da),.data4(jpc),.sel(pcsource),.dataout(real_bjpc));
	wire pre_bjpc_is_right=~|(real_bjpc^pre_bjpc);

	//extend imm
	imm_extend imm_extention(.imm(imm),.sel_ext(sext),.ext_imm(ext_imm));

	//selection of da and db
	wire [31:0] db;
	mux4x32 sel_of_da (.data1(RF_qa),.data2(ealu),.data3(malu),.data4(mmo),.sel(fwda),.dataout(da));
	mux4x32 sel_of_db (.data1(RF_qb),.data2(ealu),.data3(malu),.data4(mmo),.sel(fwdb),.dataout(db));	

	//selection of rn
	mux2x5 sel_of_rn (.data1(rd),.data2(rt),.sel(regrt),.dataout(drn));

    //selection of sta
    wire [31:0] sta_right,sta_left,sta,tar_sta;
    assign sta_left={sta[27:0],4'b0000};
    assign sta_right={4'b0000,sta[31:4]};
    mux2x32 sel_of_tsrget_sta (.data1(sta_right),.data2(sta_left),.sel(exc),.dataout(tar_sta));
    mux2x32 sel_of_sta (.data1(tar_sta),.data2(db),.sel(mtc0),.dataout(sta_in));

    //selection of cau
    wire [31:0] cause;
    mux2x32 sel_of_cau (.data1(cause),.data2(db),.sel(mtc0),.dataout(cau_in));

    //selection of epc
    wire [1:0] selepc;
    wire [31:0] tar_epc;
    mux4x32 sel_of_tar_epc (.data1(pc),.data2(pcd),.data3(pce),.data4(pcm),.sel(selepc),.dataout(tar_epc));
    mux2x32 sel_of_epc (.data1(tar_epc),.data2(db),.sel(mtc0),.dataout(epc_in));
    
	//comparison of da and db
	assign rsrtequ=~|(da^db);

	//registerfile
	regfile mainregfile(.rna(rs),.rnb(rt),.wn(wrn),.datain(wdi),.we(wwreg),.clk(~clk),.clr_n(rst_n),
			.qa(RF_qa),.qb(RF_qb));

	//fp forward
	wire swfp,fwdf;
	wire [31:0] dc;
	mux2x32 seldc (.data1(db),.data2(dfb),.sel(swfp),.dataout(dc));
	mux2x32 seldd (.data1(dc),.data2(e3d),.sel(fwdf),.dataout(dd));

	//msin controlunit
	pipe_intr_cu_fpu controlunit 	(.func(func),.op(op),.op1(rs),.rs(rs),.rt(rt),.rd(rd),.mrn(mrn),.mm2reg(mm2reg),.mwreg(mwreg),
									.ern(ern),.em2reg(em2reg),.ewreg(ewreg),.rsrtequ(rsrtequ),.pcsource(pcsource),.wpcir(wpcir),
									.wreg(wreg),.m2reg(m2reg),.wmem(wmem),.jal(jal),.aluc(aluc),.aluimm(aluimm),.shift(shift),
									.sext(sext),.regrt(regrt),.fwda(fwda),.fwdb(fwdb),.intr(intr),.inta(inta),.sta(sta),.ov(ov),
									.misbr(misbr),.eisbr(eisbr),.ecancel(ecancel),.earith(earith),.arith(arith),.cancel(cancel),
									.isbr(isbr),.mfc0(mfc0),.wsta(wsta),.wcau(wcau),.wepc(wepc),.mtc0(mtc0),.cause(cause),
									.selepc(selepc),.selpc(selpc),.exc(exc),.fs(fs),.ft(ft),.e1n(e1n),.e2n(e2n),.e3n(e3n),.ewfpr(ewfpr),
									.mwfpr(mwfpr),.e1w(e1w),.e2w(e2w),.e3w(e3w),.stall_div_sqrt(stall_div_sqrt),.st(st),.fwdla(fwdla),
									.fwdlb(fwdlb),.fwdfa(fwdfa),.fwdfb(fwdfb),.fc(fc),.swfp(swfp),.fwdf(fwdf),.fwdfe(fwdfe),.wfpr(wfpr),
									.wf(wf),.fasmds(fasmds),.stall_lw(stall_lw),.stall_fp(stall_fp),.stall_lwc1(stall_lwc1),
									.stall_swc1(stall_swc1),.pre_taken(pre_taken),.pre_bjpc_is_right(pre_bjpc_is_right),
									.pre_fch_wrong(pre_fch_wrong),.ud_BTB(ud_BTB),.ud_pdt(ud_pdt));
	
	//transfer the pc4
	assign pc4_out=pc4_in;
endmodule
