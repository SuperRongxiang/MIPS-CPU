module pipe_intr_IR_reg (inst_in,pc4_in,clk,rst_n,wpcir,pc4_out,inst_out,pc,pcd);
	input [31:0] inst_in,pc4_in,pc;
	input clk,rst_n,wpcir;
	output [31:0] pc4_out,inst_out,pcd;
	
	dffe32 PC4 (.d(pc4_in),.clk(clk),.rst_n(rst_n),.en(wpcir),.q(pc4_out));
	dffe32 inst (.d(inst_in),.clk(clk),.rst_n(rst_n),.en(wpcir),.q(inst_out));
    dffe32 trpc (.d(pc),.clk(clk),.rst_n(rst_n),.en(wpcir),.q(pcd));
endmodule