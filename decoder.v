`include "CONSTANT.v"
module decoder (
    input [31:0]instruction,
    output [2:0]sel,
    output [`INDEX_BIT-1:0]read1,
    output [`INDEX_BIT-1:0]read2,
    output [`INDEX_BIT-1:0]write,
);
    
endmodule