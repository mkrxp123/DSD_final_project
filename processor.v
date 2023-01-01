`include "CONSTANT.v"
`include "decoder.v"
`include "data_memory"
`include "ALU.v"

module instr_memory (input [`INSTR_BIT-1:0]pc, output [31:0]instruction);
    reg [31:0]instr_mem[`INSTR_BIT-1:0];
    initial begin
        instr_mem <= 0;
    end
    assign instruction = instr_mem[pc];
endmodule

module controller (input St, input done, output reg enable);
    initial begin
        enable <= 0;
    end
    always(posedge St or posedge done) begin
        if(St)  enable <= 1;
        else    enable <= 0;
    end
endmodule

module processor #(parameter WIDTH = 2 ** `WIDTH_BIT) (
    input CLK, input jump, input St, input RST
);
    wire done, enable;
    controller ctrl(St, done, enable);

    reg [`INSTR_BIT-1:0] pc;
    initial begin
        pc <= 0;
    end
    wire PC_src;
    wire nxt_pc = pc + (`INSTR_BIT-1)'d4;
    wire [`INSTR_BIT-1:0]jump_addr;
    always @(posedge CLK) begin
        if(enable)
            pc <= (PC_src & jump)? jump_addr : nxt_pc;
    end

    wire [31:0]instruction;
    instr_memory instr_mem(.pc(pc), .instruction(instruction));

    wire write_enable, generated_enable;
    wire [2:0]sel;
    wire [`INDEX_BIT-1:0]read1;
    wire [`INDEX_BIT-1:0]read2;
    wire [`INDEX_BIT-1:0]write;
    wire [28-`INDEX_BIT:0]generated_data;
    decoder instr_decoder(instruction, PC_src, jump_addr, write_enable & enable, generated_enable,
                          sel, read1, read2, write, generated_data, done);

    wire [0:WIDTH-1][0:WIDTH-1][31:0]write_data;
    wire [0:WIDTH-1][0:WIDTH-1][31:0]data1;
    wire [0:WIDTH-1][0:WIDTH-1][31:0]data2;
    data_memory #(.WIDTH(WIDTH)) data_memory(CLK, RST, write_enable, read1, read2, 
                                             write, write_data, data1, data2);

    wire sencond_data = (generated_enable)? {{(3 + `INDEX_BIT){1'b0}}, generated_data} : data2;
    ALU #(.WIDTH(WIDTH)) ALU(data1, second_data, sel, write_data);
endmodule