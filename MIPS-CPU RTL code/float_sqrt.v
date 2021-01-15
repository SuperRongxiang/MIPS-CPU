module float_sqrt (d,rm,fsqrt,en,clk,rst_n,s,busy,stall,count,reg_x);
    input clk,en,rst_n;
    input [31:0] d;
    input fsqrt;
    input [1:0] rm;
    output [31:0] s;
    output busy,stall;
    output [4:0] count;
    output [25:0] reg_x;

    parameter ZERO=31'h00000000;
    parameter INF=31'h7f800000;
    parameter NaN=31'hfc000000;
    parameter MAX=31'h7f7fffff;

    wire d_expo_is_00=~|d[30:23];   //sign 31;exponent 30:23;fraction 22:0
    wire d_expo_is_ff=&d[30:23];
    wire d_frac_is_00=~|d[22:0];
    wire sign=d[31];

    wire [7:0] exp_8={1'b0,d[30:24]}+8'h3f+d[23];
    wire [23:0] d_f24=d_expo_is_00?{d[22:0],1'b0}:{1'b1,d[22:0]};   //point is set at the left end of the number
    wire [23:0] d_temp24=d[23]?{1'b0,d_f24[23:1]}:d_f24;    //right shift 2bits or 1bit

    wire [23:0] d_frac24;
    wire [4:0] shamt_d;
    shift_even_bits shift_d (d_temp24,d_frac24,shamt_d);
    wire [7:0] exp0=exp_8-{4'h0,shamt_d[4:1]};

    //pipeline registers
    reg e1_sign,e1_e00,e1_eff,e1_f00;
    reg e2_sign,e2_e00,e2_eff,e2_f00;
    reg e3_sign,e3_e00,e3_eff,e3_f00;
    reg [1:0] e1_rm,e2_rm,e3_rm;
    reg [7:0] e1_exp,e2_exp,e3_exp;
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            e1_sign<=0;     e1_e00<=0;      e1_eff<=0;          e1_f00<=0;
            e2_sign<=0;     e2_e00<=0;      e2_eff<=0;          e2_f00<=0;
            e3_sign<=0;     e3_e00<=0;      e3_eff<=0;          e3_f00<=0;
            e1_rm<=2'b0;    e2_rm<=2'b0;    e3_rm<=2'b0;
            e1_exp<=8'b0;   e2_exp<=8'b0;   e3_exp<=8'b0;
        end
        else if (en) begin
            e1_sign<=sign;      e1_e00<=d_expo_is_00;   e1_eff<=d_expo_is_ff;   e1_f00<=d_frac_is_00;
            e2_sign<=e1_sign;   e2_e00<=e1_e00;         e2_eff<=e1_eff;         e2_f00<=e1_f00;
            e3_sign<=e2_sign;   e3_e00<=e2_e00;         e3_eff<=e2_eff;         e3_f00<=e2_f00;
            e1_rm<=rm;          e2_rm<=e1_rm;           e3_rm<=e2_rm;
            e1_exp<=exp0;       e2_exp<=e1_exp;         e3_exp<=e2_exp;
        end
    end

    //sqrt
    wire [31:0] frac0;
    sqrt_Newton_Raphson_24 frac_sqrt (d_frac24,fsqrt,en,clk,rst_n,frac0,busy,count,reg_x,stall);
    wire [26:0] frac={frac0[31:6],|frac0[5:0]}; //sticky

    //round the fraction
    wire frac_plus_1=   ~e3_rm[1]&~e3_rm[0]&frac[3]&frac[2]&~frac[1]&~frac[0]|
                        ~e3_rm[1]&~e3_rm[0]&frac[2]&(frac[1]|frac[0])|
                        ~e3_rm[1]&e3_rm[0]&(frac[2]|frac[1]|frac[0])&e3_sign|
                        e3_rm[1]&~e3_rm[0]&(frac[2]|frac[1]|frac[0])&~e3_sign;
    wire [24:0] frac_round={1'b0,frac[26:3]}+frac_plus_1;
    wire [9:0] exp1=frac_round[24]?e3_exp+8'h1:e3_exp;
    wire overflow=(exp1>=10'h0ff);  //oveflow

    wire [7:0] exponent;
    wire [22:0] fraction;
    assign {exponent,fraction}=final_result(overflow,e3_rm,e3_sign,e3_sign,e3_e00,e3_eff,e3_f00,{exp1[7:0],frac_round[22:0]});
    assign s={e3_sign,exponent,fraction};

    function [30:0] final_result;
        input overflow;
        input [1:0] e3_rm;
        input e3_sign;
        input d_sign,d_e00,d_eff,d_f00;
        input [30:0] clac;
        casex ({overflow,e3_rm,e3_sign,d_sign,d_e00,d_eff,d_f00})
            8'b100x_xxxx    :   final_result=INF;
            8'b1010_xxxx    :   final_result=MAX;
            8'b1011_xxxx    :   final_result=INF;
            8'b1100_xxxx    :   final_result=INF;
            8'b1101_xxxx    :   final_result=MAX;
            8'b111x_xxxx    :   final_result=MAX;
            8'b0xxx_1xxx    :   final_result=NaN;
            8'b0xxx_0010    :   final_result=NaN;
            8'b0xxx_0011    :   final_result=INF;
            8'b0xxx_0101    :   final_result=ZERO;
            8'b0xxx_000x    :   final_result=clac;
            8'b0xxx_0100    :   final_result=clac;
            default         :   final_result=NaN;
        endcase
    endfunction
endmodule


