module pipe_intr_PC_reg (clk,rst_n,wpcir,PC_in,PC_out);
	input clk,rst_n,wpcir;
	input [31:0] PC_in;
	output [31:0] PC_out;
	
	dffe32 program_counter (.d(PC_in),.clk(clk),.rst_n(rst_n),.en(wpcir),.q(PC_out));
endmodule