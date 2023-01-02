`include "CONSTANT.v"

module data_memory #(parameter WIDTH = 2 ** `WIDTH_BIT) (
    input CLK, input RST, input write_enable, input generate_enable,
    input [`INDEX_BIT-1:0]read1,
    input [`INDEX_BIT-1:0]read2,
    input [`INDEX_BIT-1:0]write,
    input [0:WIDTH-1][0:WIDTH-1][31:0]write_data,
    input [28-2*`INDEX_BIT:0]constant,
    output [0:WIDTH-1][0:WIDTH-1][31:0]data1,
    output [0:WIDTH-1][0:WIDTH-1][31:0]data2
);
    localparam TOTAL_MATRIXES = 2 ** `INDEX_BIT;
    reg [2 ** `INDEX_BIT - 1:0][0:WIDTH-1][0:WIDTH-1][31:0] mem;
    reg [0:WIDTH-1][0:WIDTH-1][31:0] data;
    integer n = 0, data_tb, cnt;
    initial begin
        mem = 0;
        data_tb = $fopen("testbench/data.txt", "r");
        while (! $feof(data_tb)) begin
            cnt = $fscanf(data_tb, "%b", data);
            mem[n] = data;
            n = n + 1;
        end
        $fclose(data_tb);
    end

    assign data1 = mem[read1];

    wire padded_constant = {{(3 + 2 * `INDEX_BIT){1'b0}}, constant};
    wire [0:WIDTH-1][0:WIDTH-1][31:0]constant_matrix;
    genvar i, j;
    generate
        for(i = 0; i < WIDTH; i = i + 1)
            for(j = 0; j < WIDTH; j = j + 1)
                assign constant_matrix[i][j] = padded_constant;
    endgenerate
    assign data2 = (generate_enable)? constant_matrix : mem[read2];

    always @(posedge CLK or posedge RST) begin
        if(RST) mem = 0;
        else if(write_enable)   mem[write] <= write_data;
    end
endmodule