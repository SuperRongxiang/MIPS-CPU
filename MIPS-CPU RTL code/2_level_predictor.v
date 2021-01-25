module two_level_predictor (clk,rst_n,en,real_br_taken,pre_taken);
    input clk,rst_n,en;
    input real_br_taken;
    output pre_taken;

    wire [3:0] his_index;
    local_history_buffer his_buffer (.clk(clk),.rst_n(rst_n),.wen(en),.real_br_taken(real_br_taken),.his_out(his_index));
    pattern_history_table PHT   (.clk(clk),.rst_n(rst_n),.en(en),.his_index(his_index),.real_br_taken(real_br_taken),
                                .pre_taken(pre_taken));
endmodule