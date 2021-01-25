module float_adder_pipe_a2c_reg     (clk,rst_n,en,rm,a_inf_nan,a_inf_nan_frac,a_sign,a_exp,a_op_sub,a_large_frac,a_small_frac,c_rm,c_inf_nan,
                                    c_inf_nan_frac,c_sign,c_exp,c_op_sub,c_large_frac,c_small_frac);
    input clk,rst_n,en;

    input [1:0] rm;
    input a_inf_nan,a_sign,a_op_sub;
    input [23:0] a_large_frac;
    input [26:0] a_small_frac;
    input [22:0] a_inf_nan_frac;
    input [7:0] a_exp;

    output [1:0] c_rm;
    output c_inf_nan,c_sign,c_op_sub;
    output [23:0] c_large_frac;
    output [26:0] c_small_frac;
    output [22:0] c_inf_nan_frac;
    output [7:0] c_exp;

    reg [1:0] c_rm;
    reg c_inf_nan,c_sign,c_op_sub;
    reg [23:0] c_large_frac;
    reg [26:0] c_small_frac;
    reg [22:0] c_inf_nan_frac;
    reg [7:0] c_exp;

    always @ (posedge clk or negedge rst_n) begin
       if(!rst_n) begin
            c_inf_nan<=0;
            c_sign<=0;
            c_op_sub<=0;
            c_large_frac<=24'h0;
            c_small_frac<=24'h0;
            c_inf_nan_frac<=23'h0;
            c_exp<=8'h0;
            c_rm<=2'b00;
       end
       else if (en) begin
            c_inf_nan<=a_inf_nan;
            c_sign<=a_sign;
            c_op_sub<=a_op_sub;
            c_large_frac<=a_large_frac;
            c_small_frac<=a_small_frac;
            c_inf_nan_frac<=a_inf_nan_frac;
            c_exp<=a_exp;
            c_rm<=rm;
       end
    end
endmodule

