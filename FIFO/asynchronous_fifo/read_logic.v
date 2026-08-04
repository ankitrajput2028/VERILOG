module readptr (clk,rrst,rinc,wptr_g,empty,raddr_g,rptr_b);
    input clk,rrst,rinc;
    input [3:0] wptr_g;
    output empty;
    output [3:0] raddr_g,rptr_b;

    reg [3:0] rbin,rgray;
    wire [3:0] rbin_next,rgray_next;

    always @(posedge clk or negedge rrst) begin
        if (!rrst) begin
            {rbin,rgray} <= 0;
        end
        else begin
            rbin <= rbin_next;
            rgray <= rgray_next;
        end
    end

    assign empty = (wptr_g == rgray);
    assign rbin_next = rbin + (rinc && !empty);
    assign rgray_next = (rbin_next >> 1) ^ (rbin_next);
    assign raddr_g = rgray;
    assign rptr_b = rbin;
endmodule