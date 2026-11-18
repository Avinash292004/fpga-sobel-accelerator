module tb_sobel_top;
    localparam int WIDTH  = 640;
    localparam int HEIGHT = 480;
    localparam int TOTAL  = WIDTH * HEIGHT;

    logic       clk = 0;
    logic       rst_n = 0;
    logic       in_valid = 0;
    logic [7:0] in_pixel = 0;
    logic       out_valid;
    logic [7:0] out_pixel;

    logic [7:0] img_mem [0:TOTAL-1];
    int fd;
    int out_count = 0;

    // Generate a 100 MHz clock (toggles every 5 ns)
    always #5 clk = ~clk;

    sobel_top #(.WIDTH(WIDTH), .THRESHOLD(100)) dut (
        .clk       (clk),
        .rst_n     (rst_n),
        .in_valid  (in_valid),
        .in_pixel  (in_pixel),
        .out_valid (out_valid),
        .out_pixel (out_pixel)
    );

    // Capture every valid output pixel into rtl_output.hex
    always @(posedge clk) begin
        if (out_valid) begin
            $fdisplay(fd, "%02x", out_pixel);
            out_count++;
        end
    end

    initial begin
        $readmemh("data/input_pixels.hex", img_mem);
        fd = $fopen("data/rtl_output.hex", "w");

        // Hold reset for 5 clock cycles
        rst_n = 0;
        repeat (5) @(posedge clk);
        rst_n = 1;

        // Stream all 307,200 pixels (1 pixel per clock cycle)
        for (int i = 0; i < TOTAL; i++) begin
            @(negedge clk);
            in_valid = 1'b1;
            in_pixel = img_mem[i];
        end

        // Stop input and flush the remaining pipeline stages
        @(negedge clk);
        in_valid = 1'b0;
        repeat (10) @(posedge clk);

        $fclose(fd);
        $display("Simulation complete! Captured %0d pixels.", out_count);
        $finish;
    end
endmodule
