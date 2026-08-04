module transmitter (clk,rst,wr_en,txclk_enb,data_in,tx,busy);

    input clk,rst,wr_en,txclk_enb;
    input [7:0] data_in;
    output reg tx;
    output busy;

    reg [7:0] data;
    reg [1:0] state = idle;
    reg [2:0] index = 3'b0; // check

    parameter idle = 2'b00, start = 2'b01, data_state = 2'b10, stop_state = 2'b11;

    initial begin
        tx = 1'b1;
    end

    always @(posedge clk) begin
        if(!rst)
        begin
            tx <= 1'b1;
            state <= idle;
            index <= 3'b0;
            data <= 8'b0;
        end

        else begin
            case (state)
                idle: begin
                    if (wr_en) begin
                        state <= start;
                        data <= data_in;
                    end
                    else
                        tx <= 1'b1;
                end

                start : begin
                    if (txclk_enb) begin
                        tx <= 1'b0;
                        state <= data_state;
                    end
                end

                data_state : begin
                    if (txclk_enb) begin
                        tx <= data[index];
                        index <= index +1'b1;
                        if (index == 3'h7) begin
                            state <= stop_state;
                        end
                    end
                end

                stop_state : begin
                    if (txclk_enb) begin
                        tx <= 1'b1;
                        state <= idle;
                    end
                end
                
                default: state <= idle;
            endcase
        end
    end

    assign busy = (state != idle);

endmodule