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
    wire signed [0:WIDTH-1][0:WIDTH-1][31:0]result;
    reg signed [0:WIDTH-1][0:WIDTH-1][31:0]ans[2**`INSTR_BIT-1:0];
    reg [0:WIDTH-1][0:WIDTH-1][31:0]ans_;
    processor #(.WIDTH(WIDTH)) processor(CLK, jump, St, RST, done, result);

    integer i = 0, instr_tb, cnt;
    initial begin
        $dumpfile("tb.vcd"); // Set the name of the dump file.
        $dumpvars;           // Save all signals to the dump file.
        
        @(posedge CLK)
        @(negedge CLK)
        St = 1;
        @(posedge CLK)
        St = 0;
        #200;
        $finish;
    end

    integer ans_tb;
    initial begin
        ans_tb = $fopen("testbench/ans.txt", "r");
        while (! $feof(ans_tb)) begin
            cnt = $fscanf(ans_tb, "%b", ans_);
            ans[i] = ans_;
            i = i + 1;
        end
        $fclose(ans_tb);
    end
    initial begin
        for(i = 0; i<10; i = i+1)begin
            @(negedge CLK)
            #1
            $display("ans:");
            $display("%5d %5d %5d %5d", $time, ans[i][0][0], ans[i][0][1], ans[i][0][2], ans[i][0][3]);
            $display("%5d %5d %5d %5d", $time, ans[i][1][0], ans[i][1][1], ans[i][1][2], ans[i][1][3]);
            $display("%5d %5d %5d %5d", $time, ans[i][2][0], ans[i][2][1], ans[i][2][2], ans[i][2][3]);
            $display("%5d %5d %5d %5d", $time, ans[i][3][0], ans[i][3][1], ans[i][3][2], ans[i][3][3]);
            $display();
            $display("result:");
            $display("%5d %5d %5d %5d", $time, result[0][0], result[0][1], result[0][2], result[0][3]);
            $display("%5d %5d %5d %5d", $time, result[1][0], result[1][1], result[1][2], result[1][3]);
            $display("%5d %5d %5d %5d", $time, result[2][0], result[2][1], result[2][2], result[2][3]);
            $display("%5d %5d %5d %5d", $time, result[3][0], result[3][1], result[3][2], result[3][3]);
            $display();
        end
    end
    
endmodule