#' Temperature and precipitation data
#'
#' Describe here...
#'
#' @examples
#' data("temprec")
#' temprec
#'
#' @source \url{where_does_it_com_from.com}
"temprec"

#' Hosts spatial data
#'
#' Global raster data with info from hosts...
#'
#' @format A Geotiff file. Geographic CRS: WGS84 (+proj=longlat +datum=WGS84 +no_defs).
#' \itemize{
#'         \item{1:} {Presence of cabins}
#'         \item{NA:} {No presence of cabins}
#' }
#'
#' @examples
#' (f <- system.file("raster/hosts.tif", package = "bivarmap"))
#' raster::raster(f)
#'
#' @name hosts.tif
#'
#' @source \url{to_complete_here}
NULL

#' Bias data
#'
#' Raster data with bias from species distribution models. Bias here represents...
#'
#' @format A Geotiff file. Geographic CRS: WGS84 (+proj=longlat +datum=WGS84 +no_defs).
#' \itemize{
#'         \item{1:} {Presence of cabins}
#'         \item{NA:} {No presence of cabins}
#' }
#'
#' @examples
#' (f <- system.file("raster/bias.tif", package = "bivarmap"))
#' raster::raster(f)
#'
#' @name bias.tif
#'
#' @source \url{to_complete_here}
NULL
