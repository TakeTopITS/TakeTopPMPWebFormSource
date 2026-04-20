#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
创建主题切换图标 - 简洁专业的风格
"""
from PIL import Image, ImageDraw
import math

# 创建 64x64 像素的图像，透明背景
size = 64
img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
draw = ImageDraw.Draw(img)

# 使用项目主题色 - 柔和的蓝绿色
theme_color = (54, 126, 127, 255)  # #367E7F
light_color = (100, 170, 171, 255)  # 稍亮的变体
dark_color = (35, 90, 91, 255)  # 稍暗的变体

# 绘制一个简洁的调色板/皮肤图标
# 中心圆
center_x, center_y = 32, 32
radius = 22

# 外圈 - 深色
draw.ellipse([center_x-radius-2, center_y-radius-2, center_x+radius+2, center_y+radius+2], fill=dark_color)

# 内圈 - 主题色
draw.ellipse([center_x-radius, center_y-radius, center_x+radius, center_y+radius], fill=theme_color)

# 绘制三个小圆点代表不同颜色主题
dot_radius = 5
dot_positions = [
    (center_x - 10, center_y - 5),   # 左上
    (center_x + 10, center_y - 5),   # 右上
    (center_x, center_y + 12),       # 下方
]
dot_colors = [
    (255, 255, 255, 200),   # 白色
    (200, 200, 200, 200),   # 浅灰
    (100, 100, 100, 200),   # 深灰
]

for (dx, dy), color in zip(dot_positions, dot_colors):
    draw.ellipse([dx-dot_radius, dy-dot_radius, dx+dot_radius, dy+dot_radius], fill=color)

# 保存为 PNG
output_path = r'd:\WorkBuddy\TakeTopDECMPWinPGSolutionENCore\Source\Web\ImagesSkin\MainSkin.png'
img.save(output_path, 'PNG')
print(f'图标已保存到: {output_path}')

# 同时创建一个备份
import shutil
backup_path = r'd:\WorkBuddy\TakeTopDECMPWinPGSolutionENCore\Source\Web\ImagesSkin\MainSkin_old.png'
shutil.copy(output_path, backup_path)
print(f'备份已创建: {backup_path}')
