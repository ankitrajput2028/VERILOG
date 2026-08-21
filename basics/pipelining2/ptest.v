`timescale 1ns/1ps
module DUT;
    reg [3:0] rs1,rs2,func,rd;
    reg [7:0] addr;
    reg clk1,clk2,wr;
    wire [15:0] Z;
    integer k;
    pipe_ex2 P1(rs1,rs2,rd,func,addr,clk1,clk2,wr,Z);

    initial 
    begin
    clk1=0; clk2 =0;
    repeat(20)
    begin
        #5 clk1 = 1; #5 clk1 =0;
        #5 clk2 = 1; #5 clk2 =0;
    end
    end

    initial 
    begin
        for (k=0 ; k<16; k=k+1 ) 
        begin
            P1.R[k] = k;
        end    
    end

    initial
    begin
        wr =1'b0;
        rs1 = 4'b0000;
        rs2 = 4'b0000;
        rd = 4'b0000;
        addr = 8'b00000000;
        func = 4'b0000;

        #1
        wr =1'b1;
        rs1 = 4'b0000;
        rs2 = 4'b0001;
        rd = 4'b1010;
        addr = 8'b01010101;
        func = 4'b0000;//add

        #20
        rs1 = 4'b0010;
        rs2 = 4'b0011;
        rd = 4'b1011;
        addr = 8'b01010111;
        func = 4'b0001;//sub
        
        #20
        rs1 = 4'b0100;
        rs2 = 4'b0101;
        rd = 4'b1100;
        addr = 8'b01010110;
        func = 4'b0010;//MUL
        
        #20
        rs1 = 4'b0110;
        rs2 = 4'b0111;
        rd = 4'b1101;
        addr = 8'b01010100;
        func = 4'b0011;//SELA
        
        #20
        rs1 = 4'b1000;
        rs2 = 4'b1001;
        rd = 4'b1110;
        addr = 8'b01010001;
        func = 4'b0100;//SELB

        #120
        $finish;
    end

        initial begin
            $monitor("Time : %d, Z : %d", $time , Z);
            $dumpvars(0,DUT); $dumpfile("dump.vcd");
        end

endmodule