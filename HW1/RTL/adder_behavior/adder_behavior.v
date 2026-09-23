module adder_behavior(s, co, a, b, ci);
    parameter width = 32;
    output [width-1:0] s;
    output             co;
    input  [width-1:0] a, b;
    input              ci;

    reg    [width-1:0] s;
    reg                co;

    always @(*) begin
        {co, s} = a + b + ci;
    end
endmodule