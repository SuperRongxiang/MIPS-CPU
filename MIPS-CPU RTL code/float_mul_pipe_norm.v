module float_mul_pipe_norm (n_rm,n_sign,n_exp10,n_is_inf_nan,n_inf_nan_frac,n_z,s);
    input [1:0] n_rm;
    input n_sign,n_is_inf_nan;
    input [9:0] n_exp10;
    input [22:0] n_inf_nan_frac;
    input [47:0] n_z;
    output [31:0] s;

     //shfit the partial product and formation of initial exponent and fraction
    wire [46:0] z5,z4,z3,z2,z1,z0;
    wire [5:0] zeros;
    assign zeros[5]=~|n_z[46:15];                    //32bit
    assign z5=zeros[5]?{n_z[14:0],32'h0000}:n_z[46:0];
    assign zeros[4]=~|z5[46:31];
    assign z4=zeros[4]?{z5[30:0],16'b0}:z5;
    assign zeros[3]=~|z4[46:39];
    assign z3=zeros[3]?{z4[38:0],8'b0}:z4;
    assign zeros[2]=~|z3[46:43];
    assign z2=zeros[2]?{z3[42:0],4'b0}:z3;
    assign zeros[1]=~|z2[46:45];
    assign z1=zeros[1]?{z2[44:0],2'b0}:z2;
    assign zeros[0]=~|z1[46];
    assign z0=zeros[0]?{z1[45:0],1'b0}:z1;

    reg [9:0] exp0;
    reg [46:0] frac0;
    always @ * begin
        if (n_z[47])begin
            exp0=n_exp10+10'h1;
            frac0=n_z[47:1];
        end
        else begin
            if(!n_exp10[9]&&(n_exp10[8:0]>zeros)&&z0[46]) begin
                exp0=n_exp10-zeros;
                frac0=z0;
            end
            else begin
                exp0=0;
                if(!n_exp10[9]&&(n_exp10!=0))
                    frac0=n_z[46:0]<<(n_exp10-10'h1);
                else frac0=n_z[46:0]>>(10'h1-n_exp10);
            end
        end
    end

    //fraction round
    wire [26:0] frac={frac0[46:21],|frac0[20:0]};
    wire frac_plus_1=   ~n_rm[1]&~n_rm[0]&frac0[2]&(frac0[1]|frac0[0])|
                        ~n_rm[1]&~n_rm[0]&frac0[2]&~frac0[1]&~frac0[0]&frac0[3]|
                        ~n_rm[1]&n_rm[0]&(frac0[2]|frac0[1]|frac0[0])&n_sign|
                        n_rm[1]&~n_rm[0]&(frac0[2]|frac0[1]|frac0[0])&~n_sign;
    wire [24:0] frac_round={1'b0,frac[26:3]}+frac_plus_1;
    wire [9:0] exp1=frac_round[24]?(exp0+10'h1):exp0;
    wire overflow=(exp0>=10'h0ff)|(exp1>=10'h0ff);

    //select the result
    wire [7:0] final_exponent;
    wire [22:0] final_fraction;
    assign {final_exponent,final_fraction}=final_result(overflow,n_rm,n_sign,n_is_inf_nan,exp1[7:0],frac_round[22:0],n_inf_nan_frac);
    assign s={n_sign,final_exponent,final_fraction};

    function [30:0] final_result;
        input overflow;
        input [1:0] n_rm;
        input n_sign,n_is_inf_nan;
        input [7:0] exponent;
        input [22:0] fraction,n_inf_nan_frac;
        if (n_is_inf_nan) final_result={8'hff,n_inf_nan_frac}; //inf_nan
        else    casex ({overflow,n_rm,n_sign,n_is_inf_nan})
                5'b1_00_x_x:    final_result={8'hff,23'h00000}; //inf
                5'b1_01_0_x:    final_result={8'hfe,23'h7ffff}; //max
                5'b1_01_1_x:    final_result={8'hff,23'h00000}; //inf
                5'b1_10_0_x:    final_result={8'hff,23'h00000}; //inf
                5'b1_10_1_x:    final_result={8'hfe,23'h7ffff}; //max
                5'b1_11_x_x:    final_result={8'hfe,23'h7ffff}; //max
                5'b0_xx_x_0:    final_result={exponent,fraction}; //normal
                default:        final_result={8'h00,23'h00000}; //0
        endcase
    endfunction
endmodule