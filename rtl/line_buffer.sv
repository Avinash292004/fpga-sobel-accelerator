module line_buffer #(
    parameter int WIDTH = 640
)(
    input  logic       clk,
    input  logic       rst_n,
    input  logic       in_valid,
    input  logic [7:0] in_pixel,
    output logic [7:0] row0,
    output logic [7:0] row1,
    output logic [7:0] row2
);
    logic [7:0] line0 [0:WIDTH-1];
    logic [7:0] line1 [0:WIDTH-1];
    logic [$clog2(WIDTH)-1:0] col_ptr;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            col_ptr <= '0;
            row0    <= '0;
            row1    <= '0;
            row2    <= '0;
        end else if (in_valid) begin
            row0 <= line0[col_ptr];
            row1 <= line1[col_ptr];
            row2 <= in_pixel;

            line0[col_ptr] <= line1[col_ptr];
            line1[col_ptr] <= in_pixel;

            if (int'(col_ptr) == WIDTH - 1)
                col_ptr <= '0;
            else
                col_ptr <= col_ptr + 1'b1;
        end
    end
endmodule
