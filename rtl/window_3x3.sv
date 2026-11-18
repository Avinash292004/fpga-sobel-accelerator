module window_3x3 (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       in_valid,
    input  logic [7:0] row0, row1, row2,
    output logic [7:0] p0, p1, p2,
    output logic [7:0] p3, p4, p5,
    output logic [7:0] p6, p7, p8
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            {p0, p1, p2, p3, p4, p5, p6, p7, p8} <= '0;
        end else if (in_valid) begin
            p0 <= p1; p1 <= p2; p2 <= row0;
            p3 <= p4; p4 <= p5; p5 <= row1;
            p6 <= p7; p7 <= p8; p8 <= row2;
        end
    end
endmodule
