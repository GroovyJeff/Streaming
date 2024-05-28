using FileIO
using Images
using Plots
using Pkg
using ImageFiltering

# Install the necessary packages
# Pkg.add("Images")
# Pkg.add("FileIO")

# Replace "path/to/image.png" with the actual path to your PNG file
img = load("/home/jeff/map3.png")

mask = img .!= RGBA{N0f8}(1.0,1.0,1.0,1.0)

# kernel = [1 0 -1; 1 0 -1; 1 0 -1]

kernel = [1 1 1; 1 0 1; 1 1 1]

mask2 = imfilter(mask, kernel)

mask3 = (mask2 .!= 0)

println(mask2)

gray_array = Gray.(Bool.(mask2))

save("output_image.png", mask3)

# exit()




gray_img = Gray.(img)

float_img = convert(Array{Float64}, gray_img)

edge_img = imfilter(float_img, centered([-1 0 1; -2 0 2; -1 0 1]), Fill(0)) |> abs .|> x->clamp(x/3, 0, 1)

# Display the image (requires a display environment, such as Jupyter or VS Code)
display(img)

# Print image properties
println("Image size: ", size(img))
println("Image type: ", eltype(img))

# Access a specific pixel value
x, y = 10, 20
pixel_value = img[x, y]
println("Pixel value at (10, 20): ", pixel_value)
