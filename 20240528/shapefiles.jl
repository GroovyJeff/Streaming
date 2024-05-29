using Pkg
using Plots
using Makie
using Distances
using LinearAlgebra
using Shapefile
using GeoDataFrames
using DataFrames
using NearestNeighbors

df = DataFrame(Shapefile.Table("/home/jeff/20240527/gadm41_USA_0.shp"))

ret = []

for i in df.geometry
 for j in i.points
  if (j.x < -130 || j.x > -65) continue end
  if (j.y < 24 || j.y > 49.5) continue end
  pt = [cos(j.y*pi/180)*cos(j.x*pi/180), cos(j.y*pi/180)*sin(j.x*pi/180), sin(j.y*pi/180)]
  push!(ret, pt)
 end
end

x = [i[1] for i in ret]
y = [i[2] for i in ret]
z = [i[3] for i in ret]

# scatter3d(x,y,z)

tree = KDTree(hcat(ret...))

for i in range(1,size(ret)[1])
 tq = knn(tree, ret[i], size(ret)[1], true)
 pt = tq[1][end]
 dist = tq[2][end]
 if i%1000 == 0 println("$i $pt $dist") end
end

for i in ret
# println(i, knn(tree, i, size(ret)[1], true)[1:5])
# pt = knn(tree, i, size(ret)[1], true)[1][end]
# dist = knn(tree, i, size(ret)[1], true)[2][end]

 pt = knn(tree, i, size(ret)[1])[1][1]
 dist = knn(tree, i, size(ret)[1])[2][1]
 println(pt," ", dist)
end

println(ret)

mdist = 0

while true
 v1 = rand(ret)
 v2 = rand(ret)
 dist = sum([i^2 for i in v1-v2])

 if dist > mdist
  mdist = dist
  mv1 = v1
  mv2 = v2
  println(dist, v1, v2)
 end
end


