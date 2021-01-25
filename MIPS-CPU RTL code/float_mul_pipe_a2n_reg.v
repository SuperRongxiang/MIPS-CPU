module float_mul_pipe_a2n_reg (clk,rst_n,en,a_rm,a_sign,a_exp10,a_is_inf_nan,a_inf_nan_frac,a_z,n_rm,n_sign,n_exp10,n_is_inf_nan,n_inf_nan_frac,n_z);
    input clk,rst_n,en;
    input [1:0] a_rm;
    input a_sign,a_is_inf_nan;
    input [9:0] a_exp10;
    input [22:0] a_inf_nan_frac;
    input [47:0] a_z;

    output [1:0] n_rm;
    output n_sign,n_is_inf_nan;
    output [9:0] n_exp10;
    output [22:0] n_inf_nan_frac;
    output [47:0] n_z;
    
    reg [1:0] n_rm;
    reg n_sign,n_is_inf_nan;
    reg [9:0] n_exp10;
    reg [22:0] n_inf_nan_frac;
    reg [47:0] n_z;

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            n_rm<=1'b0;
            n_sign<=1'b0;
            n_is_inf_nan<=1'b0;
            n_exp10<=10'h000;
            n_inf_nan_frac<=23'h0000;
            n_z<=48'h000000_000000;
        end
        else if (en) begin
            n_rm<=a_rm;
            n_sign<=a_sign;
            n_is_inf_nan<=a_is_inf_nan;
            n_exp10<=a_exp10;
            n_inf_nan_frac<=a_inf_nan_frac;
            n_z<=a_z;
        end
    end
endmodule

