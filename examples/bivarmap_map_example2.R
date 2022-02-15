#--------------
# example sarbeco
library(terra)

rasts_folder <- system.file("raster", package = "bivarmap")

# open hosts raster
ho <- system.file("raster/hosts.tif", package = "bivarmap")
hosts <- terra::rast(ho)

# open bias raster
bi <- system.file("raster/bias.tif", package = "bivarmap")
bias <- terra::rast(bi)

# resample, since the maps have different resolution
b <- terra::resample(hosts, bias) %>%
    c(bias)

# set projection
terra::crs(b) <- '+proj=longlat +datum=WGS84 +no_defs '

# transorm data to proportions
b[[1]] <- b[[1]]/ max(na.omit(values(b[[1]])))
b[[2]] <- b[[2]]/ max(na.omit(values(b[[2]])))

# plot separate rasters
plot(b, col = viridis::viridis(10))

# color matrix
colmatrix <- bivarmap::bivarmap_colmatrix(nbreaks = 10,
                                          upperleft = "cyan",
                                          upperright = "purple",
                                          bottomleft = "beige",
                                          bottomright = "brown1",
                                          xlab = names(b)[1],
                                          ylab = names(b)[2])
colmatrix

# raster
raster_col <- bivarmap::bivarmap_raster(rasterx = b[[1]],
                                        rastery = b[[2]],
                                        colmatrix = colmatrix)
raster_col

# map
bivarmap::bivarmap_map(bivarmap = raster_col,
                       colmat = colmatrix,
                       x_legend_pos = .01,
                       y_legend_pos = .1,
                       x_legend_size = .2,
                       y_legend_size = .2)
