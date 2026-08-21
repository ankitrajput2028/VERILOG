module FIFO(rclk,wclk,rinc,wr_en,wrst,rrst,wr_data,rd_data);

    input rclk,wclk,rinc,wr_en,wrst,rrst;
    input [31:0] wr_data;
    output [31:0] rd_data;

    wire [3:0] wptr_b,rptr_b,w2rptr_g,r2wptr_g,wptr_g,rptr_g;
    
    fifomem memry (wclk,rclk,full,empty,rinc,wr_en,wr_data,wptr_b[2:0],rd_data,rptr_b[2:0]);
    synchronisor w2r (rclk,rrst,w2rptr_g,wptr_g);
    synchronisor r2w (wclk,wrst,r2wptr_g,rptr_g);
    readptr read_block (rclk,rrst,rinc,wptr_g,empty,r2wptr_g,rptr_b);
    writeptr write_block (wclk,wrst,wr_en,rptr_g,full,w2rptr_g,wptr_b);
endmodule