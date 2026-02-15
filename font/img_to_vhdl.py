import cv2
import numpy as np

# font png file
font_file = "font.png"

# read font image in 
font = cv2.imread(font_file, cv2.IMREAD_GRAYSCALE)//255

# convert font to vhdl format
output_str = np.array2string(font, separator=', ', threshold=10000000, max_line_width=1000000).replace('[','(').replace(']',')').replace("0","'0'").replace("1","'1'")

# print font in vhdl format
print(output_str)