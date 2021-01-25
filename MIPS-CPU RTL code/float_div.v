module float_div (a,b,rm,fdiv,en,clk,rst_n,s,busy,stall,count,reg_x);
    input en,clk,rst_n,fdiv;
    input [1:0] rm;
    input [31:0] a,b;
    output [31:0] s;
    output stall,busy;
    output [25:0] reg_x;
    output [4:0] count;

    parameter ZERO=31'h00000000;
    parameter INF=31'h7f800000;
    parameter NaN=31'hfc000000;
    parameter MAX=31'h7f7fffff;

    wire a_expo_is_00=~|a[30:23];   //sign 31;exponent 30:23;fraction 22:0
    wire b_expo_is_00=~|b[30:23];
    wire a_expo_is_ff=&a[30:23];
    wire b_expo_if_ff=&b[30:23];
    wire a_frac_is_00=~|a[22:0];
    wire b_frac_is_00=~|b[22:0];
    wire sign=a[31]^b[31];
    wire [9:0] exp_10={2'h0,a[30:23]}-{2'h0,b[30:23]}+10'h7f;           //templated exponent
    wire [23:0] a_temp24=a_expo_is_00?{a[22:0],1'b0}:{1'b1,a[22:0]};
    wire [23:0] b_temp24=b_expo_is_00?{b[22:0],1'b0}:{1'b1,b[22:0]};    //shift left one bit for unnormalized number

    //to calculate the unnormalized float number, shift the fraction to make the msb of it to be 1;
    wire [23:0] a_frac24,b_frac24;
    wire [4:0] shamt_a,shamt_b;
    shift_to_msb_equ_1 shift_a(a_temp24,a_frac24,shamt_a);
    shift_to_msb_equ_1 shift_b(b_temp24,b_frac24,shamt_b);
    wire [9:0] exp10=exp_10-shamt_a-shamt_b;

    //pipeline registers
    reg e1_sign,e1_ae00,e1_aeff,e1_af00,e1_be00,e1_beff,e1_bf00;
    reg e2_sign,e2_ae00,e2_aeff,e2_af00,e2_be00,e2_beff,e2_bf00;
    reg e3_sign,e3_ae00,e3_aeff,e3_af00,e3_be00,e3_beff,e3_bf00;
    reg [1:0] e1_rm,e2_rm,e3_rm;
    reg [9:0] e1_exp10,e2_exp10,e3_exp10;
    always @ (negedge rst_n or posedge clk)
        if (!rst_n) begin
            e1_sign<=0;e1_ae00<=0;e1_aeff<=0;e1_af00<=0;e1_be00<=0;e1_beff<=0;e1_bf00<=0;e1_rm<=0;e1_exp10<=0;   //reg e1
            e2_sign<=0;e2_ae00<=0;e2_aeff<=0;e2_af00<=0;e2_be00<=0;e2_beff<=0;e2_bf00<=0;e2_rm<=0;e2_exp10<=0;   //reg e2
            e3_sign<=0;e3_ae00<=0;e3_aeff<=0;e3_af00<=0;e3_be00<=0;e3_beff<=0;e3_bf00<=0;e3_rm<=0;e3_exp10<=0;   //reg e3
        end
        else if (en) begin
            e1_sign<=sign;
            e1_ae00<=a_expo_is_00;    //reg e1
            e1_aeff<=a_expo_is_ff;
            e1_af00<=a_frac_is_00;
            e1_be00<=b_expo_is_00;
            e1_beff<=b_expo_if_ff;
            e1_bf00<=b_frac_is_00;
            e1_rm<=rm;
            e1_exp10<=exp10;

            e2_sign<=e1_sign;
            e2_ae00<=e1_ae00;
            e2_aeff<=e1_aeff;
            e2_af00<=e1_af00;
            e2_be00<=e1_be00;
            e2_beff<=e1_beff;
            e2_bf00<=e1_bf00;
            e2_rm<=e1_rm;
            e2_exp10<=e1_exp10;

            e3_sign<=e2_sign;
            e3_ae00<=e2_ae00;
            e3_aeff<=e2_aeff;
            e3_af00<=e2_af00;
            e3_be00<=e2_be00;
            e3_beff<=e2_beff;
            e3_bf00<=e2_bf00;
            e3_rm<=e2_rm;
            e3_exp10<=e2_exp10;
        end
    //divide the fraction of two numbers
    wire [31:0] q;  //af24/bf24=1.xxxxxxxxxx or 0.xxxxxxxxxxxx
    Newton_Raphson_divider_24 divider   (a_frac24,b_frac24,fdiv,en,clk,rst_n,q,busy,reg_x,count,stall);
    wire [31:0] z0=q[31]?q:{q[30:0],1'b0};
    wire [9:0] exp_adj=q[31]?e3_exp10:e3_exp10-10'b1;   //reg_e3

    //adjustment of exponent and fraction
    reg [9:0] exp0;
    reg [31:0] frac0;
    always @ * begin
        if (exp_adj[9]) begin   //exp is negative
            exp0=0;
            if (z0[31])
                frac0=z0>>(10'b1-exp_adj);
            else frac0=0;
        end 
    else if (exp_adj==0) begin  //exp is 0
        exp0=0;
        frac0={1'b0,z0[31:2],|z0[1:0]};    
    end
    else begin 
        if (exp_adj>254) begin
            exp0=10'hff;
            frac0=0;
        end
        else begin
            exp0=exp_adj;
            frac0=z0;
        end
        end
    end

    wire [26:0] frac={frac0[31:6],|frac0[5:0]}; //sticky
    wire frac_plus_1=   ~e3_rm[1]&~e3_rm[0]&frac[3]&frac[2]&~frac[1]&~frac[0]|
                        ~e3_rm[1]&~e3_rm[0]&frac[2]&(frac[1]|frac[0])|
                        ~e3_rm[1]&e3_rm[0]&(frac[2]|frac[1]|frac[0])&e3_sign|
                        e3_rm[1]&~e3_rm[0]&(frac[2]|frac[1]|frac[0])&~e3_sign;
    wire [24:0] frac_round={1'b0,frac[26:3]}+frac_plus_1;
    wire [9:0] exp1=frac_round[24]?exp0+10'h1:exp0;
    wire overflow=(exp1>=10'h0ff);  //oveflow

    wire [7:0] exponent;
    wire [22:0] fraction;
    assign  {exponent,fraction}=final_result(overflow,e3_rm,e3_sign,e3_ae00,e3_aeff,e3_af00,e3_be00,e3_beff,e3_bf00,{exp1[7:0],
            frac_round[22:0]});
    assign s={e3_sign,exponent,fraction};
    function [30:0] final_result;
        input overflow;
        input [1:0] e3_rm;
        input e3_sign;
        input a_e00,a_eff,a_f00,b_e00,b_eff,b_f00;
        input [30:0] calc;
        casex ({overflow,e3_rm,e3_sign,a_e00,a_eff,a_f00,b_e00,b_eff,b_f00})
            10'b100x_xxx_xxx    :   final_result=INF;
            10'b1010_xxx_xxx    :   final_result=MAX;
            10'b1011_xxx_xxx    :   final_result=INF;
            10'b1100_xxx_xxx    :   final_result=INF;
            10'b1101_xxx_xxx    :   final_result=MAX;
            10'b111x_xxx_xxx    :   final_result=MAX;
            10'b0xxx_010_xxx    :   final_result=NaN;
            10'b0xxx_011_010    :   final_result=NaN;
            10'b0xxx_100_010    :   final_result=NaN;
            10'b0xxx_101_010    :   final_result=NaN;
            10'b0xxx_00x_010    :   final_result=NaN;
            10'b0xxx_011_011    :   final_result=NaN;
            10'b0xxx_100_011    :   final_result=ZERO;
            10'b0xxx_101_011    :   final_result=ZERO;
            10'b0xxx_00x_011    :   final_result=ZERO;
            10'b0xxx_011_101    :   final_result=INF;
            10'b0xxx_100_101    :   final_result=INF;
            10'b0xxx_101_101    :   final_result=NaN;
            10'b0xxx_00x_101    :   final_result=INF;
            10'b0xxx_011_100    :   final_result=INF;
            10'b0xxx_100_100    :   final_result=calc;
            10'b0xxx_101_100    :   final_result=ZERO;
            10'b0xxx_00x_100    :   final_result=calc;
            10'b0xxx_011_00x    :   final_result=INF;
            10'b0xxx_100_00x    :   final_result=calc;
            10'b0xxx_101_00x    :   final_result=ZERO;
            10'b0xxx_00x_00x    :   final_result=calc;
            default             :   final_result=NaN;
        endcase
    endfunction
endmodule





    