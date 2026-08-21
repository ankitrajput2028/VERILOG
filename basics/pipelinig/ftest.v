module DUT;

    parameter N =10;
    reg [N-1:0] A,B,C,D;
    reg clk;

    wire[N-1:0] F;
    pipe_ex P1(F,A,B,C,D,clk);

    always #5 clk = ~clk;

    initial begin
    clk=0;
    A=0;
    B=0;
    C=0;
    D=0;

    #10
    A=10; B=15; C=10; D=10;

    #40
    $display("%d", F);

    #10

    $finish;
    end

    initial begin
        $dumpvars(0,DUT); $dumpfile("dump.vcd");
    end
endmodule