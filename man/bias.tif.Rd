% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\name{bias.tif}
\alias{bias.tif}
\title{Bias data}
\format{
A Geotiff file. Geographic CRS: WGS84 (+proj=longlat +datum=WGS84 +no_defs).
\itemize{
\item{1:} {Presence of cabins}
\item{NA:} {No presence of cabins}
}
}
\source{
\url{to_complete_here}
}
\description{
Raster data with bias from species distribution models. Bias here represents...
}
\examples{
(f <- system.file("raster/bias.tif", package = "bivarmap"))
raster::raster(f)

}
