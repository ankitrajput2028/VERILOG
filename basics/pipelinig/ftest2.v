module DUT;

    parameter N =10;
    reg [N-1:0] A,B,C,D;
    reg clk;

    wire[N-1:0] F;
    pipe_ex P1(F,A,B,C,D,clk);

    always #5 clk = ~clk;

    initial begin
    clk=0;
    A=0;B=0;C=0;D=0;

    #10
    A=10; B=15; C=10; D=10;

    #10
    A=10; B=10; C=5; D=5;

    #10
    A=5; B=15; C=20; D=5;
    
    #10
    A=10; B=5; C=10; D=5;
    
    #10
    A=10; B=10; C=5; D=10;

    #50

    $finish;
    end

    initial begin
        $monitor("Time: %d,F : %d", $time, F);
        $dumpvars(0,DUT); $dumpfile("dump.vcd");
    end
endmodule