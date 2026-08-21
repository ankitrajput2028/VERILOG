module uart (clk,rst,wr_en,clr,rx_en,rx,data_in,tx,busy,ready,data_out);
    input clk,rst,wr_en,clr,rx_en,rx;
    input [7:0] data_in;
    output tx,busy,ready;
    output [7:0] data_out;

    wire tx2;

    assign tx2 = tx;

    wire tx_enb,rx_enb;
    

    transmitter trans (clk,rst,wr_en,tx_enb,data_in,tx,busy);
    receiver recieve (clk,clr,rx_en,rx_enb,rx,data_out,ready);
    bd_gen bd (clk,tx_enb,rx_enb);

endmodule