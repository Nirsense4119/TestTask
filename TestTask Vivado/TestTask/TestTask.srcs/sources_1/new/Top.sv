module calculator #(
    parameter N = 8  // Параметр разрядности 
) (
    input  logic             clk,        // Тактовый сигнал
    input  logic             rst_n,      // Асинхронный сброс 
    input  logic             valid_in,   // Сигнал валидности входных данных
    input  logic signed [N-1:0] a, b, c, d,  // Входные данные 
    output logic signed [N-1:0] Q,       // Выходные данные
    output logic             valid_out   // Сигнал валидности выходных данных
);

// Определение разрядности промежуточных сигналов для предотвращения переполнения
localparam DIFF_WIDTH = N + 1;         // (a - b)
localparam SUMM_WIDTH = N + 2;         // (1 + 3c)
localparam PROD_WIDTH = DIFF_WIDTH + SUMM_WIDTH;  // для (a - b)*(1 + 3c)
localparam SUB_WIDTH  = PROD_WIDTH + 1;  // для sub

// Регистры первого этапа
logic signed [DIFF_WIDTH-1:0] diff_reg;
logic signed [SUMM_WIDTH-1:0] summ_reg;
logic signed [N-1:0]          d_stage1;
logic                         valid_stage1;

// Регистры второго этапа
logic signed [PROD_WIDTH-1:0] prod_reg;
logic signed [N-1:0]          d_stage2;
logic                         valid_stage2;

// Промежуточные сигналы третьего этапа
logic signed [SUB_WIDTH-1:0]  sub;

// Этап 1: Вычисление diff и summ
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        diff_reg     <= 0;
        summ_reg     <= 0;
        d_stage1     <= 0;
        valid_stage1 <= 0;
    end else if (valid_in) begin
        diff_reg     <= a - b;             // Вычитание a - b
        summ_reg     <= 1 + (c << 1) + c;  // 1 + 2c + c = 1 + 3c
        d_stage1     <= d;                 // Передача d на следующий этап
        valid_stage1 <= valid_in;          // Передача сигнала валидности
    end else begin
        valid_stage1 <= 0;                 // Сброс валидности при отсутствии входных данных
    end
end

// Этап 2: Вычисление prod
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        prod_reg     <= 0;
        d_stage2     <= 0;
        valid_stage2 <= 0;
    end else if (valid_stage1) begin
        prod_reg     <= diff_reg * summ_reg;  // Умножение diff на summ
        d_stage2     <= d_stage1;             // Передача d
        valid_stage2 <= valid_stage1;         // Передача валидности
    end else begin
        valid_stage2 <= 0;
    end
end

// Этап 3: Вычисление sub и Q
always_comb begin
    sub = prod_reg - (d_stage2 << 2);  // Вычисление prod - 4d (d << 2 = 4d)
end

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q            <= 0;
        valid_out    <= 0;
    end else begin
        if (valid_stage2) begin
            Q            <= $signed(sub >>> 1);  // Деление на 2 (арифметический сдвиг вправо)
            valid_out    <= valid_stage2;        // Передача валидности
        end else begin
            valid_out    <= 0;
        end
    end
end

endmodule