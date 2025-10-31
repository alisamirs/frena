#!/usr/bin/env python3
"""
Generate app icons for Frena
Creates a simple, professional icon with currency symbols
"""

try:
    from PIL import Image, ImageDraw, ImageFont
    import os
except ImportError:
    print("Installing required package: pillow")
    import subprocess
    subprocess.check_call(['pip', 'install', 'pillow'])
    from PIL import Image, ImageDraw, ImageFont
    import os

# Create assets/icon directory if it doesn't exist
os.makedirs('assets/icon', exist_ok=True)

# App icon colors
bg_color = '#7E57C2'  # Purple from the app theme
fg_color = '#FFFFFF'  # White

# Create main app icon (1024x1024 for best quality)
size = 1024
img = Image.new('RGB', (size, size), bg_color)
draw = ImageDraw.Draw(img)

# Draw a currency exchange symbol
# Draw dollar sign
try:
    # Try to use a system font
    font_size = 600
    font = ImageFont.truetype("arial.ttf", font_size)
except:
    # Fallback to default font
    font = ImageFont.load_default()

# Draw text "F₹" (F for Frena with currency symbol)
text = "F₹"
# Get text bounding box
bbox = draw.textbbox((0, 0), text, font=font)
text_width = bbox[2] - bbox[0]
text_height = bbox[3] - bbox[1]

# Center the text
x = (size - text_width) // 2 - bbox[0]
y = (size - text_height) // 2 - bbox[1]

draw.text((x, y), text, fill=fg_color, font=font)

# Save main icon
img.save('assets/icon/app_icon.png', 'PNG')
print("✓ Created app_icon.png")

# Create adaptive icon foreground (transparent background)
img_fg = Image.new('RGBA', (size, size), (0, 0, 0, 0))
draw_fg = ImageDraw.Draw(img_fg)

# Draw the same text with transparency
draw_fg.text((x, y), text, fill=fg_color + 'FF', font=font)

# Save foreground icon
img_fg.save('assets/icon/app_icon_foreground.png', 'PNG')
print("✓ Created app_icon_foreground.png")

print("\n✓ Icons created successfully!")
print("Run: flutter pub get")
print("Then: dart run flutter_launcher_icons")
