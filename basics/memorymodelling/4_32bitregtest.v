`timescale 1ns/1ps
module DUT;

    reg clk,write;
    reg [4:0] sr1,sr2,dr;
    reg [31:0] wrdata;

    wire [31:0] rddata1, rddata2;

    regbank R1(clk,write,wrdata,sr1,sr2,dr,rddata1,rddata2);

    always #5 clk = ~clk;

    initial begin
    clk = 0;
    write =0;
    sr1=0;
    sr2=0;
    dr=0;
    wrdata=0;

    #10
    write = 1;
    wrdata = 32'h100;
    
    #10
    dr =1;
    wrdata = 32'h200;

    #10
    dr =2;
    wrdata = 32'h300;

    #10
    dr =3;
    wrdata = 32'h400;

    #10
    write =0;
    sr1 = 0;
    sr2 = 1;

    #1
    $display("%d", rddata1);
    $display("%d", rddata2);

    #10
    sr1 = 2;
    sr2 = 3;

    #1
    $display("%d", rddata1);
    $display("%d", rddata2);

    #10
    $finish;
    end
    initial begin
        $dumpvars(0,DUT); $dumpfile("dump.vcd");
    end
endmodule