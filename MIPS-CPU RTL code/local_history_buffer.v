module local_history_buffer (clk,rst_n,wen,real_br_taken,his_out);
    input clk,rst_n,wen;
    input real_br_taken;
    output [3:0] his_out;

    reg [3:0] his_out;

    always@(posedge clk or negedge rst_n)   begin
        if (!rst_n) begin
            his_out=4'b0000;
        end
        else if (wen)   begin
            his_out<={his_out[2:0],real_br_taken};
        end
    end

endmodule

