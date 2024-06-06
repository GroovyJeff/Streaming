using Images
using NearestNeighbors
using LinearAlgebra
using Plots

img = load("temp.bmp");

lit = findall(x -> x==RGB{N0f8}(1.0,1.0,1.0), img);

imgsize = size(img)

(w,h) = imgsize

# compute the 3d projection of all points in the map

i_values = 1:h
j_values = 1:w

# Calculate lng and lat using vectorized operations

lng_values = ((j_values .- 0.5) ./ w * 360) .- 180
lat_values = 90 .- ((i_values .- 0.5) ./ h * 180)

# Calculate points using vectorized trigonometric functions

cos_lat = cosd.(lat_values')
cos_lng = cosd.(lng_values)
sin_lat = sind.(lat_values')
sin_lng = sind.(lng_values)

onevec = ones(w)

points = cat(cos_lng .* cos_lat, sin_lng .* cos_lat, sin_lat .* onevec, dims=3)

# Reshape points to have shape (w*h, 3)

points = reshape(points, w*h, 3)

# determine which points are lit

litpts = [(i[1]-1)*w + i[2] for i in lit]

litcoords = points[litpts, :]

tree = KDTree(litcoords)









