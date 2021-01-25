module float_adder_pipe_cal (c_op_sub,c_large_frac,c_small_frac,c_frac);
    input c_op_sub;
    input [23:0] c_large_frac;
    input [26:0] c_small_frac;
    output [27:0] c_frac;

    //formation the actual number that will be put into calculation
    wire [27:0] aligned_large_frac={1'b0,c_large_frac,3'b000};
    wire [27:0] aligned_small_frac={1'b0,c_small_frac};
    wire [27:0] c_frac=c_op_sub?aligned_large_frac-aligned_small_frac:aligned_large_frac+aligned_small_frac;    //actual calculation
endmodule