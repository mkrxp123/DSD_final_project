`include "CONSTANT.v"
`include "decoder.v"
`include "data_memory.v"
`include "ALU.v"

module instr_memory (input [`INSTR_BIT-1:0]pc, output [31:0]instruction);
    reg [2**`INSTR_BIT-1:0][31:0]instr_mem;
    reg [31:0]instr;
    integer i = 0, instr_tb, cnt;
    initial begin
        instr_mem = 0;
        instr_tb = $fopen("testbench/instructions.txt", "r");
        while (! $feof(instr_tb)) begin
            cnt = $fscanf(instr_tb, "%b", instr);
            instr_mem[i] = instr;
            i = i + 1;
        end
        $fclose(instr_tb);
    end
    assign instruction = instr_mem[pc];
endmodule

module controller (input St, input done, output reg enable);
    initial begin
        enable <= 0;
    end
    always @(posedge St or posedge done) begin
        if(St)  enable <= 1;
        else    enable <= 0;
    end
endmodule

module processor #(parameter WIDTH = 2 ** `WIDTH_BIT) (
    input CLK, input jump, input St, input RST, output done, output [0:WIDTH-1][0:WIDTH-1][31:0]result
);
    wire done, enable;
    controller ctrl(St, done, enable);

    reg [`INSTR_BIT-1:0]pc;
    initial begin
        pc <= 0;
    end
    wire PC_src;
    wire [`INSTR_BIT-1:0]nxt_pc = pc + 1;
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
    wire [28-3*`INDEX_BIT:0]constant;
    decoder instr_decoder(instruction, PC_src, jump_addr, write_enable, generated_enable,
                          sel, read1, read2, write, constant, done);

    wire signed[0:WIDTH-1][0:WIDTH-1][31:0]write_data;
    wire signed[0:WIDTH-1][0:WIDTH-1][31:0]data1;
    wire signed[0:WIDTH-1][0:WIDTH-1][31:0]data2;
    data_memory #(.WIDTH(WIDTH)) data_memory(CLK, RST, write_enable & enable, generated_enable, 
                                             read1, read2, write, write_data, constant, data1, data2);

    ALU #(.WIDTH(WIDTH)) ALU(data1, data2, sel, write_data);
    always@(negedge CLK)begin
        if(sel >= 0 & sel <= 7)
        begin
            $display("op: %3b time: %5d", sel, $time);
            $display("data1:");
            $display("%6d %6d %6d %6d", data1[0][0], data1[0][1], data1[0][2], data1[0][3]);
            $display("%6d %6d %6d %6d", data1[1][0], data1[1][1], data1[1][2], data1[1][3]);
            $display("%6d %6d %6d %6d", data1[2][0], data1[2][1], data1[2][2], data1[2][3]);
            $display("%6d %6d %6d %6d", data1[3][0], data1[3][1], data1[3][2], data1[3][3]);
            $display();
            $display("data2:");
            $display("%6d %6d %6d %6d", data2[0][0], data2[0][1], data2[0][2], data2[0][3]);
            $display("%6d %6d %6d %6d", data2[1][0], data2[1][1], data2[1][2], data2[1][3]);
            $display("%6d %6d %6d %6d", data2[2][0], data2[2][1], data2[2][2], data2[2][3]);
            $display("%6d %6d %6d %6d", data2[3][0], data2[3][1], data2[3][2], data2[3][3]);
            $display();
        end
    end
    
    assign result = write_data;
endmodule