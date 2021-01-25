module two_bit_sat_counter (clk,rst_n,en,real_br_taken,pre_taken);
    input clk,rst_n,en;
    input real_br_taken;        //the branch inst real result   1:taken 0:not taken
    output pre_taken;   //the prediction of branch inst result

    reg [1:0] state,next_state;

    parameter taken=1'b1;
    parameter not_taken=1'b0;
    parameter strongly_not_taken=2'b00;
    parameter weakly_not_taken=2'b01;
    parameter weakly_taken=2'b10;
    parameter strongly_taken=2'b11;

    assign pre_taken=state[1];

    always @ (state or en) begin
        //if (en) begin
            case(state)
            strongly_not_taken: begin   
                                if (en) next_state=real_br_taken?weakly_not_taken:strongly_not_taken;
                                else next_state=strongly_not_taken;
                                end
            weakly_not_taken:   begin
                                if (en) next_state=real_br_taken?weakly_taken:strongly_not_taken;
                                else next_state=weakly_not_taken;
                                end
            weakly_taken:       begin
                                if (en) next_state=real_br_taken?strongly_taken:weakly_not_taken;
                                else next_state=weakly_taken;
                                end
            strongly_taken:     begin
                                if (en) next_state=real_br_taken?strongly_taken:weakly_taken;
                                else next_state=strongly_taken;
                                end
            endcase                 
        //end
    end

    always @ (posedge clk) begin
        if (!rst_n) begin
            state<=weakly_not_taken;
        end
        else state<=next_state;
    end

endmodule