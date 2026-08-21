`timescale 1ns/1ps
module DUT;

parameter FIFO_DEPTH = 8;
parameter DATA_WIDTH = 32;
parameter FIFOHALF = 4;
reg clk,rd_en,wr_en,rst,cs;
reg [DATA_WIDTH-1:0] data_in;
wire [DATA_WIDTH-1:0] data_out;
wire empty,full;
integer k;

FIFOSYNC F1(cs,wr_en,rd_en,clk,rst,data_in,full,empty,data_out);

always #5 clk = ~clk;
initial begin
        clk =0;
        rst =0;
        cs=0;

        rd_en=0;
        wr_en=0;
        $display("Scenario1 checking empty port");
        $display("______________________________");
        //scenario1--------------------------------------------------------------------------
        #2
        $display("time : %d, Empty : %d", $time , empty); //checking empty port

        #10 rst =1;

        $display("================================");
        //scenario2--------------------------------------------------------------------------------
        $display("Scenario2 checking full port port");
        $display("______________________________");
        data_in = 0;
        wr_en = 1;
        cs = 1;

        for (k = 0; k < FIFO_DEPTH; k = k + 1) begin

            data_in = k * 2;

            @(posedge clk);
            #1;

            $display("Time = %0t, FIFO[%0d] = %0d",
                    $time, k, F1.fifo[k]);

        end

        wr_en = 0;

        #1;

        $display("FULL  = %0d", full);
        $display("EMPTY = %0d", empty);
        $display("================================");

        //scenario3-------------------------------------------------------------------------
        $display("Scenario3 Writing after full stack (it doesn't write until read occurs)");
        $display("______________________________________________________________________");

        @(posedge clk)
        wr_en =1;
        $display("================================");
        repeat(2)
        begin
        @(posedge clk)
            data_in = k*3;// writing after full
            $display("Time : %d , FIFOvalue : %d", $time , F1.fifo[0]);
        end
        $display("================================");
        wr_en =0;
        #1 
        rst =0;
        #1
        rst =1;
        //scenario4-------------------------------------------------------------------------
        $display("Scenario4 Writing upto 3 stack and then reading upto 3 stack");
        $display("____________________________________________________________");
        data_in = 0;// first loading data
        wr_en=1;
        for (k = 0; k<FIFOHALF-1; k = k+1) 
        begin
            data_in =  k*4;
            @(posedge clk)
            #1; // necessary so that data load in the fifo and then will watch it in terminal
            $display("Time = %0t, FIFO[%0d] = %0d",
            $time, k, F1.fifo[k]);
        end
        @(posedge clk)
        rd_en =1;// after 3rd clk edge empty should be high and automatically read should
        wr_en =0;// stop and last data out will be 8
        #1
       for (k = 0; k < 3; k = k + 1) begin
            $display("Time : %0t, dataout[%0d] = %0d",
                    $time, k, data_out);
            @(posedge clk);
            #1;
        end
        @(posedge clk)
        $display("FULL  = %0d", full);
        $display("EMPTY = %0d", empty);
        rd_en = 0;
        $display("================================");
        #20 $finish;
end
initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0,DUT);
end

endmodule