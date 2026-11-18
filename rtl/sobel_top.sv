module sobel_top #(
    parameter int WIDTH     = 640,
    parameter int THRESHOLD = 100
)(
    input  logic       clk,
    input  logic       rst_n,
    input  logic       in_valid,
    input  logic [7:0] in_pixel,
    output logic       out_valid,
    output logic [7:0] out_pixel
);
    logic [7:0] row0, row1, row2;
    logic [7:0] p0, p1, p2, p3, p4, p5, p6, p7, p8;
    logic valid_lb, valid_win;

    // Track valid signal through the 2-cycle buffer + window delay
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_lb  <= 1'b0;
            valid_win <= 1'b0;
        end else begin
            valid_lb  <= in_valid;
            valid_win <= valid_lb;
        end
    end

    line_buffer #(.WIDTH(WIDTH)) u_lb (
        .clk      (clk),
        .rst_n    (rst_n),
        .in_valid (in_valid),
        .in_pixel (in_pixel),
        .row0     (row0),
        .row1     (row1),
        .row2     (row2)
    );

    window_3x3 u_win (
        .clk      (clk),
        .rst_n    (rst_n),
        .in_valid (valid_lb),
        .row0     (row0),
        .row1     (row1),
        .row2     (row2),
        .p0(p0), .p1(p1), .p2(p2),
        .p3(p3), .p4(p4), .p5(p5),
        .p6(p6), .p7(p7), .p8(p8)
    );

    sobel_core #(.THRESHOLD(THRESHOLD)) u_core (
        .clk       (clk),
        .rst_n     (rst_n),
        .in_valid  (valid_win),
        .p0(p0), .p1(p1), .p2(p2),
        .p3(p3), .p4(p4), .p5(p5),
        .p6(p6), .p7(p7), .p8(p8),
        .out_valid (out_valid),
        .out_pixel (out_pixel)
    );
endmodule
