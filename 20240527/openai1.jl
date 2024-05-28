using Pkg
Pkg.add("Shapefile")

using Shapefile
using GeoInterface

# Replace "path/to/shapefile.shp" with the actual path to your shapefile
shp = Shapefile.Table("/home/jeff/20240527/gadm41_USA_1.shp")

println(shp)

# for i in shp.NAME_1 println(i) end



# To view the fields in the shapefile
println(schema(shp))

# To iterate over the records and print them
for record in shp
    println(record)
end

# Accessing geometries and attributes
for record in shp
    # Get the geometry (e.g., Point, LineString, Polygon)
    geom = record.geometry

    # Get the attributes as a NamedTuple
    attrs = record.properties

    println("Geometry: $geom")
    println("Attributes: $attrs")
end

# Working with geometries
for record in shp
    geom = record.geometry
    
    if GeoInterface.ispoint(geom)
        coords = GeoInterface.getcoords(geom)
        println("Point coordinates: $coords")
    end
end
