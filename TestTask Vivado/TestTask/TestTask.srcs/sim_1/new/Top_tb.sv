module tb_calculator;

    // ���������
    parameter N = 8;
    parameter CLK_PERIOD = 10;

    // �������
    logic             clk;
    logic             rst_n;
    logic             valid_in;
    logic signed [N-1:0] a, b, c, d;
    logic signed [N-1:0] Q;
    logic             valid_out;

    // ����������� ������
    calculator #(.N(N)) dut (
        .clk(clk),
        .rst_n(rst_n),
        .valid_in(valid_in),
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .Q(Q),
        .valid_out(valid_out)
    );

    // ��������� ��������� �������
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // �������� ��������
    initial begin
        // �������������
        rst_n = 0;
        valid_in = 0;
        a = 0; b = 0; c = 0; d = 0;

        #20 rst_n = 1;  // ������ ������

        // ���� 1: a=5, b=2, c=1, d=1
        #10 valid_in = 1;
        a = 5; b = 2; c = 1; d = 1;
        #10 valid_in = 0;

        wait (valid_out);
        $display("���� 1: a=%0d, b=%0d, c=%0d, d=%0d, Q=%0d (��������� 4)", a, b, c, d, Q);
        assert(Q == 4) else $error("���� 1 �� �������");

        // ���� 2: a=-3, b=1, c=2, d=-2
        #10 valid_in = 1;
        a = -3; b = 1; c = 2; d = -2;
        #10 valid_in = 0;

        wait (valid_out);
        $display("���� 2: a=%0d, b=%0d, c=%0d, d=%0d, Q=%0d (��������� -10)", a, b, c, d, Q);
        assert(Q == -10) else $error("���� 2 �� �������");

        // ���� 3: a=10, b=5, c=-1, d=2
        #10 valid_in = 1;
        a = 10; b = 5; c = -1; d = 2;
        #10 valid_in = 0;

        wait (valid_out);
        $display("���� 3: a=%0d, b=%0d, c=%0d, d=%0d, Q=%0d (��������� -9)", a, b, c, d, Q);
        assert(Q == -9) else $error("���� 3 �� �������");

        #50 $finish;
    end

endmodule