`timescale 1ns/1ps
module DUT;

reg clk1,clk2;
integer k;

pipe_mips32 mips(clk1,clk2);

initial
begin
    clk1 = 0; clk2 =0;
    repeat(20)
    begin
        #5 clk1 = 1; #5 clk1 =0;
        #5 clk2 = 1; #5 clk2 =0;
    end
end

initial
begin
    for (k = 2; k<64; k = k + 1) begin
        mips.REG[k] = k;
    end
    mips.REG[0] = 0;
    mips.REG[1] = 0;
    /*mips.mem[0] = 32'h00430800; //ADD R1,R2,R3 0000 0000 0100 0011 0000 1000 0000 0000
    mips.mem[1] = 32'h04430800; //SUB R1,R2,R3 0000 0100 0100 0011 0000 1000 0000 0000
    mips.mem[2] = 32'h2841000A; //ADDI R1,R2,10 0010 1000 0100 0001 0000 0000 0000 1010
    mips.mem[3] = 32'h09631800; //OR R3,R3,R3 0000 1100 0110 0011 0001 1000 0000 0000
    mips.mem[4] = 32'h24410014; //SW R1,20(R2) 0010 0100 0100 0001 0000 0000 0001 0100
    mips.mem[5] = 32'hFC000000; //HLT
*/
    mips.mem[0] = 32'h00430800; //ADD R1,R2,R3 0000 0000 0100 0011 0000 1000 0000 0000
    mips.mem[1] = 32'h04630800; //SUB R1,R3,R3 0000 0100 0110 0011 0000 1000 0000 0000 // give time to update R1
    mips.mem[2] = 32'h09631800; //OR R3,R3,R3 0000 1100 0110 0011 0001 1000 0000 0000 [Empty instr.]
    mips.mem[3] = 32'h38200003; // BEQZ R1 0011 1000 0010 0000  0000 0000 0000 0011
    mips.mem[4] = 32'h09631800; //OR R3,R3,R3 0000 1100 0110 0011 0001 1000 0000 0000 [Empty instr.]
    mips.mem[5] = 32'h2841000A; //ADDI R1,R2,10 0010 1000 0100 0001 0000 0000 0000 1010
    mips.mem[6] = 32'h09631800; //OR R3,R3,R3 0000 1100 0110 0011 0001 1000 0000 0000
    mips.mem[7] = 32'h24410014; //SW R4,20(R2) 0010 0100 0100 0100 0000 0000 0001 0100
    mips.mem[8] = 32'hFC000000; //HLT 

    mips.PC = 0;
    mips.HALTED = 1'b0;
    mips.TAKEN_BRANCH = 1'b0;

    #400 $finish;
end

initial
begin
    $monitor("Time : %d, reg[1] : %d, val = %d, mem val : %d", $time, mips.REG[1], mips.EX_MEM_ALU, mips.mem[22]);
    $dumpfile("dump.vcd");
    $dumpvars(0,DUT);
end

endmodule