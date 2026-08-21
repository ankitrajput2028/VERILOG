`timescale 1ns/1ps
module regbank (clk,write,wrdata,sr1,sr2,dr,rddata1,rddata2);
    input clk,write;
    input [31:0] wrdata;
    input [4:0] sr1,sr2,dr;
    output [31:0] rddata1,rddata2;
    reg [31:0] regfile [31:0];

    assign rddata1 = regfile[sr1];
    assign rddata2 = regfile[sr2];

    always @(posedge clk) begin
        if (write) begin
            regfile [dr] = wrdata;
        end
    end
endmodule


// code for mux 32 X 1
/* 
    input [4:0] sel;
    input [31:0] X;
    output Y;
    
    assign Y = X[sel];
*/