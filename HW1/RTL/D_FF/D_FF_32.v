module D_FF_32(q, d, clk);
    parameter width = 32;
    output [width-1:0] q;
    input  [width-1:0] d;
    input              clk;
    reg    [width-1:0] q;
    always @(posedge clk)
        q <= d;
endmodule