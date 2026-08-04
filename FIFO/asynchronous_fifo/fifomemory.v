module fifomem (wclk,rclk,full,empty,rinc,wr_en,wr_data,wr_ptr_b,rd_data,rd_ptr_b);
    input rclk,wclk,full,empty,rinc,wr_en;
    input [31:0] wr_data;
    input [2:0] wr_ptr_b;
    output reg [31:0] rd_data;
    input [2:0] rd_ptr_b;

    reg [31:0] mem [0:7];

    always @(posedge wclk) begin
        if(!full && wr_en)
        mem[wr_ptr_b] <= wr_data;
    end

    always @(posedge rclk) begin
        if(!empty && rinc)
        rd_data <= mem[rd_ptr_b];
    end
endmodule