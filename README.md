# FPGA-Accelerated Real-Time Sobel Edge Detection Engine

A pipelined, streaming hardware accelerator written in **SystemVerilog** that performs real-time 3×3 Sobel edge detection at **1 pixel per clock cycle**. Verified bit-accurately against a Python/OpenCV golden reference model using **Verilator**.

![Original vs OpenCV vs FPGA Output](docs/comparison.png)
*(Left: Grayscale Input | Middle: OpenCV Golden Model | Right: SystemVerilog RTL Output)*

## Hardware Architecture
```text
Pixel Stream (8-bit) ──▶ [ Dual Line Buffer (BRAM) ] ──▶ [ 3×3 Sliding Window ] ──▶ [ 3-Stage Sobel Pipeline ] ──▶ Edge Output
