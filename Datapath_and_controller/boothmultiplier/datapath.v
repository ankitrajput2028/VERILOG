`timescale 1ns/1ps
module BM (ldA,clrA,sftA,ldQ,sftQ,clrQ,decr,ldcnt,data_in,clk,qm1,clrff,ldM,addsub);
    input [15:0] data_in;
    input ldA,clrA,sftA,ldQ,sftQ,clrQ,decr,ldcnt,clrff,ldM,addsub; 
    output qm1;
    wire [15:0] A,M,Z,Q;
    wire [4:0] count;


endmodule