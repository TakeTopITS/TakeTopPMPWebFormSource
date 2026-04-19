#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
创建主题切换图标 V2 - 更好的设计
"""
from PIL import Image, ImageDraw
import math

# 创建 64x64 像素的图像，透明背景
size = 64
img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
draw = ImageDraw.Draw(img)

# 颜色定义 - 使用项目主题色
theme_teal = (54, 126, 127, 255)  # #367E7F 主色
theme_light = (85, 160, 161, 255)  # 亮一点的变体
theme_dark = (40, 95, 96, 255)  # 暗一点的变体
white = (255, 255, 255, 230)
gray_light = (220, 220, 220, 200)
gray_dark = (120, 120, 120, 200)

cx, cy = 32, 32

# 绘制一个画笔/调色板图标
# 画板主体 - 圆角矩形
board_left, board_top = 14, 18
board_right, board_bottom = 50, 50
board_radius = 4

# 画板阴影
draw.rounded_rectangle([board_left+1, board_top+1, board_right+1, board_bottom+1], 
                       radius=board_radius, fill=(0, 0, 0, 30))

# 画板主体
draw.rounded_rectangle([board_left, board_top, board_right, board_bottom], 
                       radius=board_radius, fill=white, outline=theme_teal, width=2)

# 在画板上绘制三个色块表示不同主题
block_w, block_h = 8, 20
block_y = 24

# 第一个色块 - 深色主题
draw.rounded_rectangle([18, block_y, 18+block_w, block_y+block_h], 
                       radius=2, fill=theme_dark)

# 第二个色块 - 主色主题
draw.rounded_rectangle([28, block_y, 28+block_w, block_y+block_h], 
                       radius=2, fill=theme_teal)

# 第三个色块 - 浅色主题
draw.rounded_rectangle([38, block_y, 38+block_w, block_y+block_h], 
                       radius=2, fill=theme_light)

# 画笔斜放在画板上
# 笔杆
pen_color = (80, 80, 80, 220)
pen_x1, pen_y1 = 44, 14
pen_x2, pen_y2 = 52, 30
pen_width = 4

# 绘制笔杆（圆角矩形模拟）
for i in range(pen_width):
    offset = i - pen_width//2
    draw.line([(pen_x1+offset, pen_y1), (pen_x2+offset, pen_y2)], 
              fill=pen_color, width=1)

# 笔尖
draw.polygon([(pen_x2-2, pen_y2-2), (pen_x2+2, pen_y2+2), (pen_x2+4, pen_y2-2)], 
             fill=theme_teal)

# 笔杆高光
draw.line([(pen_x1-1, pen_y1), (pen_x2-1, pen_y2)], fill=(150, 150, 150, 150), width=1)

# 保存为 PNG
output_path = r'd:\WorkBuddy\TakeTopDECMPWinPGSolutionENCore\Source\Web\ImagesSkin\MainSkin.png'
img.save(output_path, 'PNG')
print(f'图标已保存到: {output_path}')
