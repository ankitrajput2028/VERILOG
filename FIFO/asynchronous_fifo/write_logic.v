module writeptr (wclk,wrst,wr_en,rptr_g,full,waddr_g,wptr_b);
    input wclk,wrst,wr_en;
    input [3:0] rptr_g;
    output full;
    output [3:0] waddr_g,wptr_b;

    reg [3:0] wbin,wgray;
    wire [3:0] wbin_next,wgray_next;

    always @(posedge wclk or negedge wrst) begin
        if (!wrst) begin
            {wbin,wgray} <= 0;
        end
        else begin
            {wbin,wgray} <= {wbin_next,wgray_next};
        end
    end

    assign wbin_next = wbin + (wr_en && !full);
    assign wgray_next = (wbin_next >> 1) ^ (wbin_next);
    assign waddr_g = wgray;
    assign wptr_b = wbin;

    assign full = ((wgray[1:0] == rptr_g [1:0]) && (~wgray[3:2] == rptr_g [3:2]));
endmodule