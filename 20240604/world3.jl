using InteractiveUtils
using Images
using NearestNeighbors
using LinearAlgebra
using Plots
using REPL
using Debugger

img = load("usa256.bmp");

@bp

# TODO: find better way to enter REPL inside of an include

term = REPL.Terminals.TTYTerminal("dumb", stdin, stdout, stderr)
repl = REPL.LineEditREPL(term, true)
REPL.run_repl(repl)

# REPL.run_repl(REPL.Terminals.text_backend(), backend=false)

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
