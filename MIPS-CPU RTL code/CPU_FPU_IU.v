module CPU_FPU_IU   (clk,mem_clk,rst_n,pc,inst,ealu,malu,walu,wn,wd,ww,stall_lw,stall_fp,stall_lwc1,stall_swc1,stall_div_sqrt,
                    count_div,count_sqrt,e1n,e2n,e3n,e3d,e,fasmds,intr,inta,reg_a,reg_b,mmo,qfa,fa,dfa,dfb,fs,ft,fwdla,fwdlb,fwdfa,
                    fwdfb);
    input clk,mem_clk,rst_n;
    input intr;                                     //interuption request
    output [31:0] pc,inst;
    output [31:0] ealu,malu,walu;
    output [31:0] wd;                               //data write into fp reg
    output [4:0] e1n,e2n,e3n,wn;                    //fp reg number
    output ww;                                      //WB stage write fp reg enable
    output stall_lw,stall_fp,stall_lwc1,stall_swc1; //stall because of difference reasons
    output stall_div_sqrt;                          //fp div and sqrt stall
    output [4:0] count_div,count_sqrt;              //iteration counter
    output [31:0] e3d;                              //fp EXE3 stage result
    output e,fasmds;                                //for multithread
    output inta;                                    //interuption acknowledge

    output [31:0] reg_a,reg_b,mmo;
    output [31:0] qfa,fa,dfa,dfb;
    output [4:0] fs,ft;
    output fwdla,fwdlb,fwdfa,fwdfb;
    
    wire e1w,e2w,e3w,wf,wwfpr;
    wire fwdla,fwdlb,fwdfa,fwdfb;
    wire [2:0] fc;
    wire [4:0] fs,ft,wrn,fd;
    wire [31:0] dfb,wmo,mmo;
    IU integer_unit     (.e1n(e1n),.e2n(e2n),.e3n(e3n),.e1w(e1w),.e2w(e2w),.e3w(e3w),.stall_div_sqrt(stall_div_sqrt),.st(1'b0),
                        .dfb(dfb),.e3d(e3d),.clk(clk),.mem_clk(mem_clk),.rst_n(rst_n),.fs(fs),.ft(ft),.wmo(wmo),.wrn(wrn),.wwfpr(wwfpr),
                        .mmo(mmo),.fwdla(fwdla),.fwdlb(fwdlb),.fwdfa(fwdfa),.fwdfb(fwdfb),.fd(fd),.fc(fc),.wf(wf),.fasmds(fasmds),.pc(pc),
                        .inst(inst),.ealu(ealu),.malu(malu),.walu(walu),.stall_lw(stall_lw),.stall_fp(stall_fp),.stall_lwc1(stall_lwc1),
                        .stall_swc1(stall_swc1),.intr(intr),.inta(inta));

    wire [31:0] wd,dfa;
    wire [1:0] e1c,e2c,e3c;
    wire ww;
    FPU float_point_unit (.a(dfa),.b(dfb),.fc(fc),.wf(wf),.fd(fd),.ein(1'b1),.clk(clk),.rst_n(rst_n),.ed(e3d),.wd(wd),.e1w(e1w),.e2w(e2w),.e3w(e3w),
                        .ww(ww),.e1n(e1n),.e2n(e2n),.e3n(e3n),.wn(wn),.stall(stall_div_sqrt),.e(e),.e1c(e1c),.e2c(e2c),.e3c(e3c),
                        .count_div(count_div),.count_sqrt(count_sqrt),.reg_a(reg_a),.reg_b(reg_b));

    wire [31:0] qfa,qfb;
    float_regfile float_point_register  (.rna(fs),.rnb(ft),.wex(ww),.wey(wwfpr),.wnx(wn),.wny(wrn),.dx(wd),.dy(wmo),.qa(qfa),.qb(qfb),
                                        .clk(~clk),.rst_n(rst_n));

    //forward the mmo
    wire [31:0] fa,fb;
    mux2x32 selfa (.data1(qfa),.data2(mmo),.sel(fwdla),.dataout(fa));
    mux2x32 selfb (.data1(qfb),.data2(mmo),.sel(fwdlb),.dataout(fb));
    //forward the e3d
    mux2x32 seldfa (.data1(fa),.data2(e3d),.sel(fwdfa),.dataout(dfa));
    mux2x32 seldfb (.data1(fb),.data2(e3d),.sel(fwdfb),.dataout(dfb));
endmodule
