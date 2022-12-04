`include "element_op.v"

module tb ();
    reg [0:7][0:7][31:0]a;
    reg [0:7][0:7][31:0]b;
    wire [0:7][0:7][31:0]result;
    element_add #(.WIDTH(8)) add (.a(a), .b(b), .result(result));
    integer i, j;
    initial begin
        $dumpfile("tb.vcd"); // Set the name of the dump file.
        $dumpvars;           // Save all signals to the dump file.
        a = 0;
        b = 0;
        #10;
        a[0][1] = 32'd1;
        a[1][0] = 32'd2;
        a[1][1] = 32'd3;
        b[0][1] = 32'd1;
        b[1][0] = 32'd2;
        b[1][1] = 32'd3;
    end
    always@(result) begin
        $display("%2d %1d %1d %1d %1d", $time, result[0][0], result[0][1], result[1][0], result[1][1]);
    end
endmodule