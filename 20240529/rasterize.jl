using GDAL

# Define function to rasterize vector data
function rasterize(input_vector_file::AbstractString, output_raster_file::AbstractString, 
                   attribute_field::AbstractString, raster_resolution::Tuple{Float64, Float64}, 
                   output_format::AbstractString="GTiff")
    # Open vector dataset
    vector_ds = GDAL.Dataset(input_vector_file, "r")
    if vector_ds === nothing
        error("Failed to open input vector file")
    end

    # Get vector layer
    layer = vector_ds[1]

    # Create raster dataset
    x_res, y_res = raster_resolution
    options = ["BLOCKXSIZE=256", "BLOCKYSIZE=256"]
    raster_ds = GDAL.Create(output_raster_file, x_res, y_res, 1, GDAL.GDT_Byte, options)

    # Set projection and geotransform
    GDAL.SetProjection(raster_ds, layer["spatial_ref"])
    GDAL.SetGeoTransform(raster_ds, layer["geo_transform"])

    # Rasterize
    GDAL.RasterizeLayer(raster_ds, [1], layer, burn_values=[1])

    # Cleanup
    GDAL.Close(raster_ds)
    GDAL.Close(vector_ds)
    nothing
end

# Example usage
input_vector_file = "/home/jeff/20240527/gadm41_USA_0.shp"
output_raster_file = "output_raster.tif"
# attribute_field = "field_name"
attribute_field = "1"
raster_resolution = (100.0, 100.0)  # In coordinate units
output_format = "GTiff"

rasterize(input_vector_file, output_raster_file, attribute_field, raster_resolution, output_format)
