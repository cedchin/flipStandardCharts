#' Radar
#'
#' Radar chart, also known as web chart, spider chart, star chart, star plot, cobweb chart, irregular polygon, polar chart, or Kiviat diagram
#'
#' @inherit Column
#' @param x Input data in the form of a vector or matrix. The categories used
#' to create the radar (i.e. the x-axis) is taken from the names/rownames of x.
#' @param opacity Opacity of area fill colors as an alpha value (0 to 1).
#' @param pad.left Spacing on the left of the chart. Mainly used by SmallMultiples.
#' @param pad.right Spacing on the right of the chart. Mainly used by SmallMultiples.
#' @param y.tick.show Whether to display the y-axis tick labels (i.e. radial distance from center)
#' @param x.tick.show  Whether to display the x-axis tick labels (i.e. labels around the sides of the radar chart)
#' @param line.thickness Thickness of outline of radar polygons.
#' @param hovertext.show Logical; whether to show hovertext.
#' @param aspect.fixed Logical; whether to fix aspect ratio. This should usually be set to true to avoid
#'      making a particular category look larger than the others. However, it is not supported with small-multiples.
#' @importFrom grDevices rgb
#' @importFrom flipChartBasics ChartColors
#' @importFrom plotly plot_ly layout config
#' @importFrom flipFormat FormatAsReal
#' @export
Radar <- function(x,
                    title = "",
                    title.font.family = global.font.family,
                    title.font.color = global.font.color,
                    title.font.size = 16,
                    colors = ChartColors(max(1, ncol(x), na.rm = TRUE)),
                    opacity = NULL,
                    aspect.fixed = TRUE,
                    background.fill.color =  "transparent",
                    background.fill.opacity = 1,
                    charting.area.fill.color = background.fill.color,
                    charting.area.fill.opacity = 0,
                    legend.show = NA,
                    legend.orientation = "Vertical",
                    legend.wrap = TRUE,
                    legend.wrap.nchar = 30,
                    legend.fill.color = background.fill.color,
                    legend.fill.opacity = 0,
                    legend.border.color = rgb(44, 44, 44, maxColorValue = 255),
                    legend.border.line.width = 0,
                    legend.font.color = global.font.color,
                    legend.font.family = global.font.family,
                    legend.font.size = 10,
                    legend.ascending = NA,
                    legend.position.y = NULL,
                    legend.position.x = NULL,
                    hovertext.font.family = global.font.family,
                    hovertext.font.size = 11,
                    margin.top = NULL,
                    margin.bottom = NULL,
                    margin.left = NULL,
                    margin.right = NULL,
                    margin.inner.pad = NULL,
                    pad.left = 0,
                    pad.right = 0,
                    line.thickness = 3,
                    tooltip.show = TRUE,
                    modebar.show = FALSE,
                    global.font.family = "Arial",
                    global.font.color = rgb(44, 44, 44, maxColorValue = 255),
                    grid.show = TRUE,
                    x.tick.show = TRUE,
                    x.tick.font.color = global.font.color,
                    x.tick.font.family = global.font.family,
                    x.tick.font.size = 12,
                    x.grid.width = 1 * grid.show,
                    x.grid.color = rgb(225, 225, 225, maxColorValue = 255),
                    y.bounds.maximum = NULL,
                    y.tick.distance = NULL,
                    y.grid.width = 1 * grid.show,
                    y.grid.color = rgb(225, 225, 225, maxColorValue = 255),
                    y.tick.show = TRUE,
                    y.tick.suffix = "",
                    y.tick.prefix = "",
                    y.tick.format = "",
                    hovertext.show = TRUE,
                    y.hovertext.format = "",
                    y.tick.font.color = global.font.color,
                    y.tick.font.family = global.font.family,
                    y.tick.font.size = 10,
                    x.tick.label.wrap = TRUE,
                    x.tick.label.wrap.nchar = 21,
                    data.label.show = FALSE,
                    data.label.font.family = global.font.family,
                    data.label.font.size = 10,
                    data.label.font.color = global.font.color,
                    data.label.format = "",
                    data.label.prefix = "",
                    data.label.suffix = "",
                    subtitle = "",
                    subtitle.font.family = global.font.family,
                    subtitle.font.color = global.font.color,
                    subtitle.font.size = 12,
                    footer = "",
                    footer.font.family = global.font.family,
                    footer.font.color = global.font.color,
                    footer.font.size = 8,
                    footer.wrap = TRUE,
                    footer.wrap.nchar = 100)
{
    # Check data
    ErrorIfNotEnoughData(x)
    chart.matrix <- checkMatrixNames(x)
    if (any(!is.finite(chart.matrix)))
        stop("Radar charts cannot contain missing or non-finite values.\n")
    if (any(chart.matrix < 0))
        stop("Radar charts cannot have negative values.\n")
    n <- nrow(chart.matrix)
    m <- ncol(chart.matrix)

    legend.show <- setShowLegend(legend.show, NCOL(chart.matrix))
    if (is.null(n) || n == 1 || m == 1)
    {
        # only 1 series
        chart.matrix <- data.frame(x = chart.matrix, check.names = FALSE)
        n <- nrow(chart.matrix)
        m <- ncol(chart.matrix)
    }

    if (n <= 2)
    {
        warning("Radar chart only has two or less spokes. ",
                "It may be more appropriate to use another chart type.")
    }
    if (is.null(opacity))
        opacity <- 0.4

    title.font = list(family = title.font.family, size = title.font.size, color = title.font.color)
    subtitle.font = list(family = subtitle.font.family, size = subtitle.font.size, color = subtitle.font.color)
    x.tick.font = list(family = x.tick.font.family, size = x.tick.font.size, color = x.tick.font.color)
    y.tick.font = list(family = y.tick.font.family, size = y.tick.font.size, color = y.tick.font.color)
    footer.font = list(family = footer.font.family, size = footer.font.size, color = footer.font.color)
    legend.font = list(family = legend.font.family, size = legend.font.size, color = legend.font.color)
    legend <- setLegend("Radar", legend.font, legend.ascending, legend.fill.color, legend.fill.opacity,
                        legend.border.color, legend.border.line.width, legend.position.x, legend.position.y,
                        FALSE, legend.orientation)

    # Figure out positions of y-ticks (i.e. radial axis)
    tick.vals <- NULL
    if (is.character(y.bounds.maximum))
    {
        y.bounds.maximum <- suppressWarnings(as.numeric(gsub("[ ,]", "", y.bounds.maximum)))
        y.bounds.maximum <- y.bounds.maximum[!is.na(y.bounds.maximum)]
    }
    if (length(y.bounds.maximum) == 0)
    {
        offset <- 1.0
        if (any(data.label.show))
            offset <- 1.1 + data.label.font.size/100
        y.bounds.maximum <- offset * max(chart.matrix)
    }
    if (y.bounds.maximum <= 0)
        stop("Maximum of the values axis must be greater than 0.")
    if (is.null(y.tick.distance))
    {
        base <- 10^round(log10(y.bounds.maximum) - 1)
        mult <- max(1, floor((y.bounds.maximum/base)/5))
        y.tick.distance <- base * mult
    }
    tick.vals <- seq(from = 0, to = y.bounds.maximum, by = y.tick.distance)
    r.max <- y.bounds.maximum

    # Extract formatting from d3
    stat <- attr(x, "statistic")
    #if (!is.null(stat) && grepl("%", stat, fixed = TRUE))
    #{
    #    if (hover.format.function == "") hover.format.function <- ".0%"
    #    if (tick.format.function == "") tick.format.function <- ".0%"
    #    if (data.label.format.function == "") data.label.format.function <- ".0%"
    #}
    hover.format.function <- ifelse(percentFromD3(y.hovertext.format), FormatAsPercent, FormatAsReal)
    tick.format.function <- ifelse(percentFromD3(y.tick.format), FormatAsPercent, FormatAsReal)
    data.label.format.function <- ifelse(percentFromD3(data.label.format), FormatAsPercent, FormatAsReal)

    if (y.tick.format == "")
        y.tick.decimals <- max(0, -floor(log10(min(diff(tick.vals)))))
    else
        y.tick.decimals <- decimalsFromD3(y.tick.format)
    y.hovertext.decimals <- decimalsFromD3(y.hovertext.format, y.tick.decimals)
    data.label.decimals <- decimalsFromD3(data.label.format)

    # Convert data (polar) into x, y coordinates
    pos <- do.call(rbind, lapply(as.data.frame(chart.matrix), getPolarCoord))
    pos <- data.frame(pos,
                      Name = rep(rownames(chart.matrix)[c(1:n,1)], m),
                      Group = if (NCOL(chart.matrix) == 1 && colnames(chart.matrix)[1] == "Series.1") ""
                              else rep(colnames(chart.matrix),each = n+1),
                      stringsAsFactors  =  T, check.names = F)
    chart.matrix <- rbind(chart.matrix, chart.matrix[1,])

    pos <- cbind(pos,
            HoverText=sprintf("%s: %s%s%s", pos$Name, y.tick.prefix,
                hover.format.function(unlist(chart.matrix), decimals = y.hovertext.decimals,
                                      comma.for.thousands = commaFromD3(y.hovertext.format)), y.tick.suffix),
            DataLabels=sprintf("%s: %s%s%s", rownames(chart.matrix), data.label.prefix,
                data.label.format.function(unlist(chart.matrix), decimals = data.label.decimals),
                data.label.suffix))


    # Set margins
    g.list <- unique(pos$Group)
    footer <- autoFormatLongLabels(footer, footer.wrap, footer.wrap.nchar, truncate = FALSE)
    margins <- list(b = 20, l = 0, r = 0, t = 20, inner = 0)
    if (sum(nchar(subtitle)) > 0)
        subtitle <- paste0("<br>&nbsp;", subtitle, "<br>&nbsp;") # extra vertical space
    margins <- setMarginsForText(margins, title, subtitle, footer, title.font.size,
                                 subtitle.font.size, footer.font.size)
    xaxis = list(title = "", showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE,
               categoryorder = "array", categoryarray = g.list)
    yaxis = list(title = "", showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE,
               scaleanchor = if (aspect.fixed) "x" else NULL, scaleratio = 1)

    legend.text <- autoFormatLongLabels(colnames(chart.matrix), legend.wrap, legend.wrap.nchar)
    margins <- setMarginsForLegend(margins, legend.show, legend, legend.text, type = "radar")
    margins <- setCustomMargins(margins, margin.top, margin.bottom, margin.left,
                    margin.right, margin.inner.pad)

    # Initialise plot (ensure chart area reaches y.bounds.maximum)
    p <- plot_ly(pos)
    outer <- getPolarCoord(rep(r.max, n))
    x.offset <- rep(0, nrow(outer))
    x.offset[which.min(outer[,1])] <- -pad.left
    x.offset[which.max(outer[,1])] <- pad.right
    p <- add_trace(p, x = outer[,1] + x.offset, y = outer[,2], name = "Outer", showlegend = FALSE,
                   type = "scatter", mode = "markers", opacity = 0, hoverinfo = "skip")

    # Grid lines
    grid <- NULL
    if (grid.show)
    {
        # Spokes
        grid <- apply(outer, 1, function(zz){
        return(list(type = "line", x0 = 0, y0 = 0, x1 = zz[1], y1 = zz[2], layer = "below",
                    line = list(width = x.grid.width * grid.show, color = x.grid.color)))})

        # Hexagonal grid
        for (tt in tick.vals)
        {
            gpos <- getPolarCoord(rep(tt, n))
            for (i in 1:n)
                grid[[length(grid)+1]] <- list(type = "line", layer = "below",
                     x0 = gpos[i,1], x1 = gpos[i+1,1], y0 = gpos[i,2], y1 = gpos[i+1,2],
                     line = list(width = y.grid.width * grid.show, dash = "dot",
                     xref = "x", yref = "y", color = y.grid.color))
        }
    }

    # Position of labels (x-axis)
    annotations <- NULL
    if (x.tick.show)
    {
        xanch <- rep("center", n)
        xanch[which(abs(outer[,2]) < r.max/100 & sign(outer[,1]) < 0)] <- "right"
        xanch[which(abs(outer[,2]) < r.max/100 & sign(outer[,1]) > 0)] <- "left"

        xlab <- autoFormatLongLabels(rownames(chart.matrix)[1:n],
                    x.tick.label.wrap, x.tick.label.wrap.nchar)
        font.asp <- fontAspectRatio(x.tick.font.family)
        annotations <- lapply(1:n, function(ii) list(text = xlab[ii], font = x.tick.font,
                        x = outer[ii,1], y = outer[ii,2], xref = "x", yref = "y",
                        showarrow = FALSE, yshift = outer[ii,2]/r.max * 15,
                        xanchor = xanch[ii], xshift = outer[ii,1]/r.max))
    }

    n <- length(g.list)
    if (is.null(line.thickness))
        line.thickness <- 3
    if (length(data.label.show) > 1 && n == 2) # small multiples
    {
        line.thickness <- c(line.thickness, 0)
        opacity <- c(opacity, if (opacity == 0.0) 0.2 else opacity)
    }
    else
    {
        line.thickness <- vectorize(line.thickness, n)
        opacity <- vectorize(opacity, n)
    }
    hovertext.show <- vectorize(hovertext.show, n)
    data.label.show <- vectorize(data.label.show, n)
    data.label.font.color <- vectorize(data.label.font.color, n)
    data.label.font = lapply(data.label.font.color,
        function(cc) list(family = data.label.font.family, size = data.label.font.size, color = cc))

    # Main trace
    for (ggi in 1:n)
    {
        ind <- which(pos$Group == g.list[ggi])
        p <- add_trace(p, x = pos$x[ind], y = pos$y[ind], name = legend.text[ggi],
                    type = "scatter", mode = "lines", fill = "toself",
                    fillcolor = toRGB(colors[ggi], alpha = opacity[ggi]),
                    legendgroup = g.list[ggi], showlegend = TRUE,
                    hoverinfo = "skip", hoveron = "points",
                    line = list(width = line.thickness[ggi], color = toRGB(colors[ggi])))
    }

    # Markers are added as a separate trace to allow overlapping hoverinfo
    for (ggi in n:1)
    {
        ind <- which(pos$Group == g.list[ggi])
        ind <- ind[-length(ind)] # remove last duplicated point
        p <- add_trace(p, x = pos$x[ind], y = pos$y[ind], type = "scatter", mode = "markers",
                    name = g.list[ggi], legendgroup = g.list[ggi], opacity = 0,
                    showlegend = FALSE, text = pos$HoverText[ind],
                    hovertemplate = paste0("%{text}<extra>", pos$Group[ind], "</extra>"),
                    hoverlabel = list(font = list(color = autoFontColor(colors[ggi]),
                    size = hovertext.font.size, family = hovertext.font.family)),
                    marker = list(size = 5, color = toRGB(colors[ggi])))

        if (data.label.show[ggi])
        {
            x.offset <- sign(pos$x[ind]) * 0.1 * (r.max + abs(max(pos$x[ind])))/2
            y.offset <- sign(pos$y[ind]) * 0.1 * (r.max + abs(max(pos$y[ind])))/2
            p <- add_trace(p, x = pos$x[ind] + x.offset, y = pos$y[ind] + y.offset,
                    type = "scatter", mode = "text", legendgroup = g.list[ggi],
                    showlegend = FALSE, hoverinfo = "skip", text = pos$DataLabels[ind],
                    textfont = data.label.font[[ggi]])
        }
    }
    annot.len <- length(annotations)
    annotations[[annot.len+1]] <- setFooter(footer, footer.font, margins)
    annotations[[annot.len+2]] <- setTitle(title, title.font, margins)
    annotations[[annot.len+3]] <- setSubtitle(subtitle, subtitle.font, margins)

    if (grid.show && y.grid.width > 0 && y.tick.show && !is.null(tick.vals))
    {
        for (i in 1:length(tick.vals))
            annotations[[annot.len+3+i]] <- list(x = 0, y = tick.vals[i],
                font = y.tick.font, showarrow = FALSE, xanchor = "right",
                xshift = -5, xref = "x", yref = "y",
                text = paste0(y.tick.prefix, tick.format.function(tick.vals[i],
                             decimals = y.tick.decimals), y.tick.suffix))
    }
    p <- layout(p, margin = margins,
            annotations = annotations,
            plot_bgcolor = toRGB(charting.area.fill.color, alpha = charting.area.fill.opacity),
            paper_bgcolor = toRGB(background.fill.color, alpha = background.fill.opacity),
            hovermode = if (tooltip.show) "closest" else FALSE,
            hoverlabel = list(namelength = -1, bordercolor = "transparent",
                font = list(size = hovertext.font.size, family = hovertext.font.family)),
            xaxis = xaxis, yaxis = yaxis, shapes = grid,
            legend = legend, showlegend = legend.show)


    p <- config(p, displayModeBar = modebar.show)
    p$sizingPolicy$browser$padding <- 0
    result <- list(htmlwidget = p)
    class(result) <- "StandardChart"
    result
}

