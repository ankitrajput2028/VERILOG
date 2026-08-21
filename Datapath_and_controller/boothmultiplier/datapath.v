`timescale 1ns/1ps
module BM (ldA,clrA,sftA,ldQ,sftQ,clrQ,decr,ldcnt,data_in,clk,qm1,Q0,clrff,ldM,addsub,count,MUL);
    input [4:0] data_in;
    input ldA,clrA,sftA,ldQ,sftQ,clrQ,decr,ldcnt,clrff,ldM,addsub,clk; 
    output qm1,Q0;
    output [9:0] MUL;
    wire [4:0] A,M,Z,Q;
    output [4:0] count;
    assign Q0 = Q[0];

    out ot(MUL,A[4:0],Q[4:0]);
    shiftreg AR(A,Z,A[4],ldA,clrA,sftA,clk);
    shiftreg QL(Q,data_in,A[0],ldQ,clrQ,sftQ,clk);
    CNTR CNT(count,ldcnt,decr,clk);
    PIPO ML(M,data_in,ldM,clk);
    ALU ADSB(Z,A,M,addsub);
    DFF dff(qm1,Q[0],clrff,clk);


endmodule