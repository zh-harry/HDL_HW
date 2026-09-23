module adder_structure_reg(s, co, a, b, ci, clk);
    parameter width = 32;
    output [width-1:0] s;
    output             co;
    input  [width-1:0] a, b;
    input              ci, clk;

    wire   [width-1:0] s_tmp;
    wire               co_tmp;

    adder_structure FA_32(s_tmp, co_tmp, a, b, ci);

    D_FF_32 dff_32(s, s_tmp, clk);
    D_FF    dff_co(co, co_tmp, clk);
endmodule