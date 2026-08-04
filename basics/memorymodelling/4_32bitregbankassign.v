`timescale 1ns/1ps

module reg_bnk(rddata1,rddata2,sr1,sr2,clk,dr,write,wrdata);
    input clk,write;
    input [31:0] wrdata;
    input [1:0] sr1,sr2,dr;
    output [31:0] rddata1, rddata2;
    reg[31:0] R[0:3];

    assign rddata1 = (sr1==0) ? R[0] :
                     (sr1==1) ? R[1] :
                     (sr1==2) ? R[2] :
                     (sr1==3) ? R[3] : 0;

    assign rddata2 = (sr2==0) ? R[0] :
                     (sr2==1) ? R[1] :
                     (sr2==2) ? R[2] :
                     (sr2==3) ? R[3] : 0;

    always @(posedge clk) begin
        if (write) begin
            case (dr)
                0: R[0] <= wrdata;
                1: R[1] <= wrdata;
                2: R[2] <= wrdata;
                3: R[3] <= wrdata;
            endcase
        end
    end
endmodule