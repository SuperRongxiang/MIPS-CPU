module IU   (e1n,e2n,e3n,e1w,e2w,e3w,stall_div_sqrt,st,dfb,e3d,clk,mem_clk,rst_n,fs,ft,wmo,wrn,wwfpr,mmo,fwdla,fwdlb,fwdfa,fwdfb,fd,fc,wf,fasmds,pc,
            inst,ealu,malu,walu,stall_lw,stall_fp,stall_lwc1,stall_swc1,intr,inta);
    input [31:0] dfb,e3d;       
    input [4:0] e1n,e2n,e3n;
    input e1w,e2w,e3w,stall_div_sqrt,st,clk,mem_clk,rst_n,intr;
    output [31:0] pc,inst,ealu,malu,walu;
    output [31:0] mmo,wmo;
    output [4:0] fs,ft,fd,wrn;
    output [2:0] fc;
    output wwfpr,fwdla,fwdlb,fwdfa,fwdfb,wf,fasmds,inta;
    output stall_lw,stall_fp,stall_lwc1,stall_swc1;

	//---------------------------------------//
	wire [31:0] next_pc,bpc,jpc,da,int_inst,inst,pc4,epc;
	wire [1:0] pcsource,selpc;
	wire wpcir;
	pipe_intr_PC_reg PC_reg	(.clk(clk),.rst_n(rst_n),.wpcir(wpcir),.PC_in(next_pc),.PC_out(pc));
	pipe_intr_IF_stage_fpu IF_stage 	(.pc(pc),.bpc(bpc),.da(da),.jpc(jpc),.epc(epc),.selpc(selpc),.pcsource(pcsource),.inst(int_inst),.pc4(pc4),.next_pc(next_pc));

	//--------------------------------------//
	wire [31:0] id_pc4,id_inst,wdi,ealu,malu,mmo,id2reg_pc4,db,imm,pcd,pce,pcm,sta_in,cau_in,epc_in,sta;
	wire [4:0] wrn,mrn,drn,ern;
	wire [3:0] aluc;
	wire [1:0] mfc0;
	wire wwreg,em2reg,ewreg,mm2reg,mwreg,wreg,m2reg,wmem,jal,shift,aluimm,isbr,misbr,eisbr,ecancel,earith,arith,cancel,wsta,wcau,wepc,ov;
	wire fwdfe,wfpr,efwdfe,ewfpr;
	pipe_intr_IR_reg IR_reg 	(.inst_in(int_inst),.pc4_in(pc4),.clk(clk),.rst_n(rst_n),.wpcir(wpcir),.pc4_out(id_pc4),.inst_out(inst),.pc(pc),.pcd(pcd));
	pipe_intr_ID_stage_fpu ID_stage 	(.clk(clk),.rst_n(rst_n),.inst(inst),.pc4_in(id_pc4),.wdi(wdi),.wrn(wrn),.ealu(ealu),.malu(malu),.mmo(mmo),
							.wwreg(wwreg),.ern(ern),.em2reg(em2reg),.ewreg(ewreg),.mrn(mrn),.mm2reg(mm2reg),.mwreg(mwreg),.wreg(wreg),.m2reg(m2reg),
							.wmem(wmem),.jal(jal),.aluc(aluc),.aluimm(aluimm),.shift(shift),.pc4_out(id2reg_pc4),.da(da),.dd(db),.ext_imm(imm),
							.drn(drn),.wpcir(wpcir),.pcsource(pcsource),.jpc(jpc),.bpc(bpc),.intr(intr),.inta(inta),.isbr(isbr),.misbr(misbr),
							.eisbr(eisbr),.ecancel(ecancel),.earith(earith),.arith(arith),.cancel(cancel),.mfc0(mfc0),.wsta(wsta),.wcau(wcau),
							.wepc(wepc),.pc(pc),.pcd(pcd),.pce(pce),.pcm(pcm),.sta_in(sta_in),.cau_in(cau_in),.epc_in(epc_in),.sta(sta),.ov(ov),
							.selpc(selpc),.e1n(e1n),.e2n(e2n),.e3n(e3n),.e1w(e1w),.e2w(e2w),.e3w(e3w),.stall_div_sqrt(stall_div_sqrt),
							.fwdla(fwdla),.fwdlb(fwdlb),.fwdfa(fwdfa),.fwdfb(fwdfb),.fc(fc),.fwdfe(fwdfe),.wfpr(wfpr),.wf(wf),.fasmds(fasmds),
							.stall_lw(stall_lw),.stall_fp(stall_fp),.stall_lwc1(stall_lwc1),.stall_swc1(stall_swc1),.st(st),.dfb(dfb),.e3d(e3d),
							.ewfpr(ewfpr),.mwfpr(mwfpr),.fs(fs),.ft(ft),.fd(fd));

	//--------------------------------------//
	wire ewmem,ealuimm,eshift,ejal,ewreg0;
	wire [1:0] emfc0;
	wire [31:0] epc4,eda,edb,eimm,cau;
	wire [4:0] ern0;
	wire [3:0] ealuc;
	wire [31:0] eb;
	pipe_intr_d2e_reg_fpu id2e_reg (.clk(clk),.rst_n(rst_n),.wreg(wreg),.m2reg(m2reg),.wmem(wmem),.jal(jal),.aluc(aluc),.aluimm(aluimm),.shift(shift),
								.pc4(id2reg_pc4),.da(da),.db(db),.imm(imm),.drn(drn),.ewreg0(ewreg0),.em2reg(em2reg),.ewmem(ewmem),.ejal(ejal),
								.ealuc(ealuc),.ealuimm(ealuimm),.eshift(eshift),.epc4(epc4),.eda(eda),.edb(edb),.eimm(eimm),.ern0(ern0),.arith(arith),
								.cancel(cancel),.isbr(isbr),.mfc0(mfc0),.wsta(wsta),.wcau(wcau),.wepc(wepc),.sta_in(sta_in),.cau_in(cau_in),
								.epc_in(epc_in),.earith(earith),.ecancel(ecancel),.eisbr(eisbr),.emfc0(emfc0),.sta(sta),.cau(cau),.epc(epc),.pce(pce),
								.pcd(pcd),.fwdfe(fwdfe),.wfpr(wfpr),.efwdfe(efwdfe),.ewfpr(ewfpr));
	pipe_intr_EXE_stage_fpu EXE_stage 	(.ewreg0(ewreg0),.ewreg(ewreg),.em2reg(em2reg),.ewmem(ewmem),.ejal(ejal),.ealuc(ealuc),.ealuimm(ealuimm),.eshift(eshift),
									.epc4(epc4),.eda(eda),.edb(edb),.eimm(eimm),.ern0(ern0),.ealu(ealu),.ern1(ern),.earith(earith),.emfc0(emfc0),.sta(sta),
									.cau(cau),.epc(epc),.ov(ov),.e3d(e3d),.efwdfe(efwdfe),.eb(eb));
	//--------------------------------------//
	wire mwmem;
	wire [31:0] mdb;
	pipe_intr_e2m_reg_fpu e2mstage	(.clk(clk),.rst_n(rst_n),.ewreg(ewreg),.em2reg(em2reg),.ewmem(ewmem),.ealu(ealu),.eb(eb),.ern1(ern),.mwreg(mwreg),
								.mm2reg(mm2reg),.mwmem(mwmem),.mdb(mdb),.mrn(mrn),.malu(malu),.eisbr(eisbr),.misbr(misbr),.pce(pce),.pcm(pcm),
								.ewfpr(ewfpr),.mwfpr(mwfpr));
	pipe_intr_MEM_stage_fpu MEM_stage (.mem_clk(mem_clk),.mwreg(mwreg),.mm2reg(mm2reg),.mwmem(mwmem),.mdb(mdb),.mmo(mmo),.malu(malu));

	//--------------------------------------//
	wire wm2reg;
	wire [31:0] wmo,walu;
	wire wwfpr;
	pipe_intr_m2w_reg_fpu	m2w_reg	(.rst_n(rst_n),.clk(clk),.mwreg(mwreg),.mm2reg(mm2reg),.mmo(mmo),.malu(malu),.mrn(mrn),.wwreg(wwreg),
									.wm2reg(wm2reg),.wmo(wmo),.wrn(wrn),.walu(walu),.mwfpr(mwfpr),.wwfpr(wwfpr));
	pipe_intr_WB_stage_fpu WB_stage (.wwreg(wwreg),.wm2reg(wm2reg),.walu(walu),.wmo(wmo),.wdi(wdi));
endmodule