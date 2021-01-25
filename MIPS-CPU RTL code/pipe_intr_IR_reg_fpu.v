module pipe_intr_IR_reg_fpu (inst_in,pc4_in,clk,rst_n,wpcir,pc4_out,inst_out,pc,pcd,pre_taken_if,pre_taken_id,pre_bjpc_if,pre_bjpc_id);
	input [31:0] inst_in,pc4_in,pc;
	input clk,rst_n,wpcir;
    input pre_taken_if;
    input [31:0] pre_bjpc_if;
	output [31:0] pc4_out,inst_out,pcd;
    output [31:0] pre_bjpc_id;
    output pre_taken_id;
	
    dffe1 pretaken (.datain(pre_taken_if),.clk(clk),.rst_n(rst_n),.en(wpcir),.dataout(pre_taken_id));
    dffe32 bjpc (.d(pre_bjpc_if),.clk(clk),.rst_n(rst_n),.en(wpcir),.q(pre_bjpc_id));
	dffe32 PC4 (.d(pc4_in),.clk(clk),.rst_n(rst_n),.en(wpcir),.q(pc4_out));
	dffe32 inst (.d(inst_in),.clk(clk),.rst_n(rst_n),.en(wpcir),.q(inst_out));
    dffe32 trpc (.d(pc),.clk(clk),.rst_n(rst_n),.en(wpcir),.q(pcd));
endmodule