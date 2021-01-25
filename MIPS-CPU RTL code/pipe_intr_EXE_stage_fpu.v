
module pipe_intr_EXE_stage_fpu 	(ewreg0,ewreg,em2reg,ewmem,ejal,ealuc,ealuimm,eshift,epc4,eda,edb,eimm,ern0,ealu,ern1,earith,emfc0,sta,cau,epc,ov,e3d,efwdfe,eb);
	input ewreg0,em2reg,ewmem,ejal,ealuimm,eshift,earith;    
    input [1:0] emfc0;
	input [3:0] ealuc;
	input [31:0] epc4,eda,edb,eimm,sta,cau,epc;
	input [4:0] ern0;
	output [31:0] ealu;
	output [4:0] ern1;
    output ewreg,ov;

    //e3d forward
    input [31:0] e3d;
    input efwdfe;
    output [31:0] eb;

	//formation of epc8
	wire [31:0] epc8;
	addsub32 form_epc8(.a(32'h00000004),.b(epc4),.sub(1'b0),.r(epc8));
	 
	//selection of ALU_a and ALU_b
	wire [31:0] ALU_a,ALU_b,ALU_r;
	mux2x32 sel_alu_a (.data1(eda),.data2(eimm),.sel(eshift),.dataout(ALU_a));
	mux2x32 sel_alu_b (.data1(edb),.data2(eimm),.sel(ealuimm),.dataout(ALU_b));
	
    //selection of intr regs and epc8
    wire [31:0] tar_data;
    mux4x32 sel_of_regs (.data1(epc8),.data2(sta),.data3(cau),.data4(epc),.sel(emfc0),.dataout(tar_data));

	//selection of ealu
    wire selealu;
    assign selealu=ejal|emfc0[0]|emfc0[1];
	mux2x32 sel_ealu (.data1(ALU_r),.data2(tar_data),.sel(selealu),.dataout(ealu));
	
	//jump and link rn
	assign ern1=ern0|{5{ejal}};

    //e3d forward to exe stage
	mux2x32 seleb (.data1(edb),.data2(e3d),.sel(efwdfe),.dataout(eb));

	//ALU
	pipe_intr_ALU main_ALU (.a(ALU_a),.b(ALU_b),.aluc(ealuc),.r(ALU_r),.z(),.v(ov));
    
	//formation of right ewreg;
    assign ewreg=~(ov&earith)&ewreg0;	//cancel overflow instruction

endmodule


