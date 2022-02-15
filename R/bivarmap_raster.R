#' Creates a bivariate raster
#'
#' Description... documentation to be continued.
#'
#' @param rasterx `[RasterLayer,SpatRaster]` \cr `RasterLayer` object (from [raster] package)
#' or `SpatRaster` (from [terra] package) representing the x (first) axis or variable
#' of the bivariate plot.
#' @param rastery `[RasterLayer,SpatRaster]` \cr `RasterLayer` object (from [raster] package)
#' or `SpatRaster` (from [terra] package) representing the y (second) axis or variable
#' of the bivariate plot.
#' @param colmatrix `[matrix]` \cr Matrix of colors to be used in the raster
#' classification and plot, created with [bivarmap::colmatrix()].
#' @param export.col.matrix To be documented.
#' @param outname To be documented
#'
#' @return A `RasterLayer` representing the bivariate map classified
#' accordingly with selected classes for each variable, for bivariate
#' map plotting.
#'
#' @examples examples/bivarmap_raster_example.R
#'
#' @export
bivarmap_raster <- function(rasterx, rastery, colmatrix = col.matrix,
                            export.col.matrix = TRUE,
                            outname = paste0("colMatrix_rasValues", names(rasterx))) {

    # export.color.matrix will export a data.frame of rastervalues and RGB codes
    # to the global environment outname defines the name of the data.frame

    # layer 1
    quanx <- terra::values(rasterx)
    tempx <- data.frame(quanx, quantile = rep(NA, length(quanx)))
    brks <- with(tempx,
                 classInt::classIntervals(quanx,
                                          n = attr(colmatrix, "nbreaks"),
                                          style = attr(colmatrix, "breakstyle"))$brks)

    ## Add (very) small amount of noise to all but the first break
    ## https://stackoverflow.com/a/19846365/1710632
    brks[-1] <- brks[-1] + seq_along(brks[-1]) * .Machine$double.eps
    r1 <- within(tempx,
                 quantile <- cut(quanx,
                                 breaks = brks,
                                 labels = 2:length(brks),
                                 include.lowest = TRUE))
    quantr <- data.frame(r1[, 2])

    # layer 2
    quany <- terra::values(rastery)
    tempy <- data.frame(quany, quantile = rep(NA, length(quany)))
    brksy <- with(tempy,
                  classInt::classIntervals(quany,
                                           n = attr(colmatrix, "nbreaks"),
                                           style = attr(colmatrix, "breakstyle"))$brks)
    brksy[-1] <- brksy[-1] + seq_along(brksy[-1]) * .Machine$double.eps
    r2 <- within(tempy,
                 quantile <- cut(quany,
                                 breaks = brksy,
                                 labels = 2:length(brksy),
                                 include.lowest = TRUE))
    quantr2 <- data.frame(r2[, 2])

    as.numeric.factor <- function(x) {
        as.numeric(levels(x))[x]
    }

    col.matrix2 <- colmatrix
    cn <- unique(colmatrix)
    for (i in 1:length(col.matrix2)) {
        ifelse(is.na(col.matrix2[i]),
               col.matrix2[i] <- 1,
               col.matrix2[i] <- which(col.matrix2[i] == cn)[1])
    }

    # Export the color.matrix to data.frame() in the global env
    # Can then save with write.table() and use in ArcMap/QGIS
    # Need to save the output raster as integer data-type
    if (export.col.matrix) {
        # create a dataframe of colours corresponding to raster values
        exportCols <- as.data.frame(cbind(
            as.vector(col.matrix2), as.vector(colmatrix),
            t(col2rgb(as.vector(colmatrix)))
        ))
        # rename columns of data.frame()
        colnames(exportCols)[1:2] <- c("rasValue", "HEX")
        # Export to the global environment
        assign(
            x = outname,
            value = exportCols,
            pos = .GlobalEnv
        )
    }
    cols <- numeric(length(quantr[, 1]))
    for (i in 1:length(quantr[, 1])) {
        a <- as.numeric.factor(quantr[i, 1])
        b <- as.numeric.factor(quantr2[i, 1])
        cols[i] <- as.numeric(col.matrix2[b, a])
    }

    # classify raster
    r <- rasterx
    # r[1:length(r)] <- cols
    terra::values(r) <- cols
    names(r) <- "bivarmap"

    # return
    return(r)
}
