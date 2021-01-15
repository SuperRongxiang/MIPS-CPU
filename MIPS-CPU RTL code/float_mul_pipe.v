module float_mul_pipe (clk,rst_n,en,a,b,rm,s);
    input clk,rst_n,en;
    input [31:0] a,b;
    input [1:0] rm;
    output [31:0] s;

    wire m_sign,m_is_inf_nan;
    wire [9:0] m_exp10;
    wire [22:0] m_inf_nan_frac;
    wire [23:0] m_a_frac24,m_b_frac24;
    float_mul_pipe_mul mul_stage (.a(a),.b(b),.m_sign(m_sign),.m_exp10(m_exp10),.m_is_inf_nan(m_is_inf_nan),.m_inf_nan_frac(m_inf_nan_frac),
                                .m_a_frac24(m_a_frac24),.m_b_frac24(m_b_frac24));

    wire [1:0] a_rm;
    wire a_sign,a_is_inf_nan;
    wire [9:0] a_exp10;
    wire [22:0] a_inf_nan_frac;
    wire [23:0] a_a_frac24,a_b_frac24;
    wire [47:0] a_z;
    float_mul_pipe_m2a_reg m2a_reg   (.clk(clk),.rst_n(rst_n),.en(en),.rm(rm),.m_sign(m_sign),.m_exp10(m_exp10),.m_is_inf_nan(m_is_inf_nan),
                                    .m_inf_nan_frac(m_inf_nan_frac),.m_a_frac24(m_a_frac24),.m_b_frac24(m_b_frac24),.a_rm(a_rm),
                                    .a_sign(a_sign),.a_exp10(a_exp10),.a_is_inf_nan(a_is_inf_nan),.a_inf_nan_frac(a_inf_nan_frac),
                                    .a_a_frac24(a_a_frac24),.a_b_frac24(a_b_frac24));
    float_mul_pipe_add add_stage    (.a_a_frac24(a_a_frac24),.a_b_frac24(a_b_frac24),.a_z(a_z));

    wire [1:0] n_rm;
    wire n_sign,n_is_inf_nan;
    wire [9:0] n_exp10;
    wire [22:0] n_inf_nan_frac;
    wire [47:0] n_z;
    float_mul_pipe_a2n_reg a2n_reg  (.clk(clk),.rst_n(rst_n),.en(en),.a_rm(a_rm),.a_sign(a_sign),.a_exp10(a_exp10),.a_is_inf_nan(a_is_inf_nan),.a_inf_nan_frac(a_inf_nan_frac),
                                    .a_z(a_z),.n_rm(n_rm),.n_sign(n_sign),.n_exp10(n_exp10),.n_is_inf_nan(n_is_inf_nan),.n_inf_nan_frac(n_inf_nan_frac),
                                    .n_z(n_z));
    float_mul_pipe_norm norm_stage  (.n_rm(n_rm),.n_sign(n_sign),.n_exp10(n_exp10),.n_is_inf_nan(n_is_inf_nan),.n_inf_nan_frac(n_inf_nan_frac),
                                    .n_z(n_z),.s(s));
endmodule