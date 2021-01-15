module pipe_intr_cu_fpu (func,op,op1,rs,rt,rd,mrn,mm2reg,mwreg,ern,em2reg,ewreg,rsrtequ,pcsource,wpcir,wreg,m2reg,wmem,jal,aluc,aluimm,
                    shift,sext,regrt,fwda,fwdb,intr,inta,sta,ov,misbr,eisbr,ecancel,earith,arith,cancel,isbr,mfc0,wsta,wcau,wepc,mtc0,
                    cause,selepc,selpc,exc,fs,ft,e1n,e2n,e3n,ewfpr,mwfpr,e1w,e2w,e3w,stall_div_sqrt,st,fwdla,fwdlb,fwdfa,fwdfb,fc,
                    swfp,fwdf,fwdfe,wfpr,wf,fasmds,stall_lw,stall_fp,stall_lwc1,stall_swc1);
	input [31:0] sta;
    input [5:0] func,op;
	input [4:0] rs,rt,rd,mrn,ern,op1;
	input mm2reg,mwreg,em2reg,ewreg,rsrtequ,intr,ov,misbr,eisbr,ecancel,earith;

	output wreg,m2reg,wmem,jal,aluimm,shift,sext,regrt,wpcir,inta,arith,cancel,isbr,wsta,wcau,wepc,mtc0,exc;
	output [3:0] aluc;
	output [1:0] fwda,fwdb,pcsource,selepc,selpc,mfc0;
    output [31:0] cause;

    //FPU related signals
    input [4:0] fs,ft;
    input [4:0] e1n,e2n,e3n;
    input ewfpr,mwfpr;
    input e1w,e2w,e3w;
    input stall_div_sqrt,st;

    //FPU control signals or internal forward control signals
    output fwdla,fwdlb,fwdfa,fwdfb;
    output [2:0] fc;
    output swfp,fwdf,fwdfe;
    output wfpr,wf,fasmds;
    output stall_lw,stall_fp,stall_lwc1,stall_swc1;
	
	wire rtype,i_add,i_sub,i_and,i_or,i_xor,i_sll,i_srl,i_sra,i_jr;
	wire i_addi,i_andi,i_ori,i_xori,i_lw,i_sw,i_beq,i_bne,i_lui,i_j,i_jal;
    wire f_type,i_lwc1,i_swc1,i_fadd,i_fsub,i_fmul,i_fdiv,i_fsqrt;          //float instructions
	and(r_type,~op[5],~op[4],~op[3],~op[2],~op[1],~op[0]);
	and(i_add,r_type,func[5],~func[4],~func[3],~func[2],~func[1],~func[0]);
	and(i_sub,r_type,func[5],~func[4],~func[3],~func[2],func[1],~func[0]);
	and(i_and,r_type,func[5],~func[4],~func[3],func[2],~func[1],~func[0]);
	and(i_or,r_type,func[5],~func[4],~func[3],func[2],~func[1],func[0]);
	and(i_xor,r_type,func[5],~func[4],~func[3],func[2],func[1],~func[0]);
	and(i_sll,r_type,~func[5],~func[4],~func[3],~func[2],~func[1],~func[0]);
	and(i_srl,r_type,~func[5],~func[4],~func[3],~func[2],func[1],~func[0]);
	and(i_sra,r_type,~func[5],~func[4],~func[3],~func[2],func[1],func[0]);
	and(i_jr,r_type,~func[5],~func[4],func[3],~func[2],~func[1],~func[0]);
	and(i_addi,~op[5],~op[4],op[3],~op[2],~op[1],~op[0]);
	and(i_andi,~op[5],~op[4],op[3],op[2],~op[1],~op[0]);
	and(i_ori,~op[5],~op[4],op[3],op[2],~op[1],op[0]);
	and(i_xori,~op[5],~op[4],op[3],op[2],op[1],~op[0]);
	and(i_lw,op[5],~op[4],~op[3],~op[2],op[1],op[0]);	
	and(i_sw,op[5],~op[4],op[3],~op[2],op[1],op[0]);
	and(i_beq,~op[5],~op[4],~op[3],op[2],~op[1],~op[0]);
	and(i_bne,~op[5],~op[4],~op[3],op[2],~op[1],op[0]);
	and(i_lui,~op[5],~op[4],op[3],op[2],op[1],op[0]);
	and(i_j,~op[5],~op[4],~op[3],~op[2],op[1],~op[0]);
	and(i_jal,~op[5],~op[4],~op[3],~op[2],op[1],op[0]);
    and(f_type,~op[5],op[4],~op[3],~op[2],~op[1],op[0]);
    and(i_lwc1,op[5],op[4],~op[3],~op[2],~op[1],op[0]);
    and(i_swc1,op[5],op[4],op[3],~op[2],~op[1],op[0]);
    and(i_fadd,f_type,~func[5],~func[4],~func[3],~func[2],~func[1],~func[0]);
    and(i_fsub,f_type,~func[5],~func[4],~func[3],~func[2],~func[1],func[0]);
    and(i_fmul,f_type,~func[5],~func[4],~func[3],~func[2],func[1],~func[0]);
    and(i_fdiv,f_type,~func[5],~func[4],~func[3],~func[2],func[1],func[0]);
    and(i_fsqrt,f_type,~func[5],~func[4],~func[3],func[2],~func[1],~func[0]);


    //decode of intr instructions
	wire c0_type=~op[5]&op[4]&~op[3]&~op[2]&~op[1]&~op[0];
	wire i_mfc0=c0_type&~op1[4]&~op1[3]&~op1[2]&~op1[1]&~op1[0];
	wire i_mtc0=c0_type&~op1[4]&~op1[3]&op1[2]&~op1[1]&~op1[0];
	wire i_eret=c0_type&op1[4]&~op1[3]&~op1[2]&~op1[1]&~op1[0]&~func[5]&func[4]&func[3]&~func[2]&~func[1]&~func[0];
	wire i_syscall=r_type&~func[5]&~func[4]&func[3]&func[2]&~func[1]&~func[0];	//system call
	wire unimplemented_inst=~(i_mfc0|i_mtc0|i_eret|i_syscall|i_add|i_sub|i_and|i_or|i_xor|i_sll|i_srl|i_sra|i_jr|i_addi|i_andi|i_ori|i_xori|
	i_lw|i_sw|i_beq|i_bne|i_lui|i_j|i_jal);

    wire i_rs=i_add|i_sub|i_and|i_or|i_xor|i_jr|i_addi|i_andi|i_ori|i_xori|i_lw|i_sw|i_beq|i_bne|i_lwc1|i_swc1;
	wire i_rt=i_add|i_sub|i_and|i_or|i_xor|i_sll|i_srl|i_sra|i_sw|i_beq|i_bne|i_mtc0;
    assign stall_lw=ewreg&em2reg&(ern!=5'b00000)&((i_rs&(ern==rs))|(i_rt&(ern==rt)));   //stall (integer operation)
	
    
	reg [1:0] fwda,fwdb;
	always @(ewreg or mwreg or ern or mrn or em2reg or mm2reg or rs or rt) begin
		fwda=2'b00;	//default value, no harzard
		if (ewreg&(ern!=5'b00000)&(ern==rs)&~em2reg)	fwda=2'b01;
		else if (mwreg&(mrn!=5'b00000)&(mrn==rs)&~mm2reg)	fwda=2'b10;
		else if (mwreg&(mrn!=5'b00000)&(mrn==rs)&mm2reg)	fwda=2'b11;
		fwdb=2'b00;	//default value, no harzard
		if (ewreg&(ern!=5'b00000)&(ern==rt)&~em2reg)	fwdb=2'b01;
		else if (mwreg&(mrn!=5'b00000)&(mrn==rt)&~mm2reg)	fwdb=2'b10;
		else if (mwreg&(mrn!=5'b00000)&(mrn==rt)&mm2reg)	fwdb=2'b11;
		end

    assign isbr=i_beq|i_bne|i_j|i_jal;
    assign arith=i_add|i_sub|i_addi;
    wire overflow=earith&ov;
    wire exc_int=sta[0]&intr;
    wire exc_sys=sta[1]&i_syscall;
    wire exc_uni=sta[2]&unimplemented_inst;
    wire exc_ovr=sta[3]&overflow;
    assign inta=exc_int;
    assign exc=exc_int|exc_sys|exc_uni|exc_ovr;
    assign cancel=exc;  //always cancel next inst;
    assign selepc[0]=exc_int&isbr|exc_sys|exc_uni&~eisbr|exc_ovr&misbr;
    assign selepc[1]=exc_uni&eisbr|exc_ovr;

    //formation of cause
    wire Exccode0=i_syscall|overflow;
    wire Exccode1=unimplemented_inst|overflow;
    wire rd_is_status=~rd[4]&rd[3]&rd[2]&~rd[1]&~rd[0];
    wire rd_is_cause=~rd[4]&rd[3]&rd[2]&~rd[1]&rd[0];
    wire rd_is_epc=~rd[4]&rd[3]&rd[2]&rd[1]&~rd[0];
    assign cause={eisbr,27'h0,Exccode1,Exccode0,2'b00};
    assign mtc0=i_mtc0;
    assign wsta=exc|mtc0&rd_is_status|i_eret;
    assign wcau=exc|mtc0&rd_is_cause;
    assign wepc=exc|mtc0&rd_is_epc;

    //selection of mfc inst target data
    assign mfc0[0]=i_mfc0&rd_is_status|i_mfc0&rd_is_epc;
    assign mfc0[1]=i_mfc0&rd_is_cause|i_mfc0&rd_is_epc;

    //selection of pc
    assign selpc[0]=i_eret;
    assign selpc[1]=exc;  
    assign wreg=(i_add|i_sub|i_and|i_or|i_xor|i_sll|i_srl|i_sra|i_addi|i_andi|i_ori|i_xori|i_lw|i_lui|i_jal|i_mfc0)&wpcir&~ecancel&~exc_ovr;
	assign regrt=i_addi|i_andi|i_ori|i_xori|i_lw|i_lui|i_mfc0|i_lwc1;
	assign jal=i_jal;
	assign m2reg=i_lw;
	assign shift=i_sll|i_srl|i_sra;
	assign aluimm=i_addi|i_andi|i_ori|i_xori|i_lw|i_lui|i_sw|i_lwc1|i_swc1;
	assign sext=i_addi|i_lw|i_sw|i_beq|i_bne|i_lwc1|i_swc1;
	assign aluc[3]=i_sra;
	assign aluc[2]=i_sub|i_or|i_srl|i_sra|i_ori|i_lui;
	assign aluc[1]=i_xor|i_sll|i_srl|i_sra|i_xori|i_beq|i_bne|i_lui;
	assign aluc[0]=i_and|i_or|i_sll|i_srl|i_sra|i_andi|i_ori;
	assign wmem=(i_sw|i_swc1)&wpcir&~ecancel&~exc_ovr;
	assign pcsource[1]=i_j|i_jal|i_jr;
	assign pcsource[0]=i_j|i_jal|i_bne&~rsrtequ|i_beq&rsrtequ;

    //FPU control signals
    wire [2:0] fop;
    assign fop[0]=i_fsub;
    assign fop[1]=i_fmul|i_fsqrt;
    assign fop[2]=i_fdiv|i_fsqrt;
    wire i_fs=i_fadd|i_fsub|i_fmul|i_fdiv|i_fsqrt;
    wire i_ft=i_fadd|i_fsub|i_fmul|i_fdiv;
    assign stall_fp=(e1w&(i_fs&(e1n==fs)|i_ft&(e1n==ft)))|(e2w&(i_fs&(e2n==fs)|i_ft&(e2n==ft)));    //stall (data dependence)
    assign fwdfa=i_fs&e3w&(e3n==fs);                                 //forward fpu e3 data to fp a   (data dependence)
    assign fwdfb=i_fs&e3w&(e3n==ft);                                 //forward fpu e3 data to fp b   (data dependence)
    assign wfpr=i_lwc1&wpcir;                                   //fp reg write enable (IU)
    assign fwdla=i_fs&mwfpr&(mrn==fs);                          //forward mmo to fp a   (load word)
    assign fwdlb=i_ft&mwfpr&(mrn==ft);                          //forward mmo to fp b   (load word)
    assign stall_lwc1=ewfpr&(i_fs&(ern==fs)|i_ft&(ern==ft));    //stall (load word)
    assign swfp=i_swc1;                                         //select signal (store word)
    assign fwdf=swfp&e3w&(ft==e3n);                             //forward to id stage   (store word)
    assign fwdfe=swfp&e2w&(ft==e2n);                            //forward to exe stage  (store word)
    assign stall_swc1=swfp&e1w&(ft==e1n);                       //stall (store word)
    wire stall_others=stall_lw|stall_fp|stall_lwc1|stall_swc1|st;
    assign fc=fop&{3{~stall_others}};
    assign wpcir=~(stall_div_sqrt||stall_others);
    assign wf=i_fs&wpcir;                                       //fp reg write enable (FPU)
    assign fasmds=i_fs;
    
endmodule