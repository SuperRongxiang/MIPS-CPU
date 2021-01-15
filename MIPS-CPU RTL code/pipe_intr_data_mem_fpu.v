module pipe_intr_data_mem_fpu (mem_clk,dataout,datain,addr,we);
	input [31:0] datain,addr;
	input mem_clk,we;
	output [31:0] dataout;
	reg [31:0] ram [0:31];
	assign dataout=ram[addr[6:2]];
	always @ (posedge mem_clk) begin
		if (we) ram[addr[6:2]]<=datain;
		end
	integer i;
	initial begin
		for (i=0;i<32;i=i+1)
			ram[i]=0;
		ram[5'h00]=32'hBF800000;
		ram[5'h01]=32'h40800000;
		ram[5'h02]=32'h40000000;
		ram[5'h03]=32'h41100000;
		ram[5'h14]=32'h40c00000;
		ram[5'h15]=32'h41c00000;
		ram[5'h16]=32'h43c00000;
		ram[5'h17]=32'h47c00000;
		end
endmodule
			


