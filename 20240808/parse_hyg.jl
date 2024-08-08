using Images
using Colors

# 8 is ra, 9 is dec, 14 is mag

data = read("/home/jeff/Downloads/hygdata_v41.csv", String)

lines = split(data, "\n")

lines2 = lines[3:end-1]

# fields = split(lines[1], ",")

# data = [Dict(fields[i] => split(line, ",")[i] for i in 1:length(fields)) for line in lines[2:end]]

stars = [split(line, ",") for line in lines2]

width = 7200
height = 3600

# TODO: fix this better
arr = zeros(Float64, width+1, height+1)

for i in stars

 (ra, dec, mag) = (parse(Float64, i[8]), parse(Float64, i[9]), parse(Float64, i[14]))

 xpixel = Int(round(ra/24*width)+1)
 ypixel = Int(round((90-dec)/180*height)+1)

# print(xpixel,",",ypixel,"\n")

 arr[xpixel,ypixel] = 1.0

end

img = Gray.(arr)

Images.save("monochrome_image.png", img)






# Create a 100x100 array with values ranging from 0.0 to 1.0
img_data = [x / 100 for x in 0:99, y in 0:99]

# Convert the array to a grayscale image
img = Gray.(img_data)

# Save the image
save("monochrome_image.png", img)

# Display the image
display(img)