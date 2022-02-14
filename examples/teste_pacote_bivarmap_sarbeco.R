# download package
#devtools::install_github("mauriciovancine/bivarmap", force = TRUE)

# open packages
library(raster)

rasts_folder <- system.file("raster", package = "bivarmap")

# open hosts raster
ho <- system.file("raster/hosts.tif", package = "bivarmap")
hosts <- raster::raster(ho)

# open bias raster
bi <- system.file("raster/bias.tif", package = "bivarmap")
bias <- raster::raster(bi)

# resample, since the maps have different resolution
b <- raster::brick(raster::resample(hosts, bias), bias)

# set projection
raster::crs(b) <- '+proj=longlat +datum=WGS84 +no_defs '

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


# comparison with dynamic repo code --------------------------------------------------------------
#https://github.com/renatamuy/dynamic/blob/main/distribution_models/023_pos_fig_bivariate.R
#
## functions
# colmat
# colmat <- function(nquantiles = 10,
#                    upperleft = rgb(0, 150, 235, maxColorValue = 255),
#                    upperright = rgb(130, 0, 80, maxColorValue = 255),
#                    bottomleft = "grey",
#                    bottomright = rgb(255, 230, 15, maxColorValue = 255),
#                    xlab = "x label",
#                    ylab = "y label"){
#
#     my.data <- seq(0, 1, .01)
#     my.class <- classIntervals(my.data, n = nquantiles, style = "quantile")
#     my.pal.1 <- findColours(my.class, c(upperleft, bottomleft))
#     my.pal.2 <- findColours(my.class, c(upperright, bottomright))
#     col.matrix <- matrix(nrow = 101, ncol = 101, NA)
#
#     for(i in 1:101){
#         my.col <- c(paste(my.pal.1[i]), paste(my.pal.2[i]))
#         col.matrix[102-i, ] <- findColours(my.class, my.col)
#     }
#
#     plot(c(1, 1), pch = 19, col = my.pal.1, cex = 0.5, xlim = c(0, 1), ylim = c(0, 1), frame.plot = F, xlab = xlab, ylab = ylab, cex.lab = 1.3)
#
#     for(i in 1:101){
#         col.temp <- col.matrix[i-1, ]
#         points(my.data, rep((i-1)/100, 101), pch = 15, col = col.temp, cex = 1)
#     }
#
#     seqs <- seq(0, 100, (100/nquantiles))
#     seqs[1] <- 1
#     col.matrix <- col.matrix[c(seqs), c(seqs)]
#
# }
#
# # bivariate map
# bivariate.map <- function(rasterx, rastery, colormatrix = col.matrix, nquantiles = 10){
#     quanmean <- getValues(rasterx)
#     temp <- data.frame(quanmean, quantile = rep(NA, length(quanmean)))
#     brks <- with(temp, quantile(unique(temp), na.rm = TRUE, probs = c(seq(0, 1, 1/nquantiles))))
#     r1 <- within(temp, quantile <- cut(quanmean, breaks = brks, labels = 2:length(brks), include.lowest = TRUE))
#     quantr <- data.frame(r1[, 2])
#     quanvar <- getValues(rastery)
#     temp <- data.frame(quanvar, quantile = rep(NA, length(quanvar)))
#     brks <- with(temp, quantile(unique(temp), na.rm = TRUE, probs = c(seq(0, 1, 1/nquantiles))))
#     r2 <- within(temp, quantile <- cut(quanvar, breaks = brks, labels = 2:length(brks), include.lowest = TRUE))
#     quantr2 <- data.frame(r2[, 2])
#     as.numeric.factor <- function(x) {as.numeric(levels(x))[x]}
#     col.matrix2 <- colormatrix
#     cn <- unique(colormatrix)
#
#     for(i in 1:length(col.matrix2)){
#         ifelse(is.na(col.matrix2[i]), col.matrix2[i] <- 1, col.matrix2[i] <- which(col.matrix2[i] == cn)[1])
#     }
#     cols <- numeric(length(quantr[, 1]))
#
#     for(i in 1:length(quantr[, 1])){
#         a <- as.numeric.factor(quantr[i, 1])
#         b <- as.numeric.factor(quantr2[i, 1])
#         cols[i] <- as.numeric(col.matrix2[b, a])
#     }
#     r <- rasterx
#     r[1:length(r)] <- cols
#     return(r)
# }
#
#
# ## bivariate map
# # col matrix
# col.matrix <- colmat(nquantiles = 10,
#                      upperleft = "cyan",
#                      upperright = "purple",
#                      bottomleft = "beige",
#                      bottomright = "brown1",
#                      xlab = "Hosts number per maximum number of hosts",
#                      ylab = "Sampling rate per maximum sampling rate" )
# col.matrix
#
# bivmap <- bivariate.map(b[[1]], b[[2]], colormatrix = col.matrix, nquantiles = 10)
# bivmap
#
# plot(bivmap, frame.plot = F, axes = F, box = F, add = F, legend = F, col = as.vector(col.matrix))
# map(interior = T, add = T)
#
# # data
# countries110 <- sf::st_as_sf(countries110)
#
# # ggplot2
# bivmap_data <- raster::rasterToPoints(bivmap) %>%
#     tibble::as_tibble()
#
# ggplot() +
#     geom_raster(data = bivmap_data, aes(x = x, y = y, fill = hosts)) +
#     scale_fill_gradientn(colours = col.matrix, na.value = "transparent") +
#     coord_fixed() +
#     theme_bw() +
#     theme(text = element_text(size = 10, colour = "black")) +
#     theme(legend.position = "none") +
#     labs(x = "Longitude", y = "Latitude")
#
