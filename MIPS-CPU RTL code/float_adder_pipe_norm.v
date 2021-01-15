module float_adder_pipe_norm (n_rm,n_inf_nan,n_inf_nan_frac,n_sign,n_exp,n_frac,s);
    input [1:0] n_rm;
    input n_inf_nan,n_sign;
    input [22:0] n_inf_nan_frac;
    input [7:0] n_exp;
    input [27:0] n_frac;
    output [31:0] s;

    //normalization of n_frac
    wire [26:0] f4,f3,f2,f1,f0;
    wire [4:0] zeros;
    assign zeros[4]=~|n_frac[26:11];                          //16bit 0
    assign f4=zeros[4]?{n_frac[10:0],16'b0}:n_frac[26:0];
    assign zeros[3]=~|f4[26:19];                                //8bit 0
    assign f3=zeros[3]?{f4[18:0],8'h0}:f4;
    assign zeros[2]=~|f3[26:23];                                //4bit 0
    assign f2=zeros[2]?{f3[22:0],4'h0}:f3;
    assign zeros[1]=~|f2[26:25];                                //2bit 0
    assign f1=zeros[1]?{f2[24:0],2'b00}:f2;
    assign zeros[0]=~f1[26];                                    //1bit 0
    assign f0=zeros[0]?{f1[25:0],1'b0}:f1;

    reg [7:0] exp0;
    reg [26:0] frac0;
    always @* begin
        if (n_frac[27]) begin
            frac0=n_frac[27:1];
            exp0=n_exp+8'h1;
        end else begin
            if ((n_exp>zeros)&&(f0[26])) begin
                exp0=n_exp-zeros;
                frac0=f0;
            end else begin
                exp0=0;
                if (n_exp!=0)
                        frac0=n_frac[26:0]<<(n_exp-8'h1);
                else frac0=n_frac[26:0];
            end
        end
    end

    //take care of round
    wire frac_plus_1=   ~n_rm[1]&~n_rm[0]&frac0[2]&(frac0[1]|frac0[0])|
                        ~n_rm[1]&~n_rm[0]&frac0[2]&~frac0[1]&~frac0[0]&frac0[3]|
                        ~n_rm[1]&n_rm[0]&(frac0[2]|frac0[1]|frac0[0])&n_sign|
                        n_rm[1]&~n_rm[0]&(frac0[2]|frac0[1]|frac0[0])&~n_sign;
    wire [24:0] frac_round={1'b0,frac0[26:3]}+frac_plus_1;

    //take care of overflow
    wire [7:0] exponent=frac_round[24]?(exp0+8'h1):exp0;
    wire overflow=&exp0|&exponent;
    wire [7:0] final_exponent;
    wire [22:0] final_fraction;
    assign {final_exponent,final_fraction}=final_result(overflow,n_rm,n_sign,n_inf_nan,exponent,frac_round[22:0],n_inf_nan_frac);
    assign s={n_sign,final_exponent,final_fraction};
    function [30:0] final_result;
        input overflow;
        input [1:0] n_rm;
        input n_sign,n_inf_nan;
        input [7:0] exponent;
        input [22:0] fraction,n_inf_nan_frac;
        casex ({overflow,n_rm,n_sign,n_inf_nan})
            5'b1_00_x_x:    final_result={8'hff,23'h00000}; //inf
            5'b1_01_0_x:    final_result={8'hfe,23'h7ffff}; //max
            5'b1_01_1_x:    final_result={8'hff,23'h00000}; //inf
            5'b1_10_0_x:    final_result={8'hff,23'h00000}; //inf
            5'b1_10_1_x:    final_result={8'hfe,23'h7ffff}; //max
            5'b1_11_x_x:    final_result={8'hfe,23'h7ffff}; //max
            5'b0_xx_x_0:    final_result={exponent,fraction}; //normal
            5'b0_xx_x_1:    final_result={8'hff,n_inf_nan_frac}; //inf_nan
            default:        final_result={8'h00,23'h00000}; //0
        endcase
    endfunction
endmodule