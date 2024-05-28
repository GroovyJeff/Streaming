using Pkg
using Plots
using Makie
using Distances
using LinearAlgebra

# Install necessary packages
Pkg.add("Shapefile")
Pkg.add("GeoDataFrames")
Pkg.add("DataFrames")

# Import the packages
using Shapefile
using GeoDataFrames
using DataFrames

function points_to_3d(df)
 ret = []
 for i in df.geometry
  for j in i.points
   pt = [cos(j.y*pi/180)*cos(j.x*pi/180), cos(j.y*pi/180)*sin(j.x*pi/180), sin(j.y*pi/180)]
   push!(ret, pt)
  end
 end
 return(ret)
end


# Specify the path to your shapefile
shapefile_path = "path/to/your/shapefile.shp"

# Read the shapefile using Shapefile.jl
table = Shapefile.Table(shapefile_path)

# Convert to a DataFrame for easier manipulation and inspection
df = DataFrame(table)

# Print the DataFrame
println("DataFrame content:")
println(df)

# Iterate over features and print geometries
println("Geometries from DataFrame:")
for row in eachrow(df)
    println(row.geometry)
end

p3d = points_to_3d(df.geometry[1].points)

p3d2 = transpose(p3d)


temp = points_to_3d(df)
x = [i[1] for i in temp]
y = [i[2] for i in temp]
z = [i[3] for i in temp]

# Read the shapefile using GeoDataFrames.jl
gdf = GeoDataFrame(shapefile_path)

# Print the GeoDataFrame
println("GeoDataFrame content:")
println(gdf)

# Access the geometries and attributes
println("Geometries and attributes from GeoDataFrame:")
for row in eachrow(gdf)
    println("Geometry: ", row.geometry)
    println("Attributes: ", row[Not(:geometry)])  # Print all attributes except geometry
end

