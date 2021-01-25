module four_16_decoder (a,b);
    input [3:0] a;
    output [15:0] b;

    reg [15:0] b;
    always @ (*)    begin
        case (a)
        4'h0:b=16'b0000_0000_0000_0001;
        4'h1:b=16'b0000_0000_0000_0010;
        4'h2:b=16'b0000_0000_0000_0100;
        4'h3:b=16'b0000_0000_0000_1000;
        4'h4:b=16'b0000_0000_0001_0000;
        4'h5:b=16'b0000_0000_0010_0000;
        4'h6:b=16'b0000_0000_0100_0000;
        4'h7:b=16'b0000_0000_1000_0000;
        4'h8:b=16'b0000_0001_0000_0000;
        4'h9:b=16'b0000_0010_0000_0000;
        4'ha:b=16'b0000_0100_0000_0000;
        4'hb:b=16'b0000_1000_0000_0000;
        4'hc:b=16'b0001_0000_0000_0000;
        4'hd:b=16'b0010_0000_0000_0000;
        4'he:b=16'b0100_0000_0000_0000;
        4'hf:b=16'b1000_0000_0000_0000;
        endcase
    end
endmodule
