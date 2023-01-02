`include "CONSTANT.v"
`include "processor.v"

module tb ();
    real CYCLE = 20;
    reg CLK, St, RST, jump;
    reg [31:0]instruction;
    initial CLK = 0;
    initial St = 0;
    always #(CYCLE/2.0) CLK = ~CLK;
    
    localparam WIDTH = 2 ** `WIDTH_BIT;
    wire done;
    wire [0:WIDTH-1][0:WIDTH-1][31:0]result;
    processor #(.WIDTH(WIDTH)) processor(CLK, jump, St, RST, done, result);

    integer i = 0, instr_tb, cnt;
    initial begin
        $dumpfile("tb.vcd"); // Set the name of the dump file.
        $dumpvars;           // Save all signals to the dump file.
        #10;
        

        $finish;
    end
endmodule