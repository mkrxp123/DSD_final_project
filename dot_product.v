`include "CONSTANT.v"

module matrix_mul #(parameter WIDTH = 2 ** `WIDTH_BIT) (
    input [0:WIDTH-1][0:WIDTH-1][31:0]a,
    input [0:WIDTH-1][0:WIDTH-1][31:0]b,
    output [0:WIDTH-1][0:WIDTH-1][31:0]result
);
    
endmodule