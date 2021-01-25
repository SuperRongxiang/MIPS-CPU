module pattern_history_table (clk,rst_n,en,his_index,real_br_taken,pre_taken);
    input clk,rst_n,en;
    input real_br_taken;        //the branch inst real result   1:taken 0:not taken
    input [3:0] his_index;
    output pre_taken;   //the prediction of branch inst result

    wire [15:0] scpt;
    wire [15:0] wen,decode_index;
    four_16_decoder wen_decoder  (.a(his_index),.b(decode_index));
    assign wen={16{en}}&decode_index;

    two_bit_sat_counter U0 (.clk(clk),.rst_n(rst_n),.en(wen[0]),.real_br_taken(real_br_taken),.pre_taken(scpt[0]));
    two_bit_sat_counter U1 (.clk(clk),.rst_n(rst_n),.en(wen[1]),.real_br_taken(real_br_taken),.pre_taken(scpt[1]));
    two_bit_sat_counter U2 (.clk(clk),.rst_n(rst_n),.en(wen[2]),.real_br_taken(real_br_taken),.pre_taken(scpt[2]));
    two_bit_sat_counter U3 (.clk(clk),.rst_n(rst_n),.en(wen[3]),.real_br_taken(real_br_taken),.pre_taken(scpt[3]));
    two_bit_sat_counter U4 (.clk(clk),.rst_n(rst_n),.en(wen[4]),.real_br_taken(real_br_taken),.pre_taken(scpt[4]));
    two_bit_sat_counter U5 (.clk(clk),.rst_n(rst_n),.en(wen[5]),.real_br_taken(real_br_taken),.pre_taken(scpt[5]));
    two_bit_sat_counter U6 (.clk(clk),.rst_n(rst_n),.en(wen[6]),.real_br_taken(real_br_taken),.pre_taken(scpt[6]));
    two_bit_sat_counter U7 (.clk(clk),.rst_n(rst_n),.en(wen[7]),.real_br_taken(real_br_taken),.pre_taken(scpt[7]));
    two_bit_sat_counter U8 (.clk(clk),.rst_n(rst_n),.en(wen[8]),.real_br_taken(real_br_taken),.pre_taken(scpt[8]));
    two_bit_sat_counter U9 (.clk(clk),.rst_n(rst_n),.en(wen[9]),.real_br_taken(real_br_taken),.pre_taken(scpt[9]));
    two_bit_sat_counter U10 (.clk(clk),.rst_n(rst_n),.en(wen[10]),.real_br_taken(real_br_taken),.pre_taken(scpt[10]));
    two_bit_sat_counter U11 (.clk(clk),.rst_n(rst_n),.en(wen[11]),.real_br_taken(real_br_taken),.pre_taken(scpt[11]));
    two_bit_sat_counter U12 (.clk(clk),.rst_n(rst_n),.en(wen[12]),.real_br_taken(real_br_taken),.pre_taken(scpt[12]));
    two_bit_sat_counter U13 (.clk(clk),.rst_n(rst_n),.en(wen[13]),.real_br_taken(real_br_taken),.pre_taken(scpt[13]));
    two_bit_sat_counter U14 (.clk(clk),.rst_n(rst_n),.en(wen[14]),.real_br_taken(real_br_taken),.pre_taken(scpt[14]));
    two_bit_sat_counter U15 (.clk(clk),.rst_n(rst_n),.en(wen[15]),.real_br_taken(real_br_taken),.pre_taken(scpt[15]));
    assign pre_taken=scpt[his_index];
endmodule


