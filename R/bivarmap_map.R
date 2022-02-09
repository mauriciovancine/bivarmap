bivarmap_map <- function(bivarmap, colmat,
                         x_legend_pos = 0,
                         y_legend_pos = 0,
                         x_legend_size = .2,
                         y_legend_size = .2){

    usethis::use_package("raster")
    usethis::use_package("dplyr")
    usethis::use_package("ggplot2")
    usethis::use_package("cowplot")

    # Convert to dataframe for plotting with ggplot
    bivarmap_data <- raster::as.data.frame(bivarmap, xy = TRUE)
    colnames(bivarmap_data)[3] <- "bivarmap_values"

    # Make the map using ggplot
    bivarmap_gg <- ggplot(bivarmap_data, aes(x = x, y = y)) +
        geom_raster(aes(fill = bivarmap_values)) +
        scale_fill_gradientn(colours = colmat, na.value = "transparent") +
        theme_bw() +
        theme(text = element_text(size = 10, colour = "black"),
              legend.position = "none",
              plot.background = element_blank(),
              strip.text = element_text(size = 12, colour = "black"),
              axis.text.y = element_text(angle = 90, hjust = 0.5),
              axis.text = element_text(size = 12, colour = "black"),
              axis.title = element_text(size = 12, colour = "black")) +
        labs(x = "Longitude", y = "Latitude")

    map_leg <- cowplot::ggdraw() +
        cowplot::draw_plot(bivarmap_gg, 0, 0, 1, 1) +
        cowplot::draw_plot(BivLegend, x_legend_pos, y_legend_pos,
                           x_legend_size, y_legend_size)
    map_leg

}
