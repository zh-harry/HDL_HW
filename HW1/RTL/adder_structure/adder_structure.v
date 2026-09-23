module adder_structure(s, co, a, b, ci);
    parameter width = 32;
    output [width-1:0] s;
    output             co;
    input  [width-1:0] a, b;
    input              ci;
    
    wire   [width:0]   c;

    assign c[0] = ci;

    genvar i;
    generate
        for(i=0; i<=width-1; i=i+1) begin: generate_FA32
            FA fa(s[i], c[i+1], a[i], b[i], c[i]);
        end
    endgenerate

    assign co = c[width];
endmodule