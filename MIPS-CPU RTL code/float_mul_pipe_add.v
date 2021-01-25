module float_mul_pipe_add (a_a_frac24,a_b_frac24,a_z);
    input [23:0] a_a_frac24,a_b_frac24;
    output [47:0] a_z;
    assign a_z=a_a_frac24*a_b_frac24;
endmodule
