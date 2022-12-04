`include "CONSTANT.v"

// I guess directly assign result may have overflow issue
// but I haven't tested that case
module element_add #(parameter WIDTH = 2 ** `WIDTH_BIT) (
    input [0:WIDTH-1][0:WIDTH-1][31:0]a,
    input [0:WIDTH-1][0:WIDTH-1][31:0]b,
    output [0:WIDTH-1][0:WIDTH-1][31:0]result
);
    genvar i, j;
    generate
        for(i = 0; i < WIDTH; i = i + 1)
            for(j = 0; j < WIDTH; j = j + 1)
                assign result[i][j] = a[i][j] + b[i][j];
    endgenerate
endmodule

module element_sub #(parameter WIDTH = 2 ** `WIDTH_BIT) (
    input [0:WIDTH-1][0:WIDTH-1][31:0]a,
    input [0:WIDTH-1][0:WIDTH-1][31:0]b,
    output [0:WIDTH-1][0:WIDTH-1][31:0]result
);
    genvar i, j;
    generate
        for(i = 0; i < WIDTH; i = i + 1)
            for(j = 0; j < WIDTH; j = j + 1)
                assign result[i][j] = a[i][j] - b[i][j];
    endgenerate
endmodule

module element_mul #(parameter WIDTH = 2 ** `WIDTH_BIT) (
    input [0:WIDTH-1][0:WIDTH-1][31:0]a,
    input [0:WIDTH-1][0:WIDTH-1][31:0]b,
    output [0:WIDTH-1][0:WIDTH-1][31:0]result
);
    genvar i, j;
    generate
        for(i = 0; i < WIDTH; i = i + 1)
            for(j = 0; j < WIDTH; j = j + 1)
                assign result[i][j] = a[i][j] * b[i][j];
    endgenerate
endmodule

module element_div #(parameter WIDTH = 2 ** `WIDTH_BIT) (
    input [0:WIDTH-1][0:WIDTH-1][31:0]a,
    input [0:WIDTH-1][0:WIDTH-1][31:0]b,
    output [0:WIDTH-1][0:WIDTH-1][31:0]result
);
    genvar i, j;
    generate
        for(i = 0; i < WIDTH; i = i + 1)
            for(j = 0; j < WIDTH; j = j + 1)
                assign result[i][j] = a[i][j] / b[i][j];
    endgenerate
endmodule

module element_mod #(parameter WIDTH = 2 ** `WIDTH_BIT) (
    input [0:WIDTH-1][0:WIDTH-1][31:0]a,
    input [0:WIDTH-1][0:WIDTH-1][31:0]b,
    output [0:WIDTH-1][0:WIDTH-1][31:0]result
);
    genvar i, j;
    generate
        for(i = 0; i < WIDTH; i = i + 1)
            for(j = 0; j < WIDTH; j = j + 1)
                assign result[i][j] = a[i][j] % b[i][j];
    endgenerate
endmodule

module element_op #(parameter WIDTH = 2 ** `WIDTH_BIT) (
    input [0:1][`WIDTH_BIT-1]size_a,
    input [0:1][`WIDTH_BIT-1]size_b,
    input [0:WIDTH-1][0:WIDTH-1][31:0]a,
    input [0:WIDTH-1][0:WIDTH-1][31:0]b,
    input [2:0] op,
    output valid_op,
    output [0:WIDTH-1][0:WIDTH-1][31:0]result
);
    assign valid_op = (size_a[0] == size_b[0]);

    wire [0:4][0:WIDTH-1][0:WIDTH-1][31:0]all_element_result;
endmodule