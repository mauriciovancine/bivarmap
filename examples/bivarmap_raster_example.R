# data
data("temprec")
temprec

# color matrix
colmatrix <- bivarmap::bivarmap_colmatrix(nbreaks = 9,
                                          xlab = "Temperatura",
                                          ylab = "Precipitação")
colmatrix

# raster
raster_col <- bivarmap::bivarmap_raster(rasterx = temprec$temp,
                                        rastery = temprec$prec,
                                        colourmatrix = colmatrix)
raster_col
