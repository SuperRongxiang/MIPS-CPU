module FPU_demux_2_threading (dt,e1t,e2t,e3t,wt,stall_div_sqrt,e1w,e2w,e3w,ww,stall_div_sqrt0,e1w0,e2w0,e3w0,ww0,stall_div_sqrt1,e1w1,e2w1,e3w1,ww1);
    input dt,e1t,e2t,e3t,wt;
    input stall_div_sqrt,e1w,e2w,e3w,ww;
    output stall_div_sqrt0,e1w0,e2w0,e3w0,ww0,stall_div_sqrt1,e1w1,e2w1,e3w1,ww1;

    assign stall_div_sqrt1=dt&stall_div_sqrt;
    assign stall_div_sqrt0=~dt&stall_div_sqrt;
    assign e1w1=e1t&e1w;
    assign e1w0=~e1t&e1w;
    assign e2w1=e2t&e2w;
    assign e2w0=~e2t&e2w;
    assign e3w1=e3t&e3w;
    assign e3w0=~e3t&e3w;
    assign ww1=wt&ww;
    assign ww0=~wt&ww;
endmodule
