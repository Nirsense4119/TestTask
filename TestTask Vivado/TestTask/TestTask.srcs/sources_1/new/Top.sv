module calculator #(
    parameter N = 8  // �������� ����������� 
) (
    input  logic             clk,        // �������� ������
    input  logic             rst_n,      // ����������� ����� 
    input  logic             valid_in,   // ������ ���������� ������� ������
    input  logic signed [N-1:0] a, b, c, d,  // ������� ������ 
    output logic signed [N-1:0] Q,       // �������� ������
    output logic             valid_out   // ������ ���������� �������� ������
);

// ����������� ����������� ������������� �������� ��� �������������� ������������
localparam DIFF_WIDTH = N + 1;         // (a - b)
localparam SUMM_WIDTH = N + 2;         // (1 + 3c)
localparam PROD_WIDTH = DIFF_WIDTH + SUMM_WIDTH;  // ��� (a - b)*(1 + 3c)
localparam SUB_WIDTH  = PROD_WIDTH + 1;  // ��� sub

// �������� ������� �����
logic signed [DIFF_WIDTH-1:0] diff_reg;
logic signed [SUMM_WIDTH-1:0] summ_reg;
logic signed [N-1:0]          d_stage1;
logic                         valid_stage1;

// �������� ������� �����
logic signed [PROD_WIDTH-1:0] prod_reg;
logic signed [N-1:0]          d_stage2;
logic                         valid_stage2;

// ������������� ������� �������� �����
logic signed [SUB_WIDTH-1:0]  sub;

// ���� 1: ���������� diff � summ
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        diff_reg     <= 0;
        summ_reg     <= 0;
        d_stage1     <= 0;
        valid_stage1 <= 0;
    end else if (valid_in) begin
        diff_reg     <= a - b;             // ��������� a - b
        summ_reg     <= 1 + (c << 1) + c;  // 1 + 2c + c = 1 + 3c
        d_stage1     <= d;                 // �������� d �� ��������� ����
        valid_stage1 <= valid_in;          // �������� ������� ����������
    end else begin
        valid_stage1 <= 0;                 // ����� ���������� ��� ���������� ������� ������
    end
end

// ���� 2: ���������� prod
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        prod_reg     <= 0;
        d_stage2     <= 0;
        valid_stage2 <= 0;
    end else if (valid_stage1) begin
        prod_reg     <= diff_reg * summ_reg;  // ��������� diff �� summ
        d_stage2     <= d_stage1;             // �������� d
        valid_stage2 <= valid_stage1;         // �������� ����������
    end else begin
        valid_stage2 <= 0;
    end
end

// ���� 3: ���������� sub � Q
always_comb begin
    sub = prod_reg - (d_stage2 << 2);  // ���������� prod - 4d (d << 2 = 4d)
end

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q            <= 0;
        valid_out    <= 0;
    end else begin
        if (valid_stage2) begin
            Q            <= $signed(sub >>> 1);  // ������� �� 2 (�������������� ����� ������)
            valid_out    <= valid_stage2;        // �������� ����������
        end else begin
            valid_out    <= 0;
        end
    end
end

endmodule