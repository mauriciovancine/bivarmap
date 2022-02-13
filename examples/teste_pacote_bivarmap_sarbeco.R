
# download package
#devtools::install_github("mauriciovancine/bivarmap", force = TRUE)

# open package
library(bivarmap)

#setwd('C://Users//rdelaram//Documents//bivarmap_files//')

setwd('data')

temp <- list.files(pattern="*.tif")

allr = lapply(temp, raster)

b <- brick(resample(allr[[2]], allr[[1]]), allr[[1]])

# Set projection

crs(b) <- '+proj=longlat +datum=WGS84 +no_defs '

options(digits=3)

quantile(b[[1]])

quantile(b[[2]])

# color matrix

colmatrix <- bivarmap::bivarmap_colmatrix(nbreaks = 9,
                                          xlab = names(b)[1],
                                          ylab = names(b)[2])
colmatrix

# raster

raster_col <- bivarmap::bivarmap_raster(rasterx = log(b[[1]]),
                                       rastery = b[[2]],
                                       colourmatrix = colmatrix)
raster_col

# map
bivarmap::bivarmap_map(bivarmap = raster_col,
                       colmat = colmatrix,
                       x_legend_pos = .1,
                       y_legend_pos = .1,
                       x_legend_size = .3,
                       y_legend_size = .3)

