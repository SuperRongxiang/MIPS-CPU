module pipe_intr_IF_stage_fpu 	(pc,bpc,da,jpc,epc,selpc,pcsource,inst,pc4,next_pc,pre_taken,pre_bjpc,clk,rst_n,pre_fch_wrong,ud_BTB,
								ud_pdt,pc_id,real_bjpc);
	input [31:0] pc,bpc,da,jpc,epc;
	input [1:0] pcsource,selpc;

	//predictor's inputs and outputs
	input clk,rst_n;
	input pre_fch_wrong;
	input ud_BTB,ud_pdt;
	input [31:0] pc_id,real_bjpc;
	output pre_taken;
	output [31:0] pre_bjpc;

	output [31:0] pc4,next_pc,inst;

    wire [31:0] EXC_BASE=32'h0000_0008; 
	wire [31:0] npc;
	wire [31:0] pre_fch_pc;

	wire real_br_taken=pre_fch_wrong^pre_taken;
	branch_predictor predictor 	(.clk(clk),.rst_n(rst_n),.pc_if(pc),.real_bjpc(real_bjpc),.pc_id(pc_id),.ud_BTB(ud_BTB),.ud_pdt(ud_pdt),
								.real_br_taken(real_br_taken),.sel_bj_pc(sel_bj_pc),.inst_if(inst),.pre_taken(pre_taken),.pre_bjpc(pre_bjpc));

	mux2x32 sel_bj_target_pc (.data1(pc4),.data2(pre_bjpc),.sel(sel_bj_pc),.dataout(pre_fch_pc));			//predict inst pc addt
	mux2x32 refetch_pc (.data1(pre_fch_pc),.data2(real_bjpc),.sel(pre_fch_wrong),.dataout(npc));		//prediction failed, re fetch the right inst
	//mux4x32 selnpc (.data1(pc4),.data2(bpc),.data3(da),.data4(jpc),.sel(pcsource),.dataout(re_fch_pc));			//branch and jump
    mux4x32 sel_real_pc (.data1(npc),.data2(epc),.data3(EXC_BASE),.data4(),.sel(selpc),.dataout(next_pc));	//inrtuption
	addsub32 pcplus4 (.a(pc),.b(32'h0000_0004),.sub(1'b0),.r(pc4));
	pipe_intr_inst_mem_fpu instmem (.pc(pc),.inst(inst));
endmodule
