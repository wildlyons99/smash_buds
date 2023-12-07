from PIL import Image
im = Image.open('ROMGame.png', 'r')
width, height = im.size
pixel_values = list(im.getdata())

file = open("GameROM.txt", 'w')

fileWidth = width
xCoordinate = -1
yCoordinate = 0

# Divide 255 color by 85

for i in range(len(pixel_values)):
    xCoordinate += 1
    if xCoordinate == fileWidth:
        yCoordinate += 1
        xCoordinate = 0
    
    addr = str(f'{yCoordinate:04b}') + str(f'{xCoordinate:06b}')

    red = int(pixel_values[i][0] / 85)
    green = int(pixel_values[i][1] / 85)
    blue = int(pixel_values[i][2] / 85)

    color = str(f'{red:02b}') + str(f'{green:02b}') + str(f'{blue:02b}')
    file.write('                    when "' + addr + '" => rgb <= "' + color + '";\n')
file.write('                    when others => rgb <= "111111";\n')

file.close() 