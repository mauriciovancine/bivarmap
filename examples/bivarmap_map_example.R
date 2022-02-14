# package
library(bivarmap)

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
                                        colmatrix = colmatrix)
raster_col

# plot map
bivarmap::bivarmap_map(bivarmap = raster_col,
                       colmat = colmatrix,
                       x_legend_pos = .2,
                       y_legend_pos = .1,
                       x_legend_size = .3,
                       y_legend_size = .3)

plot(raster_col)
plot(temprec)
