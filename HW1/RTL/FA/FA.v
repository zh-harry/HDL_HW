module FA(sum, c_out, a, b, c_in);
    output sum;
    output c_out;
    input  a, b;
    input  c_in;
    wire   c1, s1, s2;

    and A1(c1, a, b);
    and A2(s2, s1, c_in);
    xor X1(s1, a, b);
    xor X2(sum, s1, c_in);
    xor X3(c_out, s2, c1);
endmodule