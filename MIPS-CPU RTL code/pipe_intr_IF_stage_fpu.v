module pipe_intr_IF_stage_fpu (pc,bpc,da,jpc,epc,selpc,pcsource,inst,pc4,next_pc);
	input [31:0] pc,bpc,da,jpc,epc;
	input [1:0] pcsource,selpc;
	output [31:0] pc4,next_pc,inst;

    wire [31:0] EXC_BASE=32'h0000_0008; 
	wire [31:0] npc;
	
	mux4x32 selnpc (.data1(pc4),.data2(bpc),.data3(da),.data4(jpc),.sel(pcsource),.dataout(npc));
    mux4x32 sel_real_pc (.data1(npc),.data2(epc),.data3(EXC_BASE),.data4(),.sel(selpc),.dataout(next_pc));
	addsub32 pcplus4 (.a(pc),.b(32'h0000_0004),.sub(1'b0),.r(pc4));
	pipe_intr_inst_mem_fpu instmem (.pc(pc),.inst(inst));
endmodule
