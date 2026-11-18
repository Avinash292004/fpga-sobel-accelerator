import os
import cv2
import numpy as np

WIDTH, HEIGHT = 640, 480
THRESHOLD = 100

if os.path.exists("data/input.jpg"):
    img = cv2.imread("data/input.jpg", cv2.IMREAD_GRAYSCALE)
    img = cv2.resize(img, (WIDTH, HEIGHT))
else:
    img = np.zeros((HEIGHT, WIDTH), dtype=np.uint8)
    cv2.rectangle(img, (150, 120), (490, 360), 220, -1)
    cv2.circle(img, (320, 240), 70, 50, -1)
    cv2.imwrite("data/input_generated.png", img)

with open("data/input_pixels.hex", "w") as f:
    for px in img.flatten():
        f.write(f"{px:02x}\n")

gx = cv2.Sobel(img, cv2.CV_16S, 1, 0, ksize=3)
gy = cv2.Sobel(img, cv2.CV_16S, 0, 1, ksize=3)
mag = np.abs(gx) + np.abs(gy)
edges = np.where(mag > THRESHOLD, 255, 0).astype(np.uint8)

cv2.imwrite("data/golden_edges.png", edges)
print("Done! Check data/golden_edges.png")
