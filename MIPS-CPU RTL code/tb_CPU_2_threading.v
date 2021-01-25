module tb_CPU_2_threading;
    reg clk,mem_clk,rst_n;
    reg intr0,intr1;
    wire [31:0] pc0,inst0;
    wire [31:0] ealu0,malu0,walu0;
    wire [31:0] pc1,inst1;
    wire [31:0] ealu1,malu1,walu1;
    wire [4:0] wn;
    wire [31:0] wd;
    wire ww0;
    wire ww1;
    wire stall_lw0,stall_fp0,stall_lwc10,stall_swc10,stall_div_sqrt0;
    wire stall_lw1,stall_fp1,stall_lwc11,stall_swc11,stall_div_sqrt1;
    wire inta0,inta1;
    wire fasmds0,fasmds1;
    wire [4:0] count_div,count_sqrt;
    wire [4:0] e1n,e2n,e3n;
    wire [31:0] e3d;
    wire e;
    //wire fasmds;
    //wire inta;

    wire dt,count,wf0,wf1,wf,e1w,e2w,e3w,e1w0;
    wire st0,st1;

    initial begin
        clk<=1'b1;
        mem_clk<=1'b1;
        rst_n<=1'b0;
        intr0<=1'b0;
        intr1<=1'b0;
        #2 rst_n<=1'b1;
    end

    always #10 clk<=~clk;
    always #10 mem_clk<=~mem_clk;

    CPU_FPU_IU_2_thread CPU  (.clk(clk),.mem_clk(mem_clk),.rst_n(rst_n),
                    .pc0(pc0),.inst0(inst0),.ealu0(ealu0),.malu0(malu0),.walu0(walu0),.intr0(intr0),.inta0(inta0),.fasmds0(fasmds0),
                    .ww0(ww0),.stall_lw0(stall_lw0),.stall_fp0(stall_fp0),.stall_lwc10(stall_lwc10),.stall_swc10(stall_swc10),
                    .stall_div_sqrt0(stall_div_sqrt0),.st0(st0),

                    .pc1(pc1),.inst1(inst1),.ealu1(ealu1),.malu1(malu1),.walu1(walu1),.intr1(intr1),.inta1(inta1),.fasmds1(fasmds1),
                    .ww1(ww1),.stall_lw1(stall_lw1),.stall_fp1(stall_fp1),.stall_lwc11(stall_lwc11),.stall_swc11(stall_swc11),
                    .stall_div_sqrt1(stall_div_sqrt1),.st1(st1),

                    .count_div(count_div),.count_sqrt(count_sqrt),.e1n(e1n),.e2n(e2n),.e3n(e3n),.e3d(e3d),.e(e),.wn(wn),.wd(wd),
                    .dt(dt),.count(count),.wf0(wf0),.wf1(wf1),.wf(wf),.e1w(e1w),.e2w(e2w),.e3w(e3w),.e1w0(e1w0));
endmodule
