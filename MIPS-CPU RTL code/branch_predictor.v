module branch_predictor(clk,rst_n,pc_if,real_bjpc,pc_id,ud_BTB,ud_pdt,real_br_taken,sel_bj_pc,inst_if,pre_taken,pre_bjpc);
    input clk,rst_n;
    input [31:0] inst_if,pc_if,real_bjpc,pc_id;
    input ud_BTB,ud_pdt,real_br_taken;
    output sel_bj_pc;
    output pre_taken;
    output [31:0] pre_bjpc;

    //pre-decode
    wire [5:0] op,func;
    wire i_j,i_jal,i_jr,i_beq,i_bne;
    assign op=inst_if[31:26];
    assign func=inst_if[5:0];
    and(r_type,~op[5],~op[4],~op[3],~op[2],~op[1],~op[0]);
    and(i_jr,r_type,~func[5],~func[4],func[3],~func[2],~func[1],~func[0]);
    and(i_j,~op[5],~op[4],~op[3],~op[2],op[1],~op[0]);
	and(i_jal,~op[5],~op[4],~op[3],~op[2],op[1],op[0]);
    and(i_beq,~op[5],~op[4],~op[3],op[2],~op[1],~op[0]);
	and(i_bne,~op[5],~op[4],~op[3],op[2],~op[1],op[0]);
    assign i_jump=i_j|i_jal|i_jr;
    assign i_branch=i_beq|i_bne;
    
    //select the PC
    wire read_hit;
    wire sel_bj_pc=(i_jump|(i_branch&pre_taken))&read_hit;
    //BTB read enable
    wire ren=i_jump|i_branch;

    //branch prediction
    sixteen_way_two_level_predictor main_predictor  (.clk(clk),.rst_n(rst_n),.en(ud_pdt),.pc_if(pc_if),.pc_id(pc_id),.real_br_taken(real_br_taken),
                                                    .pre_taken(pre_taken));

    branch_target_buffer BTB    (.clk(clk),.rst_n(rst_n),.wen(ud_BTB),.ren(ren),.pc_if(pc_if),.pre_bjpc(pre_bjpc),.pc_id(pc_id),
                                .read_hit(read_hit),.real_bjpc(real_bjpc));
endmodule