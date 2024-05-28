using Pkg
using Plots
using Makie
using Distances
using LinearAlgebra
using Shapefile
using GeoDataFrames
using DataFrames

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



  


