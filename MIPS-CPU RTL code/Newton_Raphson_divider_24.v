module Newton_Raphson_divider_24 (a,b,fdiv,en,clk,rst_n,q,busy,reg_x,count,stall);
    input [23:0] a,b;
    input fdiv;
    input en,clk,rst_n;

    output [31:0] q;
    output busy;
    output [4:0] count;
    output [25:0] reg_x;
    output stall;

    reg [31:0] reg_q;
    reg [25:0] reg_x;
    reg [23:0] reg_a;
    reg [23:0] reg_b;
    reg [4:0] count;
    reg busy;

    //formation of stall signal
    assign stall=fdiv&(~|count)|busy;

    //implementation of xi+1=xi(2-xib)
    wire [49:0] bxi;
    wire [51:0] x52;
    assign bxi=reg_x*reg_b;             //can be replaced by wallace tree multiplier
    wire [25:0] b26=~bxi[48:23]+1'b1;
    assign x52=reg_x*b26;               //can be replaced by wallace tree multiplier

    //adjust count and busy
    wire [7:0] x0=rom(b[22:19]);
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count<=5'b0;
            busy<=1'b0;
            reg_x<=26'b0;
            reg_a<=23'b0;
            reg_b<=23'b0;
        end
        else begin
            if (fdiv&(count==0)) begin
                count<=5'b1;
                busy<=1'b1;
            end
            else begin
                if (count==5'h01) begin
                    reg_x<={2'b1,x0,16'b0};
                    reg_a<=a;
                    reg_b<=b;
                end
                if (count!=0) count<=count+5'b1;
                if (count==5'h0f) busy<=0;
                if (count==5'h10) count<=5'b0;
                if ((count==5'h06)||(count==5'h0b)||(count==5'h10)) reg_x<=x52[50:25];
            end
        end
    end

    //we dont need another adder to add the partial product
    wire [49:0] mul_result=reg_a*reg_x;
    wire [31:0] final_result={mul_result[48:18],|mul_result[17:0]};
    reg [31:0] reg_m;
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_m<=32'h0000_0000;
            reg_q<=32'h0000_0000;
        end
        else if (en) begin
            reg_m<=final_result;
            reg_q<=reg_m;
        end
    end
    assign q=reg_q;

    function [7:0] rom;
        input [3:0] b;
        case (b)
            4'h0    :   rom=8'hf0;
            4'h2    :   rom=8'hba;
            4'h4    :   rom=8'h8f;
            4'h6    :   rom=8'h6c;
            4'h8    :   rom=8'h4e;
            4'ha    :   rom=8'h35;
            4'hc    :   rom=8'h1f;
            4'he    :   rom=8'h0c;
            4'h1    :   rom=8'hd4;
            4'h3    :   rom=8'ha4;
            4'h5    :   rom=8'h7d;
            4'h7    :   rom=8'h5c;
            4'h9    :   rom=8'h41;
            4'hb    :   rom=8'h29;
            4'hd    :   rom=8'h15;
            4'hf    :   rom=8'h04;
        endcase
    endfunction
endmodule







