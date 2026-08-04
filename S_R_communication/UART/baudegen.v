module bd_gen (clk,tx_en,rx_en);
    input clk;
    output tx_en,rx_en;

    reg [12:0] tx_counter = 0;
    reg [9:0] rx_counter = 0;

    always @(posedge clk) begin
        if (tx_counter == 5208) begin //calulated 
            tx_counter = 0;
        end
        else 
            tx_counter <= tx_counter + 1'b1;
    end

    always @(posedge clk) begin
        if (rx_counter == 325) begin //calculated
            rx_counter =0;
        end
        else
            rx_counter <= rx_counter + 1'b1;
    end

    assign tx_en = (tx_counter == 0) ? 1'b1 : 1'b0;
    assign rx_en = (rx_counter == 0) ? 1'b1 : 1'b0;


endmodule