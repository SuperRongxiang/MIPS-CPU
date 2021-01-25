module branch_target_buffer (clk,rst_n,wen,ren,pc_if,pre_bjpc,pc_id,read_hit,real_bjpc);
    input clk,rst_n,ren,wen;                //there must be a wen after ren
    input [31:0] pc_if,real_bjpc;
    input [31:0] pc_id;
    output [31:0] read_hit;
    output [31:0] pre_bjpc;

    reg read_hit,hit;                       //same meaning, but read hit is outputted
    reg [4:0] counter;                      //count the number of inst buffered in the btb
    reg [3:0] hit_position;
    reg [31:0] bj_inst_pc_buffer [15:0];    //this buffer store the addr of b and j insts
    reg [31:0] bj_target_pc_buffer [15:0];  //this buffer store the b and j target addr
    reg [31:0] pre_bjpc;

    //wire [31:0] pc_id;
    //dffe32 inst_pc      (.d(pc_if),.clk(clk),.rst_n(rst_n),.en(ren),.q(pc_id));

    integer i;
    always @ (ren or pc_if)    begin
        if (ren)    begin
            
            for (i=0;i<16;i=i+1)    begin
                if (bj_inst_pc_buffer[i]==pc_if)    begin
                    pre_bjpc<=bj_target_pc_buffer[i];
                    read_hit<=1'b1;
                    hit<=1'b1;
                    hit_position<=i;
                end
            end
        end
    end

    integer k;
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_hit<=1'b0;
            hit<=1'b0;
            hit_position<=4'h0;
            counter<=5'h00;
            pre_bjpc<=32'h0;
            for (i=0;i<16;i=i+1)    begin
                bj_inst_pc_buffer[i]<=32'h0;
                bj_target_pc_buffer[i]<=32'h0;
            end
        end
        else if (wen)   begin
            if (!counter[4]) begin
                bj_inst_pc_buffer[counter[3:0]]<=pc_id;
                bj_target_pc_buffer[counter[3:0]]<=real_bjpc;
                counter<=counter+1'b1;
            end
            else if (hit) begin
                for (k=0;k<hit_position;k=k+1)    begin
                bj_inst_pc_buffer[k+1]<=bj_inst_pc_buffer[k];
                bj_target_pc_buffer[k+1]<=bj_target_pc_buffer[k];
                end
                bj_inst_pc_buffer[0]<=pc_id;
                bj_target_pc_buffer[0]<=real_bjpc;                    
                hit<=1'b0;
            end
            else if (!hit) begin
                bj_inst_pc_buffer[0]<=pc_id;
                bj_target_pc_buffer[0]<=real_bjpc;
                for (k=0;k<15;k=k+1)    begin
                bj_inst_pc_buffer[k+1]<=bj_inst_pc_buffer[k];
                bj_target_pc_buffer[k+1]<=bj_target_pc_buffer[k];
                end
            end
        end
    end

    always @ (posedge clk)  if (read_hit)   read_hit<=1'b0;

endmodule
