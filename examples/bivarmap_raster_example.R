# data
data("temprec")
temprec

library(terra)
temprec <- terra::rast(temprec)

# color matrix
colmatrix <- bivarmap::bivarmap_colmatrix(nbreaks = 9,
                                          xlab = "Temperatura",
                                          ylab = "Precipitação")
colmatrix

# raster
raster_col <- bivarmap::bivarmap_raster(rasterx = temprec$temp,
                                        rastery = temprec$prec,
                                        colmatrix = colmatrix)
raster_col

# plot
# raster object
plot(raster::stack(temprec, raster_col))
# terra object
plot(c(temprec, raster_col))
