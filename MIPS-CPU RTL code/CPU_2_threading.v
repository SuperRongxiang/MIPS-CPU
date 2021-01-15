module CPU_FPU_IU_2_thread   (clk,mem_clk,rst_n,
                    pc0,inst0,ealu0,malu0,walu0,intr0,inta0,fasmds0,ww0,stall_lw0,stall_fp0,stall_lwc10,stall_swc10,stall_div_sqrt0,st0,
                    pc1,inst1,ealu1,malu1,walu1,intr1,inta1,fasmds1,ww1,stall_lw1,stall_fp1,stall_lwc11,stall_swc11,stall_div_sqrt1,st1,
                    count_div,count_sqrt,e1n,e2n,e3n,e3d,e,wn,wd,
                    dt,count,wf0,wf1,wf,e1w,e2w,e3w,e1w0);
    input clk,mem_clk,rst_n;

    output [4:0] count_div,count_sqrt;              //iteration counter
    output [31:0] e3d;                              //fp EXE3 stage result
    output e;
    output [31:0] wd;                               //data write into fp reg
    output [4:0] e1n,e2n,e3n,wn;                    //fp reg number

    input intr0;                                     //interuption request
    output [31:0] pc0,inst0;
    output [31:0] ealu0,malu0,walu0;
    output ww0;                                      //WB stage write fp reg enable
    output stall_lw0,stall_fp0,stall_lwc10,stall_swc10; //stall because of difference reasons
    output stall_div_sqrt0;                          //fp div and sqrt stall
    output fasmds0; 
    output inta0;                                    //interuption acknowledge
    output st0;

    input intr1;                                     //interuption request
    output [31:0] pc1,inst1;
    output [31:0] ealu1,malu1,walu1;
    output ww1; 
    output stall_lw1,stall_fp1,stall_lwc11,stall_swc11; //stall because of difference reasons
    output stall_div_sqrt1;                          //fp div and sqrt stall
    output fasmds1; 
    output inta1;                                    //interuption acknowledge
    output st1;

    output dt,count,wf0,wf1,wf,e1w,e2w,e3w,e1w0;

    wire [4:0] e1n0,e2n0,e3n0,e1n1,e2n1,e3n1;
    wire [31:0] qfa0,qfb0,dfa0,dfb0,fa0,fb0;
    wire [31:0] qfa1,qfb1,dfa1,dfb1,fa1,fb1;

    wire dt,e1t,e2t,e3t,wt,st0,st1;
    wire e1w0,e2w0,e3w0,wf0,wwfpr0;
    wire fwdla0,fwdlb0,fwdfa0,fwdfb0;
    wire [2:0] fc0;
    wire [4:0] fs0,ft0,wrn0,fd0;
    wire [31:0] wmo0,mmo0;
    IU integer_unit_0   (.e1n(e1n),.e2n(e2n),.e3n(e3n),.e1w(e1w0),.e2w(e2w0),.e3w(e3w0),.stall_div_sqrt(stall_div_sqrt0),.st(st0),
                        .dfb(dfb0),.e3d(e3d),.clk(clk),.mem_clk(mem_clk),.rst_n(rst_n),.fs(fs0),.ft(ft0),.wmo(wmo0),.wrn(wrn0),.wwfpr(wwfpr0),
                        .mmo(mmo0),.fwdla(fwdla0),.fwdlb(fwdlb0),.fwdfa(fwdfa0),.fwdfb(fwdfb0),.fd(fd0),.fc(fc0),.wf(wf0),.fasmds(fasmds0),.pc(pc0),
                        .inst(inst0),.ealu(ealu0),.malu(malu0),.walu(walu0),.stall_lw(stall_lw0),.stall_fp(stall_fp0),.stall_lwc1(stall_lwc10),
                        .stall_swc1(stall_swc10),.intr(intr0),.inta(inta0));

    wire e1w1,e2w1,e3w1,wf1,wwfpr1;
    wire fwdla1,fwdlb1,fwdfa1,fwdfb1;
    wire [2:0] fc1;
    wire [4:0] fs1,ft1,wrn1,fd1;
    wire [31:0] wmo1,mmo1;
    IU integer_unit_1   (.e1n(e1n),.e2n(e2n),.e3n(e3n),.e1w(e1w1),.e2w(e2w1),.e3w(e3w1),.stall_div_sqrt(stall_div_sqrt1),.st(st1),
                        .dfb(dfb1),.e3d(e3d),.clk(clk),.mem_clk(mem_clk),.rst_n(rst_n),.fs(fs1),.ft(ft1),.wmo(wmo1),.wrn(wrn1),.wwfpr(wwfpr1),
                        .mmo(mmo1),.fwdla(fwdla1),.fwdlb(fwdlb1),.fwdfa(fwdfa1),.fwdfb(fwdfb1),.fd(fd1),.fc(fc1),.wf(wf1),.fasmds(fasmds1),.pc(pc1),
                        .inst(inst1),.ealu(ealu1),.malu(malu1),.walu(walu1),.stall_lw(stall_lw1),.stall_fp(stall_fp1),.stall_lwc1(stall_lwc11),
                        .stall_swc1(stall_swc11),.intr(intr1),.inta(inta1));

    selthreading_2_threading selthread  (.clk(clk),.rst_n(rst_n),.en(e),.fasmds0(fasmds0),.fasmds1(fasmds1),.dt(dt),.e1t(e1t),.e2t(e2t),
                                        .e3t(e3t),.wt(wt),.st0(st0),.st1(st1),.count(count));

    //forward the mmo
    mux2x32 selfa0 (.data1(qfa0),.data2(mmo0),.sel(fwdla0),.dataout(fa0));
    mux2x32 selfb0 (.data1(qfb0),.data2(mmo0),.sel(fwdlb0),.dataout(fb0));
    //forward the e3d
    mux2x32 seldfa0 (.data1(fa0),.data2(e3d),.sel(fwdfa0),.dataout(dfa0));
    mux2x32 seldfb0 (.data1(fb0),.data2(e3d),.sel(fwdfb0),.dataout(dfb0));

    //forward the mmo
    mux2x32 selfa1 (.data1(qfa1),.data2(mmo1),.sel(fwdla1),.dataout(fa1));
    mux2x32 selfb1 (.data1(qfb1),.data2(mmo1),.sel(fwdlb1),.dataout(fb1));
    //forward the e3d
    mux2x32 seldfa1 (.data1(fa1),.data2(e3d),.sel(fwdfa1),.dataout(dfa1));
    mux2x32 seldfb1 (.data1(fb1),.data2(e3d),.sel(fwdfb1),.dataout(dfb1));
    
    wire [31:0] wd,dfa,dfb;
    wire [4:0] fd;
    wire wf;
    wire [2:0] fc;
    FPU_mux_2_threading premux  (.s(dt),.fd0(fd0),.fc0(fc0),.wf0(wf0),.dfa0(dfa0),.dfb0(dfb0),.fd1(fd1),.fc1(fc1),.wf1(wf1),.dfa1(dfa1),
                                .dfb1(dfb1),.fd(fd),.fc(fc),.wf(wf),.dfa(dfa),.dfb(dfb));

    float_regfile float_point_register_0  (.rna(fs0),.rnb(ft0),.wex(ww0),.wey(wwfpr0),.wnx(wn),.wny(wrn0),.dx(wd),.dy(wmo0),.qa(qfa0),.qb(qfb0),
                                        .clk(~clk),.rst_n(rst_n));

    float_regfile float_point_register_1  (.rna(fs1),.rnb(ft1),.wex(ww1),.wey(wwfpr1),.wnx(wn),.wny(wrn1),.dx(wd),.dy(wmo1),.qa(qfa1),.qb(qfb1),
                                        .clk(~clk),.rst_n(rst_n));


    wire [1:0] e1c,e2c,e3c;
    wire ww;
    FPU float_point_unit (.a(dfa),.b(dfb),.fc(fc),.wf(wf),.fd(fd),.ein(1'b1),.clk(clk),.rst_n(rst_n),.ed(e3d),.wd(wd),.e1w(e1w),.e2w(e2w),.e3w(e3w),
                        .ww(ww),.e1n(e1n),.e2n(e2n),.e3n(e3n),.wn(wn),.stall(stall_div_sqrt),.e(e),.e1c(e1c),.e2c(e2c),.e3c(e3c),
                        .count_div(count_div),.count_sqrt(count_sqrt));

    FPU_demux_2_threading demux (.dt(dt),.e1t(e1t),.e2t(e2t),.e3t(e3t),.wt(wt),.stall_div_sqrt(stall_div_sqrt),.e1w(e1w),.e2w(e2w),
                                .e3w(e3w),.ww(ww),.stall_div_sqrt0(stall_div_sqrt0),.e1w0(e1w0),.e2w0(e2w0),.e3w0(e3w0),.ww0(ww0),
                                .stall_div_sqrt1(stall_div_sqrt1),.e1w1(e1w1),.e2w1(e2w1),.e3w1(e3w1),.ww1(ww1));
endmodule

