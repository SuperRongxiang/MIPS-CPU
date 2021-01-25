module float_mul_pipe_mul (a,b,m_sign,m_exp10,m_is_inf_nan,m_inf_nan_frac,m_a_frac24,m_b_frac24);
    input [31:0] a,b;
    output m_sign,m_is_inf_nan;
    output [9:0] m_exp10;
    output [22:0] m_inf_nan_frac;
    output [23:0] m_a_frac24,m_b_frac24;

    //take care of NaN and Inf
    wire a_expo_is_00=~|a[30:23];   //sign 31;exponent 30:23;fraction 22:0
    wire b_expo_is_00=~|b[30:23];
    wire a_expo_is_ff=&a[30:23];
    wire b_expo_if_ff=&b[30:23];
    wire a_frac_is_00=~|a[22:0];
    wire b_frac_is_00=~|b[22:0];
    wire a_is_inf=a_expo_is_ff&a_frac_is_00;
    wire b_is_inf=b_expo_if_ff&b_frac_is_00;
    wire a_is_nan=a_expo_is_ff&~a_frac_is_00;
    wire b_is_nan=b_expo_if_ff&~b_frac_is_00;
    wire a_is_00=a_expo_is_00&a_frac_is_00;
    wire b_is_00=b_expo_is_00&b_frac_is_00;
    wire m_is_inf_nan=a_is_inf|a_is_nan|b_is_inf|b_is_nan;
    wire s_is_nan=a_is_nan|b_is_nan|(a_is_00&b_is_inf)|(a_is_inf&b_is_00);
    wire [22:0] nan_frac={1'b0,a[22:0]}>{1'b0,b[22:0]}?{1'b1,a[21:0]}:{1'b1,b[21:0]};
    wire [22:0] m_inf_nan_frac=s_is_nan?nan_frac:23'h0;

    //formation of temporary exponent
    wire m_sign=a[31]^b[31];
    wire [9:0] m_exp10={2'h0,a[30:23]}+{2'h0,b[30:23]}-10'h7f+a_expo_is_00+b_expo_is_00;

    //formation of fractions of a and b
    wire [23:0] m_a_frac24={~a_expo_is_00,a[22:0]};
    wire [23:0] m_b_frac24={~b_expo_is_00,b[22:0]};
endmodule

