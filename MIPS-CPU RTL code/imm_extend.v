module imm_extend(imm,sel_ext,ext_imm);
	input [15:0] imm;
	input sel_ext;
	output [31:0] ext_imm;

	assign ext_imm={{16{imm[15]&sel_ext}},imm};
endmodule

