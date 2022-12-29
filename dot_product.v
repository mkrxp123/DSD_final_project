`include "CONSTANT.v"

module matrix_mul #(parameter WIDTH = 2 ** `WIDTH_BIT) (
    input [0:WIDTH-1][0:WIDTH-1][31:0]a,
    input [0:WIDTH-1][0:WIDTH-1][31:0]b,
    output [0:WIDTH-1][0:WIDTH-1][31:0]result
);
    wire [0:WIDTH/2-1][0:WIDTH/2-1][31:0] A, B, C, D, E, F, G, H, M11, M12, M21, M22;
    wire [0:WIDTH/2-1][0:WIDTH/2-1][31:0] T[1:7], temp[1:14];
    genvar i, j;
    generate
        for(i=0; i<WIDTH/2; i = i+1)
        begin
            for(j=0; j<WIDTH/2; j = j+1)
            begin
                assign A[i][j] = a[i][j];
                assign B[i][j] = a[i][j+WIDTH/2];
                assign C[i][j] = a[i+WIDTH/2][j];
                assign D[i][j] = a[i+WIDTH/2][j+WIDTH/2];
                assign E[i][j] = b[i][j];
                assign F[i][j] = b[i][j+WIDTH/2];
                assign G[i][j] = b[i+WIDTH/2][j];
                assign H[i][j] = b[i+WIDTH/2][j+WIDTH/2];
                if(WIDTH > 1)
                begin
                assign result[i][j] = M11[i][j];
                assign result[i][j+WIDTH/2] = M12[i][j];
                assign result[i+WIDTH/2][j] = M21[i][j];
                assign result[i+WIDTH/2][j+WIDTH/2] = M22[i][j];
                end
            end
        end
    endgenerate

    generate    
        if(WIDTH > 1) begin

            element_add #(.WIDTH(WIDTH/2)) add1(A, D, temp[1]);
            element_add #(.WIDTH(WIDTH/2)) add2(E, H, temp[2]);
            matrix_mul #(.WIDTH(WIDTH/2))  mul1(temp[1], temp[2], T[1]);

            element_sub #(.WIDTH(WIDTH/2)) sub1(B, D, temp[3]);
            element_add #(.WIDTH(WIDTH/2)) add3(G, H, temp[4]);
            matrix_mul #(.WIDTH(WIDTH/2))  mul2(temp[3], temp[4], T[2]);

            element_sub #(.WIDTH(WIDTH/2)) sub2(C, A, temp[5]);
            element_add #(.WIDTH(WIDTH/2)) add4(E, F, temp[6]);
            matrix_mul #(.WIDTH(WIDTH/2))  mul3(temp[5], temp[6], T[3]);

            element_sub #(.WIDTH(WIDTH/2)) sub3(G, E, temp[7]);
            matrix_mul #(.WIDTH(WIDTH/2))  mul4(D, temp[7], T[4]);

            element_add #(.WIDTH(WIDTH/2)) add5(A, B, temp[8]);
            matrix_mul #(.WIDTH(WIDTH/2))  mul5(temp[8], H, T[5]);

            element_add #(.WIDTH(WIDTH/2)) add6(C, D, temp[9]);
            matrix_mul #(.WIDTH(WIDTH/2))  mul6(temp[9], E, T[6]);

            element_sub #(.WIDTH(WIDTH/2)) sub4(F, H, temp[10]);
            matrix_mul #(.WIDTH(WIDTH/2))  mul7(A, temp[10], T[7]);
            
            element_add #(.WIDTH(WIDTH/2)) add7(T[1], T[2], temp[11]);
            element_sub #(.WIDTH(WIDTH/2)) sub5(T[4], T[5], temp[12]);
            element_add #(.WIDTH(WIDTH/2)) add8(temp[11], temp[12], M11);

            element_add #(.WIDTH(WIDTH/2)) add9(T[5], T[7], M12);

            element_add #(.WIDTH(WIDTH/2)) add10(T[4], T[6], M21);

            element_add #(.WIDTH(WIDTH/2)) add11(T[1], T[3], temp[13]);
            element_sub #(.WIDTH(WIDTH/2)) sub6(T[7], T[6], temp[14]);
            element_add #(.WIDTH(WIDTH/2)) add12(temp[13], temp[14], M22);
        end
        else
        begin
            element_mul #(.WIDTH(1)) e_mul1(a, b, result);
        end
    endgenerate
endmodule