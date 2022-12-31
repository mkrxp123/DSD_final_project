`include "CONSTANT.v"
`include "element_op.v"
`include "dot_product.v"
// sel:
//  0: element_add
//  1: element_sub
//  2: element_mul
//  3: element_div
//  4: element_mul
//  5: matrix_mul
module ALU #(parameter WIDTH = 2 ** `WIDTH_BIT) (
    input signed[0:WIDTH-1][0:WIDTH-1][31:0]a,
    input signed[0:WIDTH-1][0:WIDTH-1][31:0]b,
    input [2:0]sel,
    output signed[0:WIDTH-1][0:WIDTH-1][31:0] result
);  
    reg result;
    wire signed [0:WIDTH-1][0:WIDTH-1][31:0]e_add_r, e_sub_r, e_mul_r, e_div_r, e_mod_r, mul_r;
    element_add #(.WIDTH(WIDTH)) e_add(a, b, e_add_r);
    element_sub #(.WIDTH(WIDTH)) e_sub(a, b, e_sub_r);
    element_mul #(.WIDTH(WIDTH)) e_mul(a, b, e_mul_r);
    element_div #(.WIDTH(WIDTH)) e_div(a, b, e_div_r);
    element_mod #(.WIDTH(WIDTH)) e_mod(a, b, e_mod_r);
    matrix_mul #(.WIDTH(WIDTH)) mul(a, b, mul_r);
    always@(sel, e_add_r, e_sub_r, e_mul_r, e_div_r, e_mod_r, mul_r)
    begin
        case(sel)
            0: result <= e_add_r;
            1: result <= e_sub_r;
            2: result <= e_mul_r;
            3: result <= e_div_r;
            4: result <= e_mod_r;
            5: result <= mul_r;
        endcase
    end
endmodule