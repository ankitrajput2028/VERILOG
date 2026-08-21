module DUT;

    reg clk,start;
    reg [4:0] data_in;
    wire done,Q0,ldA,clrA,sftA,ldQ,sftQ,clrQ,decr,ldcnt,qm1,clrff,ldM,addsub;
    wire [4:0] count;
    wire [7:0] MUL;

    BM B1(ldA,clrA,sftA,ldQ,sftQ,clrQ,decr,ldcnt,data_in,clk,qm1,Q0,clrff,ldM,addsub,count,MUL);
    controller C1(start,count,ldA,clrA,sftA,ldQ,sftQ,clrQ,decr,ldcnt,clk,clrff,Q0,ldM,qm1,addsub,done);

    initial begin
        clk = 1'b0;
        #3 start = 1'b1;
        #500 $finish;
    end

    always #5 clk = ~clk;

    initial begin
        #14 data_in = 11;
        #10 data_in = 6;
    end

    initial begin
        $monitor ("time=%0t done=%b " , $time , done);
        $dumpfile("booth.vcd") ; $dumpvars(0,DUT);
    end
endmodule