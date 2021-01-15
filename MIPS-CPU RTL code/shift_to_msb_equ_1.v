module shift_to_msb_equ_1 (a,b,shamt);
    input [23:0] a;
    output [23:0] b;
    output [4:0] shamt;
    
    wire [23:0] z5,z4,z3,z2,z1,z0;
    wire [4:0] zeros;
    assign z5=a;

    assign zeros[4]=~|z5[23:08];
    assign z4=zeros[4]?{z5[07:0],16'b0}:z5;
    assign zeros[3]=~|z4[23:16];
    assign z3=zeros[3]?{z4[15:0],8'b0}:z4;
    assign zeros[2]=~|z3[23:20];
    assign z2=zeros[2]?{z3[19:0],4'b0}:z3;
    assign zeros[1]=~|z2[23:22];
    assign z1=zeros[1]?{z2[21:0],2'b0}:z2;
    assign zeros[0]=~|z1[23];
    assign z0=zeros[0]?{z1[22:0],1'b0}:z1;

    assign b=z0;
    assign shamt=zeros; 
endmodule