# NOTE TO SELF: run as "~/.juliaup/bin/julia -p auto"

# or "-p something"

@everywhere using Distributed
@everywhere using Pkg
@everywhere using Plots
@everywhere using Makie
@everywhere using Distances
@everywhere using LinearAlgebra
@everywhere using Shapefile
@everywhere using GeoDataFrames
@everywhere using DataFrames
@everywhere using NearestNeighbors

df = DataFrame(Shapefile.Table("gadm41_USA_0.shp"))

pts = []

for i in df.geometry
 append!(pts, [[p.x, p.y] for p in i.points])
end

# compute the cosines and sines as needed

lngs = [i[1] for i in pts]
lats = [i[2] for i in pts]

x = cosd.(lngs).*cosd.(lats)
y = sind.(lngs).*cosd.(lats)
z = sind.(lats)

# scatter3d(x,y,z)

pts = [[x[i], y[i], z[i]] for i in range(1,length(x))]

antipts = [[-x[i], -y[i], -z[i]] for i in range(1,length(x))]

tree = KDTree(hcat(antipts...))

@everywhere minim = 10
@everywhere pts = $pts
@everywhere tree = $tree
@everywhere minp = 0

@everywhere function minDist(i::Int)
 global minim
 tq = knn(tree, pts[i], 1, true)
 dist = tq[2][end]
 if (dist >= minim) return end
 minim = dist
 minp = tq[1][end]
 println("$i $minp $dist")
end

pmap(minDist, range(1,size(pts)[1]))

#=

results:

      From worker 14:   848943 1845637 1.5311829942721604
      From worker 15:   1845637 848943 1.5311829942721604


These would be:

julia> pts[848943]
3-element Vector{Float64}:
  0.15738100781373218
 -0.8925395686739641
  0.4226160630298238

julia> pts[1845637]
3-element Vector{Float64}:
 -0.5976832977157998
  0.07936461084136887
  0.7977944184923612


or: -79.99986299999995 lng, 24.999861000000124 lat (~Key Largo, FL)

and: 172.4361110000001 lng, 52.91999800000019 lat (~Attu Island, AK)

5533.049911769881 miles

(does not include territories though)

=#



#=

tree = KDTree(hcat(pts...))

@everywhere tree = $tree
@everywhere pts = $pts

@everywhere maxim = 0
@everywhere maxp = 0

@everywhere function maxDist(i::Int)
 global maxim
 tq = knn(tree, pts[i], size(pts)[1], true)
 dist = tq[2][end]
 if (dist <= maxim) return end
 maxim = dist
 maxp = tq[1][end]
 println("$i $dist")
end

pmap(maxDist, range(1,size(pts)[1]))



@everywhere ret = $ret

@everywhere tree = KDTree(hcat(ret...))

@everywhere function maxDist(i::Int)
 tq = knn(tree, ret[i], size(ret)[1], true)
 pt = tq[1][end]
 dist = tq[2][end]
 println("$i $pt $dist")
end

@everywhere function testo(i::Int)
 global ret
 return(ret[i])
end

pmap(maxDist, range(1,size(ret)[1]))

=#
