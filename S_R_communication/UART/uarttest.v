`timescale 1ns/1ps
module  DUT;
    reg clk,rst,wr_en,clr,rx_en;
    reg [7:0] data_in;
    wire loopback, busy, ready;
    wire[7:0] data_out;


    uart U1(clk,rst,wr_en,clr,rx_en,loopback,data_in,loopback,busy,ready,data_out);

    always #10 clk = ~clk;

    initial begin
        clk = 1'b0;
        data_in = 8'b0;
        clr = 1'b0;
        rst = 1'b1;
        wr_en = 1'b1;
        rx_en = 1'b0;

        #25
        wr_en = 1'b0;
        rx_en = 1'b1;

    end

    always @(posedge ready) begin
        $display("Time : %d , data received : %d ", $time , data_out);
        clr <= 1'b1;
        #20
        clr <= 1'b0;

        if (data_out != data_in) begin
            $display("FAIL : recieved data %d is not same as send data %d", data_out , data_in);
            #10 $finish;
        end
        else begin
            if (data_out == 8'h4) begin
                $display("SUCCESS : the data has been correctly recieved");
                #10000 $finish;
            end

            wr_en <=1'b1;
            #3
            data_in <= data_in +1'b1;
            #17
            wr_en <=1'b0;
        end
    end

    initial begin
        $dumpfile("urt.vcd"); $dumpvars(0,DUT);
    end
    
endmodule