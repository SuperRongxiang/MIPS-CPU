module FPU (a,b,fc,wf,fd,ein,clk,rst_n,ed,wd,e1w,e2w,e3w,ww,e1n,e2n,e3n,wn,stall,e,e1c,e2c,e3c,count_div,count_sqrt);
    input [31:0] a;
    input [31:0] b;         //32 bit fp numbers
    input [2:0] fc;         //000:add 001:sub 01x:mul 10x:div 11x:sqrt
    input wf;               //write fp regfile
    input [4:0] fd;         //fp destination reg number
    input ein;              //enable input
    input clk;
    input rst_n;
    output [31:0] ed;       //e3 stage result
    output [31:0] wd;       //WB stage result
    output e1w;             
    output e2w;
    output e3w;
    output ww;              //write fp regfile
    output [4:0] e1n;
    output [4:0] e2n;
    output [4:0] e3n;
    output [4:0] wn;        //reg numbers
    output stall;           //stall signal
    output e;               //internal enable
    output [1:0] e1c;
    output [1:0] e2c;
    output [1:0] e3c;       //for testing
    output [4:0] count_div; //for testing
    output [4:0] count_sqrt; //for testing

    reg sub;
    reg [31:0] reg_a,reg_b;
    reg [1:0] e1c,e2c,e3c;
    reg e1w,e2w,e3w,ww;
    reg [4:0] e1n,e2n,e3n,wn;
    reg [31:0] wd;

    wire fdiv_stall,fsqrt_stall;
    wire stall=fdiv_stall|fsqrt_stall;
    wire e=~stall&ein;
    wire fdiv=fc[2]&~fc[1];
    wire fsqrt=fc[2]&fc[1];


    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sub<=1'b0;
            reg_a<=32'b0;   reg_b<=32'b0;
            e1c<=2'b0;      e2c<=2'b0;      e3c<=2'b0;
            e1w<=1'b0;      e2w<=1'b0;      e3w<=1'b0;      ww<=1'b0;
            e1n<=5'b0;      e2n<=5'b0;      e3n<=5'b0;      wn<=5'b0;
            wd<=32'b0;
        end
        else if (e) begin
            sub<=fc[0];
            reg_a<=a;   reg_b<=b;
            e1c<=fc[2:1];   e2c<=e1c;           e3c<=e2c;
            e1w<=wf;        e2w<=e1w;       e3w<=e2w;      ww<=e3w;
            e1n<=fd;        e2n<=e1n;       e3n<=e2n;      wn<=e3n;
            wd<=ed;
        end
    end

    wire [31:0] fadd_result,fmul_result,fdiv_result,fsqrt_result;
    wire busy_fdiv,busy_fsqrt;
    wire [25:0] reg_x_div,reg_x_fsqrt; 
    float_adder_pipe fadd_unit  (.clk(clk),.rst_n(rst_n),.en(e),.a(reg_a),.b(reg_b),.sub(sub),.rm(2'b00),.s(fadd_result));
    float_mul_pipe fmul_unit    (.clk(clk),.rst_n(rst_n),.en(e),.a(reg_a),.b(reg_b),.rm(2'b00),.s(fmul_result));
    float_div fdiv_unit         (.a(a),.b(b),.rm(2'b00),.fdiv(fdiv),.en(e),.clk(clk),.rst_n(rst_n),.s(fdiv_result),.busy(busy_fdiv),
                                .stall(fdiv_stall),.count(count_div),.reg_x(reg_x_div));
    float_sqrt fsqrt_unit       (.d(a),.rm(2'b00),.fsqrt(fsqrt),.en(e),.clk(clk),.rst_n(rst_n),.s(fsqrt_result),.busy(busy_fsqrt),
                                .stall(fsqrt_stall),.count(count_sqrt),.reg_x(reg_x_fsqrt));

    mux4x32 sel_result (.data1(fadd_result),.data2(fmul_result),.data3(fdiv_result),.data4(fsqrt_result),.sel(e3c),.dataout(ed));

endmodule