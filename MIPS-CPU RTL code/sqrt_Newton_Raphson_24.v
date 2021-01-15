module sqrt_Newton_Raphson_24 (d,fsqrt,en,clk,rst_n,q,busy,count,reg_x,stall);
    input [23:0] d;
    input fsqrt;
    input en,clk,rst_n;
    output [31:0] q;
    output busy,stall;
    output [4:0] count;
    output [25:0] reg_x;
    
    reg [31:0] q;
    reg [23:0] reg_d;
    reg [25:0] reg_x;
    reg [4:0] count;
    reg busy;

    assign stall=fsqrt&(~|count)|busy;

    //implementation of xi+1=xi(3-xi2d)/2
    wire [51:0] x_2;
    wire [51:0] x2d;
    wire [51:0] x52;
    assign x_2=reg_x*reg_x;
    assign x2d=x_2[51:24]*reg_d;
    wire [25:0] b26=26'h300_0000-x2d[49:24];
    assign x52=reg_x*b26;

        wire [7:0] x0=rom(d[23:19]);
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count<=5'b0;
            busy<=1'b0;
            reg_x<=26'b0;
            reg_d<=24'b0;
        end
        else begin
            if (fsqrt&(count==0)) begin
                count<=5'b1;
                busy<=1'b1;
            end
            else begin
                if (count==5'h01) begin
                    reg_x<={2'b1,x0,16'b0};
                    reg_d<=d;
                end
                if (count!=0) count<=count+5'b1;
                if (count==5'h15) busy<=0;
                if (count==5'h16) count<=5'b0;
                if ((count==5'h08)||(count==5'h0f)||(count==5'h16)) reg_x<=x52[50:25];
            end
        end
    end 

    //pipeline multiplier (implementation of d*x3)
    wire [49:0] a_dx=reg_x*reg_d;
    reg [49:0] b_dx;
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            b_dx<=0;
            q<=32'b0;
        end
        else if (en) begin
            b_dx<=a_dx;
            q<={b_dx[47:17],|b_dx[16:0]};
        end
    end

     function [7:0] rom;
        input [4:0] b;
        case (b)
            5'h08   :   rom=8'hf0;
            5'h09   :   rom=8'hd5;
            5'h0a   :   rom=8'hbe;
            5'h0b   :   rom=8'hba;
            5'h0c   :   rom=8'h99;
            5'h0d   :   rom=8'h8a;
            5'h0e   :   rom=8'h7c;
            5'h0f   :   rom=8'h6f;
            5'h10   :   rom=8'h64;
            5'h11   :   rom=8'h5a;
            5'h12   :   rom=8'h50;
            5'h13   :   rom=8'h47;
            5'h14   :   rom=8'h3f;
            5'h15   :   rom=8'h38;
            5'h16   :   rom=8'h31;
            5'h17   :   rom=8'h2a;
            5'h18   :   rom=8'h24;
            5'h19   :   rom=8'h1e;
            5'h1a   :   rom=8'h19;
            5'h1b   :   rom=8'h14;
            5'h1c   :   rom=8'h0f;
            5'h1d   :   rom=8'h0a;
            5'h1e   :   rom=8'h06;
            5'h1f   :   rom=8'h02;
            default:    rom=8'hff;
        endcase
    endfunction
endmodule

