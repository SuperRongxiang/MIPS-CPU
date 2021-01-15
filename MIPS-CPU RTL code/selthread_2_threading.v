module selthreading_2_threading (clk,rst_n,en,fasmds0,fasmds1,dt,e1t,e2t,e3t,wt,st0,st1,count);
    input clk,rst_n,en;
    input fasmds0,fasmds1;
    output dt,e1t,e2t,e3t,wt,st0,st1;

    output count;

    wire count;
    dffe1 counter (.clk(clk),.rst_n(rst_n),.en(en),.datain(~count),.dataout(count));

    assign dt=~fasmds0&fasmds1|count&fasmds1;
    assign st0=count&fasmds0&fasmds1;
    assign st1=~count&fasmds0&fasmds1;

    dffe1 trdt (.clk(clk),.rst_n(rst_n),.en(en),.datain(dt),.dataout(e1t));
    dffe1 tre1t (.clk(clk),.rst_n(rst_n),.en(en),.datain(e1t),.dataout(e2t));
    dffe1 tre2t (.clk(clk),.rst_n(rst_n),.en(en),.datain(e2t),.dataout(e3t));
    dffe1 tre3t (.clk(clk),.rst_n(rst_n),.en(en),.datain(e3t),.dataout(wt));
endmodule
