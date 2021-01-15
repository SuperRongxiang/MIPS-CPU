module float_mul_pipe_m2a_reg   (clk,rst_n,en,rm,m_sign,m_exp10,m_is_inf_nan,m_inf_nan_frac,m_a_frac24,m_b_frac24,a_rm,a_sign,a_exp10,
                                a_is_inf_nan,a_inf_nan_frac,a_a_frac24,a_b_frac24);
    input clk,rst_n,en;
    input [1:0] rm;
    input m_sign,m_is_inf_nan;
    input [9:0] m_exp10;
    input [22:0] m_inf_nan_frac;
    input [23:0] m_a_frac24,m_b_frac24;

    output [1:0] a_rm;
    output a_sign,a_is_inf_nan;
    output [9:0] a_exp10;
    output [22:0] a_inf_nan_frac;
    output [23:0] a_a_frac24,a_b_frac24;

    reg [1:0] a_rm;
    reg a_sign,a_is_inf_nan;
    reg [9:0] a_exp10;
    reg [22:0] a_inf_nan_frac;
    reg [23:0] a_a_frac24,a_b_frac24;

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_rm<=1'b0;
            a_sign<=1'b0;
            a_is_inf_nan<=1'b0;
            a_exp10<=10'h000;
            a_inf_nan_frac<=23'h0000;
            a_a_frac24<=24'h0000;
            a_b_frac24<=24'h0000;
        end
        else if (en) begin
            a_rm<=rm;
            a_sign<=m_sign;
            a_is_inf_nan<=m_is_inf_nan;
            a_exp10<=m_exp10;
            a_inf_nan_frac<=m_inf_nan_frac;
            a_a_frac24<=m_a_frac24;
            a_b_frac24<=m_b_frac24;
        end
    end
endmodule

