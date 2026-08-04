module RGY(clock, light);
input clock;
output reg[0:2] light;
parameter S0=0, S1=1, S2=2;
parameter red=3'b100, green=3'b010, yellow=3'b001;
reg[1:0] state;

always @(posedge clock) //use of clk posedge to instantiate state suggest flip flop(sequential - <=)
    case(state)
    S0 : state <= S1;
    S1 : state <= S2;
    S2 : state <= S0;
    default : state <= S0;
    endcase
    
always @(state) // state changes the colour should change hence it acts as mux 8*1
    case(state)
    S0 : light = red;
    S1 : light = green;
    S2 : light = yellow;
    default : light = red;
    endcase
endmodule
