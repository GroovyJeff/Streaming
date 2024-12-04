Subject: How to efficiently find largest geodesic circle centered in country not touching any other country's land using GRASS GIS?

Just for fun, I'm trying to find the largest geodesic circle centered in a country (for example, Chile) that doesn't touch any other country's land. I've found a way to do it, but, because I've "learned GIS" through "AI", I'm worried my entire approach is wrong or inefficient and would like some advice. My method:

  - I first downloaded all the country shape files from https://gadm.org/ and put them into a `GADM` subdirectory

  - I then imported them into GRASS using commands like:

```
v.in.ogr --overwrite -o input=/vsizip/GADM/gadm41_CHL_shp.zip/gadm41_CHL_0.shp output=gadm41_CHL

v.db.dropcolumn gadm41_CHL columns=COUNTRY
```

since the COUNTRY column would create issues otherwise. The full list of commands I ran is in https://github.com/GroovyJeff/Streaming/tree/main/OffStream/20241204 under "gadm-to-shp.grass"

  - I then glued (patched) them into one big 'world' vector map using a command that starts:

`v.patch --overwrite -e output=world input=gadm41_ABW,gadm41_AFG,gadm41_AGO,gadm41_AIA,gadm41_ALA,gadm41_ALB,gadm41_AND,gadm41_ARE,gadm41_ARG,gadm41_ARM,gadm41_ASM,gadm41_ATA,gadm41_ATF,gadm41_ATG,gadm41_AUS...`

The full command is in https://github.com/GroovyJeff/Streaming/tree/main/OffStream/20241204 under "superpatch.grass"

This did yield some errors which I ignored: I don't think these errors affected my results.

  - I then decided to rasterize the maps so I could use `r.grow.distance`, which may be a fundamental error since I'd have preferred to use the more precise vector maps directly. Other issues with rasterization:

    - I ended up rasterizing at 2048 rows by 4096 columns which is very low resolution (about 10km per pixel). I did try and could use higher resolutions, but `r.grow.distance` slows down drastically. I understand there's a time-accuracy tradeoff here, but when I get to my preferred resolution of 1 km (21600 rows by 43200 columns), `r.grow.distance` is painfully slow

    - I used `v.to.rast` to stay within GRASS, but wanted to use `gdal_rasterize` since its `-at` option ensures even the smallest islands are given one pixel. I couldn't find a `v.to.rast` option to do that. It seems like `-d` (densify) might work, but I'm converting areas and it won't let me use `-d` with areas

The commands I used to rasterize Chile and "not Chile" are:

```
g.region n=90 s=-90 e=180 w=-180 rows=4096 cols=8192

v.to.rast use=attr attr=cat input=world where='GID_0 NOT IN ("CHL")' output=notCHL --overwrite

v.to.rast type=point,line,boundary,area use=attr attr=cat input=gadm41_CHL output=justCHL --overwrite
```

  - I then used `r.grow.distance` to compute the nearest distance to a non-Chilean point:

`r.grow.distance -m --overwrite input=notCHL distance=notCHLDistance metric=geodesic`

  - This yields the furthest distance from non-Chilean countries, but the maximum isn't itself guaranteed to be in Chile (and, in fact, is not). Therefore, we intersect with Chile:

`r.mapcalc --overwrite "CHLDist = if(justCHL > 0, notCHLDistance, 0)"`

  - We can then use `r.stats` to find the point in Chile that's furthest from not Chile:

`r.stats -1gn CHLDist | sort -k3nr | head`

The result, `-109.27001953125 -27.09228515625 1930072.156897064` is unsurprisingly on the remote Pascua Island of Chile.

Could I have done this more efficiently, more accurately, or better in some other way?

I've also tried doing something similar using the Julia programming language, but haven't found a notably better non-GRASS solution.





*** bits and pieces, not formal, axis of inacc

TODO: push git, insert URLs, SPELL