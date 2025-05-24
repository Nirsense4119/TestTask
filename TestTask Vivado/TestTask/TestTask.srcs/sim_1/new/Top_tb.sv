module tb_calculator;

    // Параметры
    parameter N = 8;
    parameter CLK_PERIOD = 10;

    // Сигналы
    logic             clk;
    logic             rst_n;
    logic             valid_in;
    logic signed [N-1:0] a, b, c, d;
    logic signed [N-1:0] Q;
    logic             valid_out;

    // Подключение модуля
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

    // Генерация тактового сигнала
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Тестовый сценарий
    initial begin
        // Инициализация
        rst_n = 0;
        valid_in = 0;
        a = 0; b = 0; c = 0; d = 0;

        #20 rst_n = 1;  // Снятие сброса

        // Тест 1: a=5, b=2, c=1, d=1
        #10 valid_in = 1;
        a = 5; b = 2; c = 1; d = 1;
        #10 valid_in = 0;

        wait (valid_out);
        $display("Тест 1: a=%0d, b=%0d, c=%0d, d=%0d, Q=%0d (Ожидается 4)", a, b, c, d, Q);
        assert(Q == 4) else $error("Тест 1 не пройден");

        // Тест 2: a=-3, b=1, c=2, d=-2
        #10 valid_in = 1;
        a = -3; b = 1; c = 2; d = -2;
        #10 valid_in = 0;

        wait (valid_out);
        $display("Тест 2: a=%0d, b=%0d, c=%0d, d=%0d, Q=%0d (Ожидается -10)", a, b, c, d, Q);
        assert(Q == -10) else $error("Тест 2 не пройден");

        // Тест 3: a=10, b=5, c=-1, d=2
        #10 valid_in = 1;
        a = 10; b = 5; c = -1; d = 2;
        #10 valid_in = 0;

        wait (valid_out);
        $display("Тест 3: a=%0d, b=%0d, c=%0d, d=%0d, Q=%0d (Ожидается -9)", a, b, c, d, Q);
        assert(Q == -9) else $error("Тест 3 не пройден");

        #50 $finish;
    end

endmodule