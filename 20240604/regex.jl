# THIS CODE WAS WRITTEN OFF STREAM

# per chatgpt, the first coord is upper-left corner of the upper-left pixel

file_contents = open("temp.bmp.aux.xml", "r") do file read(file, String) end

pattern = r"<GeoTransform>(.*)</GeoTransform>"

# the line below is doing a LOT of work

m = [parse(Float64, x) for x in  split(match(pattern, file_contents)[1], ",")]

# w = west, d = delta, n = north

(wlng, dlng, _, nlat, _, dlat) = m


