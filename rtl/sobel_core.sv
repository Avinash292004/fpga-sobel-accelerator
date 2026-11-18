module sobel_core #(
    parameter int THRESHOLD = 100
)(
    input  logic       clk,
    input  logic       rst_n,
    input  logic       in_valid,
    input  logic [7:0] p0, p1, p2, p3, p4, p5, p6, p7, p8,
    output logic       out_valid,
    output logic [7:0] out_pixel
);
    logic signed [10:0] gx, gy;
    logic valid_s1;

    // Stage 1: Horizontal (gx) and Vertical (gy) gradients
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            gx <= '0; gy <= '0; valid_s1 <= 1'b0;
        end else begin
            valid_s1 <= in_valid;
            gx <= ($signed({3'b0, p2}) + ($signed({3'b0, p5}) <<< 1) + $signed({3'b0, p8})) -
                  ($signed({3'b0, p0}) + ($signed({3'b0, p3}) <<< 1) + $signed({3'b0, p6}));
            gy <= ($signed({3'b0, p6}) + ($signed({3'b0, p7}) <<< 1) + $signed({3'b0, p8})) -
                  ($signed({3'b0, p0}) + ($signed({3'b0, p1}) <<< 1) + $signed({3'b0, p2}));
        end
    end

    // Stage 2: Magnitude |gx| + |gy|
    logic [10:0] abs_gx, abs_gy;
    logic [11:0] grad_mag;
    logic valid_s2;

    assign abs_gx = gx[10] ? -gx : gx;
    assign abs_gy = gy[10] ? -gy : gy;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            grad_mag <= '0; valid_s2 <= 1'b0;
        end else begin
            valid_s2 <= valid_s1;
            grad_mag <= {1'b0, abs_gx} + {1'b0, abs_gy};
        end
    end

    // Stage 3: Compare against threshold
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out_pixel <= 8'd0; out_valid <= 1'b0;
        end else begin
            out_valid <= valid_s2;
            out_pixel <= (grad_mag > 12'(THRESHOLD)) ? 8'd255 : 8'd0;
        end
    end
endmodule
