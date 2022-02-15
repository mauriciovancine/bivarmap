# test terra vs raster

#-----
# using raster input

# data
data("temprec")
temprec

temprec <- raster::stack(temprec)

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
plot(raster::stack(temprec, raster_col))

# plot map
bivarmap::bivarmap_map(bivarmap = raster_col,
                       colmat = colmatrix,
                       x_legend_pos = .2,
                       y_legend_pos = .1,
                       x_legend_size = .3,
                       y_legend_size = .3)

#-----
# using terra input
# all is the same, just the input is different, and the way to stack
# in the intermediate plot

# data
data("temprec")
temprec

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

# plot intermediate raster
plot(c(temprec, raster_col))

# plot map
bivarmap::bivarmap_map(bivarmap = raster_col,
                       colmat = colmatrix,
                       x_legend_pos = .2,
                       y_legend_pos = .1,
                       x_legend_size = .3,
                       y_legend_size = .3)
