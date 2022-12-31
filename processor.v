`include "CONSTANT.v"
`include "decoder.v"
`include "ALU.v"

module instr_memory (
    input [31:0]pc,
    output [31:0]instruction
);
    reg [31:0]instr_mem[0:31];
    initial begin
        instr_mem <= 0;
    end
endmodule

module controller (
    input St, input done, output reg enable
);
    initial begin
        enable <= 0;
    end
    always(posedge St or posedge done) begin
        if(St)  enable <= 1;
        else    enable <= 0;
    end
endmodule

module processor #(parameter WIDTH = 2 ** `WIDTH_BIT) (
    input CLK, input jump, input St
);
    reg [31:0] pc;
    initial begin
        pc <= 0;
    end

    wire nxt_pc = pc + 32'd4;

    wire [31:0]instruction;
    instr_memory instr_mem(.pc(pc), .instruction(instruction));


endmodule