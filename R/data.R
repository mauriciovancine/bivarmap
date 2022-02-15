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
#' Global raster data with Sarbecovirus bat host species number estimated
#' by ecological niche models for the present.
#'
#' @format A Geotiff file. Geographic CRS: WGS84 (+proj=longlat +datum=WGS84 +no_defs).
#'
#' @examples
#' (f <- system.file("raster/hosts.tif", package = "bivarmap"))
#' terra::rast(f)
#'
#' @name hosts.tif
#'
#' @source \url{https://www.biorxiv.org/content/10.1101/2021.12.09.471691v1}
NULL

#' Bias data
#'
#' Raster data with bias referring to sampling rates (residual bias) based on the
#' distance from occurrences to roads, rivers, airports and cities.
#'
#' @format A Geotiff file. Geographic CRS: WGS84 (+proj=longlat +datum=WGS84 +no_defs).
#'
#' @examples
#' (f <- system.file("raster/bias.tif", package = "bivarmap"))
#' terra::rast(f)
#'
#' @name bias.tif
#'
#' @source \url{https://www.biorxiv.org/content/10.1101/2021.12.09.471691v1}
NULL
