module float_regfile (rna,rnb,wex,wey,wnx,wny,dx,dy,qa,qb,clk,rst_n);
    input clk,rst_n;
    input [4:0] rna,rnb;
    input wex,wey;
    input [4:0] wnx,wny;
    input [31:0] dx,dy;
    output [31:0] qa,qb;

    reg [31:0] registers [31:0];

    assign qa=registers[rna];
    assign qb=registers[rnb];

    integer i;
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i=0;i<32;i=i+1) registers[i]<=32'h0000_0000;
        end
        else begin
            if (wey)    
                registers[wny]<=dy;             //y has a higher priority than x
            else if (wex&&(!wey||(wnx!=wny)))   
                registers[wnx]<=dx; 
        end
    end
endmodule


