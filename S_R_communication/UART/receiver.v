module receiver (clk,clr,rx_en,rxclk_enb,rx,data_out,ready);
    input clk,clr,rx_en,rxclk_enb,rx;
    output reg [7:0] data_out;
    output reg ready;

    reg [3:0] sample = 4'b0,index = 4'b0;
    reg [7:0] data;
    reg [1:0] state = idle;

    parameter idle = 2'b00, start = 2'b01, data_state = 2'b10, stop_state = 2'b11;

    initial begin
        ready = 1'b0;
    end

    always @(posedge clk) begin
        if (clr) begin
            ready <= 1'b0;
        end
    end


    always @(posedge clk) begin
        if (rxclk_enb) begin
            case (state)
                idle : begin
                    if (rx_en) begin
                        state <= start;
                    end
                    else
                        ready <= 1'b0;
                end

                start : begin
                    if (sample == 15) begin
                        state <= data_state;
                        data <= 8'b0;
                        sample <= 4'b0;
                        index <= 4'b0;
                    end
                    else if (!rx || sample != 0) begin // rx will change but data will sample after 16 times enb rise 
                        sample <= sample + 1'b1;
                    end
                end

                data_state : begin
                    sample <= sample + 1'b1;
                    if (sample == 8) begin // sampling at the middle of data hence no chance of error
                        data[index] <= rx;
                        index <= index +1'b1; 
                    end
                    if (index == 8 && sample == 15) begin
                        state <= stop_state;
                    end
                end

                stop_state : begin
                    if (rx && sample == 8) begin
                        state <= idle;
                        ready <= 1'b1;
                        sample <= 4'b0;
                        data_out <= data;
                    end
                    else 
                        sample <= sample + 1'b1;
                end
                default: state <= idle;
            endcase
        end
    end
endmodule