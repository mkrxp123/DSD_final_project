`include "CONSTANT.v"

module decoder (
    input [31:0]instruction,
    output PC_src,
    output [`INSTR_BIT-1:0]jump_addr,
    output write_enable,
    output generated_enable,
    output [2:0]sel,
    output [`INDEX_BIT-1:0]read1,
    output [`INDEX_BIT-1:0]read2,
    output [`INDEX_BIT-1:0]write,
    output [28-`INDEX_BIT:0]generated_data,
    output done
);
    // instruction set
    // 000 ~ 101: element_add/sub/mul/div/mod and matrix mul
    // 110: jump, 111: done
    assign PC_src = instruction[31:29] == 3'b110;
    assign jump_addr = instruction[28:29-`INSTR_BIT];
    assign write_enable = instruction[31:30] != 2'b11;
    assign generated_enable = instruction[28-2*`INDEX_BIT:0] != 0;
    assign sel = instruction[31:29];
    assign read1 = instruction[28:29-`INDEX_BIT];
    assign read2 = instruction[28-`INDEX_BIT:29-2*`INDEX_BIT];
    assign write = instruction[28-2*`INDEX_BIT:29-3*`INDEX_BIT];
    assign generated_data = instruction[28-`INDEX_BIT:0];
    assign done = instruction[31:29] == 3'b111;
endmodule