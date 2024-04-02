import cv2
import numpy as np

# Load the image
image = cv2.imread('bin60.jpeg')

# Convert the image to grayscale
gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

# Apply Gaussian blur to reduce noise
blurred_image = cv2.GaussianBlur(gray_image, (3, 3), 0)

# Perform Canny edge detection
edges = cv2.Canny(blurred_image, 30, 100)

# Perform edge thinning
def thin_edges(edges, threshold=100):
    thin_edges = edges.copy()
    contours, _ = cv2.findContours(edges, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    for contour in contours:
        area = cv2.contourArea(contour)
        if area < threshold:
            cv2.drawContours(thin_edges, [contour], 0, 0, -1)
    return thin_edges

thin_edges_image = thin_edges(edges)

# Define a kernel for dilation
kernel = np.ones((4, 4), np.uint8)

# Dilate the thin edges image
dilated_image = cv2.dilate(thin_edges_image, kernel, iterations=1)

# Create a mask to select only bounded regions
mask = np.zeros_like(dilated_image)
contours, _ = cv2.findContours(dilated_image, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
for contour in contours:
    cv2.drawContours(mask, [contour], -1, 255, -1)

# Convert black pixels in mask to green
masked_image = cv2.cvtColor(dilated_image, cv2.COLOR_BGR2BGRA)
masked_image[np.where(mask == 0)] = [0, 255, 0, 255]  # Set black pixels to green

# Calculate the difference between white and black pixels within the bounded regions
white_pixels = np.sum(mask == 255)
black_pixels = np.sum(mask == 0)

print("Percentage: ",white_pixels/(white_pixels+black_pixels))

cv2.imshow('Masked Image', masked_image)
cv2.waitKey(0)
cv2.destroyAllWindows()
