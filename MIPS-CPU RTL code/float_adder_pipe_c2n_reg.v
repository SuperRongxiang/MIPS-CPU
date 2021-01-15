module float_adder_pipe_c2n_reg (clk,rst_n,en,c_rm,c_inf_nan,c_inf_nan_frac,c_sign,c_exp,c_frac,n_rm,n_inf_nan,n_inf_nan_frac,n_sign,n_exp,n_frac);
    input clk,rst_n,en;

    input [1:0] c_rm;
    input c_inf_nan,c_sign;
    input [22:0] c_inf_nan_frac;
    input [7:0] c_exp;
    input [27:0] c_frac;

    output [1:0] n_rm;
    output n_inf_nan,n_sign;
    output [22:0] n_inf_nan_frac;
    output [7:0] n_exp;
    output [27:0] n_frac;

    reg [1:0] n_rm;
    reg n_inf_nan,n_sign;
    reg [22:0] n_inf_nan_frac;
    reg [7:0] n_exp;
    reg [27:0] n_frac;

    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            n_rm<=2'b00;
            n_inf_nan<=1'b0;
            n_sign<=1'b0;
            n_inf_nan_frac<=23'h0;
            n_exp<=8'h00;
            n_frac<=28'h0;
        end
        else if (en) begin
            n_rm<=c_rm;
            n_inf_nan<=c_inf_nan;
            n_sign<=c_sign;
            n_inf_nan_frac<=c_inf_nan_frac;
            n_exp<=c_exp;
            n_frac<=c_frac;
        end
    end
endmodule