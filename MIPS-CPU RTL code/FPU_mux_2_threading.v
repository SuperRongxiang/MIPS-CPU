module FPU_mux_2_threading (s,fd0,fc0,wf0,dfa0,dfb0,fd1,fc1,wf1,dfa1,dfb1,fd,fc,wf,dfa,dfb);
    input s;
    input wf0,wf1;
    input [4:0] fd0,fd1;
    input [2:0] fc0,fc1;
    input [31:0] dfa0,dfa1,dfb0,dfb1;
    output wf;
    output [4:0] fd;
    output [2:0] fc;
    output [31:0] dfa,dfb;

    mux2x32 seldfa (.data1(dfa0),.data2(dfa1),.sel(s),.dataout(dfa));
    mux2x32 seldfb (.data1(dfb0),.data2(dfb1),.sel(s),.dataout(dfb));
    mux2x5 selfd (.data1(fd0),.data2(fd1),.sel(s),.dataout(fd));

    //select fc
    assign fc=s?fc1:fc0;
    assign wf=s?wf1:wf0;
endmodule




