`include "CONSTANT.v"

module memory #(parameter WIDTH = 2 ** `WIDTH_BIT) (
    input CLK, input RST, input write_enable, input generated_enable,
    input [`INDEX_BIT-1:0]read1,
    input [`INDEX_BIT-1:0]read2,
    input [`INDEX_BIT-1:0]write,
    input [0:WIDTH-1][0:WIDTH-1][31:0]write_data,
    output [0:WIDTH-1][0:WIDTH-1][31:0]data1,
    output [0:WIDTH-1][0:WIDTH-1][31:0]data2
);
    localparam TOTAL_MATRIXES = 2 ** `INDEX_BIT;
    reg [0:WIDTH-1][0:WIDTH-1][31:0]mem[0:TOTAL_MATRIXES-1];
    initial begin
        for (integer i = 0; i < TOTAL_MATRIXES; i = i + 1) begin
            mem[i] <= 0;
        end
    end

    assign data1 = mem[read1];
    wire [31:0]gen = {{(32-`INDEX_BIT){1'b0}}, read2};
    assign data2 = (generated_enable)? {WIDTH*WIDTH{gen}} : mem[read2];

    always @(posedge CLK or posedge RST) begin
        if(RST)
            for (integer i = 0; i < TOTAL_MATRIXES; i = i + 1) begin
                mem[i] <= 0;
            end
        else if(write_enable)   mem[write] <= write_data;
    end
    // always @(*) begin
    //     if(RST) mem = 0;
    //     else begin
            
            
    //     end
    // end
    // localparam NULL = 32'hFFFFFFFF;
    // localparam MAX_BLOCKS = WIDTH * WIDTH / `BLOCK_SZ;
    // reg [0:`INDEX_BIT-1][0:1][WIDTH-1:0]metadatas;      // n-th matrix, with length(0), width(1) sized 0~2**WIDTH
    // reg [0:`INDEX_BIT-1][0:MAX_BLOCKS-1][31:0]inodes;   // n-th matrix, having MAX_BLOCKS integers, each points to a block num
    
    // reg [31:0] sum;
    // initial begin
    //     sum <= 0;
    //     metadatas   <= 0;
    //     inodes      <= {TOTAL_MATRIXES * MAX_BLOCKS{NULL}};
    // end
    
    // genvar i, j;
    // generate
    //     always @(*) begin
            
    //     end
    // endgenerate
endmodule