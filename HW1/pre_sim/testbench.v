`timescale 1ns/10ps

`define CYCLE 50.0
`define DATA_NUM 10

module testbench();
    parameter width = 32;
    reg              CLK;
    reg  [width-1:0] a;
    reg  [width-1:0] b;
    reg              ci;
    reg  [width-1:0] s_ans;
    reg              co_ans;
    wire [width-1:0] s_structure, s_dataflow, s_behavior,
                     s_structure_reg, s_dataflow_reg, s_behavior_reg;
    wire             co_structure, co_dataflow, co_behavior,
                     co_structure_reg, co_dataflow_reg, co_behavior_reg;    

    adder_structure     adder1     (.s(s_structure), .co(co_structure), .a(a), .b(b), .ci(ci));
    adder_structure_reg adder_reg_1(.s(s_structure_reg), .co(co_structure_reg), .a(a), .b(b), .ci(ci), .clk(CLK));
    
    adder_dataflow      adder2     (.s(s_dataflow), .co(co_dataflow), .a(a), .b(b), .ci(ci));
    adder_dataflow_reg  adder_reg_2(.s(s_dataflow_reg), .co(co_dataflow_reg), .a(a), .b(b), .ci(ci), .clk(CLK));

    adder_behavior      adder3     (.s(s_behavior), .co(co_behavior), .a(a), .b(b), .ci(ci));
    adder_behavior_reg  adder_reg_3(.s(s_behavior_reg), .co(co_behavior_reg), .a(a), .b(b), .ci(ci), .clk(CLK));

    always begin #(`CYCLE/2) CLK = ~CLK; end

    integer i, flag;

    initial begin
        flag=0;
        CLK = 0;
        #(`CYCLE*2);
        for(i=0; i<`DATA_NUM; i=i+1) begin
            a  = $random;
            b  = $random;
            ci = $random%2;
            {co_ans, s_ans} = a + b + ci;
            #(`CYCLE);
            $display("----------------------------------------\n");
            $display("a                  : %X\n", a);
            $display("b                  : %X\n", b);
            $display("ci                 : %X\n", ci);
            $display("co_ans             : %X\n", co_ans);
            $display("s_ans              : %X\n", s_ans);
            $display("----------------------------------------\n");

            $display("co_structure       : %X\n", co_structure);
            $display("s_structure        : %X\n", s_structure);
            if({co_ans, s_ans} !== {co_structure, s_structure}) begin
                $display("Error Occured!\n");
                flag = 1;
            end
            $display("----------------------------------------\n");

            $display("co_structure_reg   : %X\n", co_structure_reg);
            $display("s_structure_reg    : %X\n", s_structure_reg);
            if({co_ans, s_ans} !== {co_structure_reg, s_structure_reg}) begin
                $display("Error Occured!\n");
                flag = 1;
            end
            $display("----------------------------------------\n");

            $display("co_dataflow        : %X\n", co_dataflow);
            $display("s_dataflow         : %X\n", s_dataflow);
            if({co_ans, s_ans} !== {co_dataflow, s_dataflow}) begin
                $display("Error Occured!\n");
                flag = 1;
            end
            $display("----------------------------------------\n");

            $display("co_dataflow_reg    : %X\n", co_dataflow_reg);
            $display("s_dataflow_reg     : %X\n", s_dataflow_reg);
            if({co_ans, s_ans} !== {co_dataflow_reg, s_dataflow_reg}) begin
                $display("Error Occured!\n");
                flag = 1;
            end
            $display("----------------------------------------\n");

            $display("co_behavior        : %X\n", co_behavior);
            $display("s_behavior         : %X\n", s_behavior);
            if({co_ans, s_ans} !== {co_behavior, s_behavior}) begin
                $display("Error Occured!\n");
                flag = 1;
            end
            $display("----------------------------------------\n");

            $display("co_behavior_reg    : %X\n", co_behavior_reg);
            $display("s_behavior_reg     : %X\n", s_behavior_reg);
            if({co_ans, s_ans} !== {co_behavior_reg, s_behavior_reg}) begin
                $display("Error Occured!\n");
                flag = 1;
            end
            $display("----------------------------------------\n");
        end
        if(flag == 0) begin
            $display("----------------------------------------\n");
            $display("All testdata correct!\n");
            $display("----------------------------------------\n");
        end
        else begin
            $display("----------------------------------------\n");
            $display("Error occured, please check!\n");
            $display("----------------------------------------\n");
        end

    $finish;
    end
endmodule