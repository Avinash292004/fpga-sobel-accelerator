import cv2
import numpy as np

WIDTH, HEIGHT = 640, 480

# 1. Read the hex numbers produced by your SystemVerilog hardware
with open("data/rtl_output.hex", "r") as f:
    pixels = [int(line.strip(), 16) for line in f if line.strip()]

rtl_img = np.array(pixels[:WIDTH * HEIGHT], dtype=np.uint8).reshape((HEIGHT, WIDTH))
cv2.imwrite("docs/fpga_edges.png", rtl_img)

# 2. Load the Golden Model output and align for the 1-pixel 3x3 window offset
golden = cv2.imread("data/golden_edges.png", cv2.IMREAD_GRAYSCALE)
rtl_aligned = rtl_img[2:-1, 2:-1]
golden_aligned = golden[1:-2, 1:-2]

matches = np.sum(rtl_aligned == golden_aligned)
accuracy = (matches / golden_aligned.size) * 100.0
print(f"Bit-Accurate Match vs Golden Model: {accuracy:.2f}%")

# 3. Create a side-by-side image for your GitHub README
orig_path = "data/input.jpg" if cv2.imread("data/input.jpg") is not None else "data/input_generated.png"
orig = cv2.resize(cv2.imread(orig_path, cv2.IMREAD_GRAYSCALE), (WIDTH, HEIGHT))

comparison = np.hstack((orig, golden, rtl_img))
cv2.imwrite("docs/comparison.png", comparison)
print("Saved docs/fpga_edges.png and docs/comparison.png")
