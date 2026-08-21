`timescale 1ns/1ps
module FIFOSYNC (cs,wr_en,rd_en,clk,rst,data_in,full,empty,data_out);
    parameter FIFO_DEPTH = 8;
    parameter DATA_WIDTH = 32;
    parameter FIFO_DEPTHLOG = $clog2(FIFO_DEPTH);

    input cs,wr_en,rd_en,clk,rst;
    input [DATA_WIDTH -1:0] data_in;
    output full,empty;
    output reg [DATA_WIDTH -1:0] data_out;

    reg [DATA_WIDTH-1:0] fifo[FIFO_DEPTH-1 :0];
    reg [FIFO_DEPTHLOG:0] wr_addr;
    reg [FIFO_DEPTHLOG:0] rd_addr;

    assign empty = (wr_addr == rd_addr);
    assign full = ((wr_addr[FIFO_DEPTHLOG] == ~rd_addr[FIFO_DEPTHLOG]) 
                    && (wr_addr[FIFO_DEPTHLOG-1:0] == rd_addr[FIFO_DEPTHLOG-1:0]));

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            wr_addr <= 0;
        end
        else if(cs && wr_en && !full)
        begin
            fifo[wr_addr[FIFO_DEPTHLOG-1:0]] <= data_in;
            wr_addr <=  wr_addr +1;
        end
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            rd_addr <= 0;
        end
        else if(cs && rd_en && !empty)
        begin
            data_out <= fifo[rd_addr[FIFO_DEPTHLOG-1:0]];
            rd_addr <= rd_addr +1;
        end
    end

endmodule