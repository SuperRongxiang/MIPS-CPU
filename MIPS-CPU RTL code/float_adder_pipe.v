module float_adder_pipe(clk,rst_n,en,a,b,sub,rm,s);
    input [31:0] a,b;
    input clk,sub,rst_n,en;
    input [1:0] rm;
    output [31:0] s;

    wire a_inf_nan,a_sign,a_op_sub;
    wire [23:0] a_large_frac;
    wire [26:0] a_small_frac;
    wire [22:0] a_inf_nan_frac;
    wire [7:0] a_exp;
    wire [1:0] c_rm;
    wire c_inf_nan,c_sign,c_op_sub;
    wire [23:0] c_large_frac;
    wire [26:0] c_small_frac;
    wire [22:0] c_inf_nan_frac;
    wire [7:0] c_exp;
    float_adder_pipe_align align_stage  (.a(a),.b(b),.sub(sub),.a_inf_nan(a_inf_nan),.a_inf_nan_frac(a_inf_nan_frac),.a_sign(a_sign),.a_exp(a_exp),
                                        .a_op_sub(a_op_sub),.a_large_frac(a_large_frac),.a_small_frac(a_small_frac));
    flaot_adder_pipe_a2c_reg a2c_reg    (.clk(clk),.rst_n(rst_n),.en(en),.rm(rm),.a_inf_nan(a_inf_nan),.a_inf_nan_frac(a_inf_nan_frac),.a_sign(a_sign),
                                        .a_exp(a_exp),.a_op_sub(a_op_sub),.a_large_frac(a_large_frac),.a_small_frac(a_small_frac),.c_rm(c_rm),
                                        .c_inf_nan(c_inf_nan),.c_inf_nan_frac(c_inf_nan_frac),.c_sign(c_sign),.c_exp(c_exp),.c_op_sub(c_op_sub),
                                        .c_large_frac(c_large_frac),.c_small_frac(c_small_frac));

    wire [27:0] c_frac;
    wire [1:0] n_rm;
    wire n_inf_nan,n_sign;
    wire [22:0] n_inf_nan_frac;
    wire [7:0] n_exp;
    wire [27:0] n_frac;
    float_adder_pipe_cal cal_stage      (.c_op_sub(c_op_sub),.c_large_frac(c_large_frac),.c_small_frac(c_small_frac),.c_frac(c_frac));                                
    float_adder_pipe_c2n_reg c2n_reg    (.clk(clk),.rst_n(rst_n),.en(en),.c_rm(c_rm),.c_inf_nan(c_inf_nan),.c_inf_nan_frac(c_inf_nan_frac),.c_sign(c_sign),
                                        .c_exp(c_exp),.c_frac(c_frac),.n_rm(n_rm),.n_inf_nan(n_inf_nan),.n_inf_nan_frac(n_inf_nan_frac),.n_sign(n_sign),
                                        .n_exp(n_exp),.n_frac(n_frac));
    float_adder_pipe_norm norm_stage    (.n_rm(n_rm),.n_inf_nan(n_inf_nan),.n_inf_nan_frac(n_inf_nan_frac),.n_sign(n_sign),.n_exp(n_exp),.n_frac(n_frac),.s(s));
endmodule