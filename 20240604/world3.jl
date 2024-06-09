using Images
using NearestNeighbors
using LinearAlgebra
using Plots

img = load("usa256.bmp");

lit = findall(x -> x==RGB{N0f8}(1.0,1.0,1.0), img);

imgsize = size(img)

(w,h) = imgsize

# alpha is just a name for the file handle

fh = open("usa256.bmp.aux.xml", "r")

fc = read(fh, String)

pattern = r"<GeoTransform>(.*)</GeoTransform>"

t1 = match(pattern, fc)

t2 = t1[1]

t3 = split(t2, ",")

t4 = [parse(Float64, i) for i in t3]

(wlng, dlng, _, nlat, _, dlat) = t4

lngLat = [[wlng + (i[1]-0.5)*dlng, nlat + (i[2]-0.5)*dlat] for i in lit]

lng = [i[1] for i in lngLat]
lat = [i[2] for i in lngLat]

# to 3D

cosLng = cosd.(lng)
sinLng = sind.(lng)
cosLat = cosd.(lat)
sinLat = sind.(lat)

xs = cosLng.*cosLat
ys = sinLng.*cosLat
zs = sinLat

pts = hcat(xs, ys, zs)

# tree = KDTree(pts)

# scatter3d(xs, ys, zs)











#=

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

# this is not the right way to do it, but...

onevec = ones(w)

points = cat(cos_lng .* cos_lat, sin_lng .* cos_lat, sin_lat .* onevec, dims=3)

# Reshape points to have shape (w*h, 3)

points = reshape(points, w*h, 3)

# determine which points are lit

litpts = [(i[1]-1)*w + i[2] for i in lit]

litcoords = points[litpts, :]

litcoordsanti = -1 .* litcoords

# below 3 lines only needed for scatter3d

x = litcoords[:,1]
y = litcoords[:,2]
z = litcoords[:,3]

# scatter3d(x,y,z)

# can now plot w scatter3d if desired

# kdtree of lit points antipodes

tree = KDTree(litcoordsanti)

minim = 10
# @everywhere pts = $pts
# @everywhere tree = $tree
minp = 0

function minDist(i::Int)
 global minim
 tq = knn(tree, litcoords[i,:], 1, true)
 dist = tq[2][end]
 if (dist >= minim) return("NA") end
 minim = dist
 minp = tq[1][end]
 return("$i $minp $dist")
end

result = map(minDist, range(1,size(litcoords)[1]))

=#
