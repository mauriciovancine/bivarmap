#' @export
bivarmap_colmatrix <- function(nbreaks = 3,
                               breakstyle = "quantile",
                               upperleft = "#0096EB",
                               upperright = "#820050",
                               bottomleft = "#BEBEBE",
                               bottomright = "#FFE60F",
                               xlab = "x label",
                               ylab = "y label",
                               plotLeg = TRUE,
                               saveLeg = FALSE) {

    if (breakstyle == "sd") {
        warning("SD breaks style cannot be used.\nWill not always return the correct number of breaks.\nSee classInt::classIntervals() for details.\nResetting to quantile",
                call. = FALSE, immediate. = FALSE)
        breakstyle <- "quantile"}
    # The colours can be changed by changing the HEX codes for:
    # upperleft, upperright, bottomleft, bottomright
    # From http://www.joshuastevens.net/cartography/make-a-bivariate-choropleth-map/
    # upperleft = "#64ACBE", upperright = "#574249", bottomleft = "#E8E8E8", bottomright = "#C85A5A",
    # upperleft = "#BE64AC", upperright = "#3B4994", bottomleft = "#E8E8E8", bottomright = "#5AC8C8",
    # upperleft = "#73AE80", upperright = "#2A5A5B", bottomleft = "#E8E8E8", bottomright = "#6C83B5",
    # upperleft = "#9972AF", upperright = "#804D36", bottomleft = "#E8E8E8", bottomright = "#C8B35A",
    # upperleft = "#DA8DC8", upperright = "#697AA2", bottomleft = "#E8E8E8", bottomright = "#73BCA0",
    # Similar to Teuling, Stockli, Seneviratnea (2011) [https://doi.org/10.1002/joc.2153]
    # upperleft = "#F7900A", upperright = "#993A65", bottomleft = "#44B360", bottomright = "#3A88B5",
    # Viridis style
    # upperleft = "#FEF287", upperright = "#21908D", bottomleft = "#E8F4F3", bottomright = "#9874A1",
    # Similar to Fjeldsa, Bowie, Rahbek 2012
    # upperleft = "#34C21B", upperright = "#FFFFFF", bottomleft = "#595757",  bottomright = "#A874B8",
    # Default from original source
    # upperleft = "#0096EB", upperright = "#820050", bottomleft= "#BEBEBE", bottomright = "#FFE60F",

    my.data <- seq(0, 1, .01)

    # Default uses terciles (Lucchesi and Wikle [2017] doi: 10.1002/sta4.150)
    my.class <- classInt::classIntervals(my.data,
                                         n = nbreaks,
                                         style = breakstyle,
    )

    my.pal.1 <- classInt::findColours(my.class, c(upperleft, bottomleft))
    my.pal.2 <- classInt::findColours(my.class, c(upperright, bottomright))

    col.matrix <- matrix(nrow = 101, ncol = 101, NA)

    for (i in 1:101) {
        my.col <- c(paste(my.pal.1[i]), paste(my.pal.2[i]))
        col.matrix[102 - i, ] <- classInt::findColours(my.class, my.col)
    }

    ## need to convert this to data.table at some stage.
    col.matrix.plot <- col.matrix %>%
        as.data.frame(.) %>%
        dplyr::mutate("Y" = dplyr::row_number()) %>%
        dplyr::mutate_at(.tbl = ., .vars = dplyr::vars(starts_with("V")), .funs = list(as.character)) %>%
        tidyr::pivot_longer(data = ., cols = -Y, names_to = "X", values_to = "HEXCode") %>%
        dplyr::mutate("X" = as.integer(sub("V", "", .$X))) %>%
        dplyr::distinct(as.factor(HEXCode), .keep_all = TRUE) %>%
        dplyr::mutate(Y = rev(.$Y)) %>%
        dplyr::select(-c(4)) %>%
        dplyr::mutate("Y" = rep(seq(from = 1, to = nbreaks, by = 1), each = nbreaks),
                      "X" = rep(seq(from = 1, to = nbreaks, by = 1), times = nbreaks)) %>%
        dplyr::mutate("UID" = dplyr::row_number())

    # Use plotLeg if you want a preview of the legend
    if (plotLeg) {
        p <- ggplot2::ggplot(col.matrix.plot, ggplot2::aes(X, Y, fill = HEXCode)) +
            ggplot2::geom_tile() +
            ggplot2::scale_fill_identity() +
            ggplot2::coord_equal(expand = FALSE) +
            ggplot2::theme_void() +
            ggplot2::theme(aspect.ratio = 1,
                           axis.title = ggplot2::element_text(size = 12, colour = "black",
                                                     hjust = .5, vjust = 0),
                           axis.title.y = ggplot2::element_text(angle = 90, hjust = 0.5)) +
            ggplot2::xlab(bquote(.(xlab) ~  symbol("\256"))) +
            ggplot2::ylab(bquote(.(ylab) ~  symbol("\256")))
        print(p)
        assign(
            x = "BivLegend",
            value = p,
            pos = .GlobalEnv
        )
    }

    # Use saveLeg if you want to save a copy of the legend
    if (saveLeg) {
        ggplot2::ggsave(filename = "bivLegend.pdf", plot = p, device = "pdf",
                        path = "./", width = 4, height = 4, units = "in",
                        dpi = 300)
    }

    seqs <- seq(0, 100, (100 / nbreaks))
    seqs[1] <- 1
    col.matrix <- col.matrix[c(seqs), c(seqs)]
    attr(col.matrix, "breakstyle") <- breakstyle
    attr(col.matrix, "nbreaks") <- nbreaks

    return(col.matrix)
}
