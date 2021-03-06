#' Line
#'
#' Line chart
#' @inherit Area
#' @param shape Either "linear" for straight lines between data points or "spline" for curved lines.
#' @param smoothing Numeric; smoothing if \code{shape} is "spline".
#' @param line.type Character; one of 'solid', 'dot', 'dashed'.
#' @param marker.symbols Character; marker symbols, which are only shown if marker.show = TRUE.
#'     if a vector is passed, then each element will be applied to a data series. 
#' @param data.label.position Character; one of 'top' or 'bottom'.
#' @importFrom grDevices rgb
#' @importFrom flipChartBasics ChartColors
#' @importFrom plotly plot_ly config toRGB add_trace add_text layout hide_colorbar
#' @importFrom stats loess loess.control lm predict
#' @importFrom flipFormat FormatAsPercent
#' @examples
#' z <- structure(c(1L, 2L, 3L, 4L, 5L, 2L, 3L, 4L, 5L, 6L),  .Dim = c(5L, 2L),
#'       .Dimnames = list(c("T", "U", "V", "W", "X"), c("A", "B")))
#' Line(z)
#' @export
Line <-   function(x,
                    type = "Line",
                    line.type = "Solid",
                    shape = c("linear", "spline")[1],
                    smoothing = 1,
                    colors = ChartColors(max(1, ncol(x), na.rm = TRUE)),
                    opacity = NULL,
                    fit.type = "None", # can be "Smooth" or anything else
                    fit.window.size = 2,
                    fit.line.colors = colors,
                    fit.ignore.last = FALSE,
                    fit.line.type = "dot",
                    fit.line.width = 1,
                    fit.line.name = "Fitted",
                    fit.line.opacity = 1,
                    fit.CI.show = FALSE,
                    fit.CI.colors = fit.line.colors,
                    fit.CI.opacity = 0.4,
                    global.font.family = "Arial",
                    global.font.color = rgb(44, 44, 44, maxColorValue = 255),
                    title = "",
                    title.font.family = global.font.family,
                    title.font.color = global.font.color,
                    title.font.size = 16,
                    subtitle = "",
                    subtitle.font.family = global.font.family,
                    subtitle.font.color = global.font.color,
                    subtitle.font.size = 12,
                    footer = "",
                    footer.font.family = global.font.family,
                    footer.font.color = global.font.color,
                    footer.font.size = 8,
                    footer.wrap = TRUE,
                    footer.wrap.nchar = 100,
                    grid.show = TRUE,
                    background.fill.color = "transparent",
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
                    legend.position.x = NULL,
                    legend.position.y = NULL,
                    legend.ascending = NA,
                    margin.top = NULL,
                    margin.bottom = NULL,
                    margin.left = NULL,
                    margin.right = NULL,
                    margin.inner.pad = NULL,
                    hovertext.font.family = global.font.family,
                    hovertext.font.size = 11,
                    y.title = "",
                    y.title.font.color = global.font.color,
                    y.title.font.family = global.font.family,
                    y.title.font.size = 12,
                    y.line.width = 0,
                    y.line.color = rgb(0, 0, 0, maxColorValue = 255),
                    y.tick.mark.length = 5,
                    y.bounds.minimum = NULL,
                    y.bounds.maximum = NULL,
                    y.tick.distance = NULL,
                    y.zero = TRUE,
                    y.zero.line.width = 0,
                    y.zero.line.color = rgb(225, 225, 225, maxColorValue = 255),
                    y.data.reversed = FALSE,
                    y.grid.width = 1 * grid.show,
                    y.grid.color = rgb(225, 225, 225, maxColorValue = 255),
                    y.tick.show = TRUE,
                    y.tick.suffix = "",
                    y.tick.prefix = "",
                    y.tick.format = "",
                    y.hovertext.format = y.tick.format,
                    y.tick.angle = NULL,
                    y.tick.font.color = global.font.color,
                    y.tick.font.family = global.font.family,
                    y.tick.font.size = 10,
                    x.title = "",
                    x.title.font.color = global.font.color,
                    x.title.font.family = global.font.family,
                    x.title.font.size = 12,
                    x.line.width = 0,
                    x.line.color = rgb(0, 0, 0, maxColorValue = 255),
                    x.tick.marks = "",
                    x.tick.mark.length = 5,
                    x.bounds.minimum = NULL,
                    x.bounds.maximum = NULL,
                    x.tick.distance = NULL,
                    x.zero = FALSE,
                    x.zero.line.width = 0,
                    x.zero.line.color = rgb(225, 225, 225, maxColorValue = 255),
                    x.data.reversed = FALSE,
                    x.grid.width = 0 * grid.show,
                    x.grid.color = rgb(225, 225, 225, maxColorValue = 255),
                    x.tick.show = TRUE,
                    x.tick.format = "",
                    x.tick.prefix = "",
                    x.tick.suffix = "",
                    x.hovertext.format = x.tick.format,
                    x.tick.angle = NULL,
                    x.tick.font.color = global.font.color,
                    x.tick.font.family = global.font.family,
                    x.tick.font.size = 10,
                    x.tick.label.wrap = TRUE,
                    x.tick.label.wrap.nchar = 21,
                    line.thickness = 3,
                    marker.show = NULL,
                    marker.symbols = "circle",
                    marker.colors = colors,
                    marker.opacity = NULL,
                    marker.size = 6,
                    marker.border.width = 1,
                    marker.border.colors = colors,
                    marker.border.opacity = NULL,
                    tooltip.show = TRUE,
                    modebar.show = FALSE,
                    data.label.show = FALSE,
                    data.label.position = "Top",
                    data.label.font.family = global.font.family,
                    data.label.font.color = global.font.color,
                    data.label.font.autocolor = FALSE,
                    data.label.font.size = 10,
                    data.label.format = "",
                    data.label.prefix = "",
                    data.label.suffix = "")
{
    ErrorIfNotEnoughData(x)
    # Some minimal data cleaning
    # Assume formatting and Qtable/attribute handling already done
    # Find gaps which are NOT at the ends of the series
    chart.matrix <- checkMatrixNames(x)
    if (is.null(line.thickness))
        line.thickness <- 3
    matrix.labels <- names(dimnames(chart.matrix))
    if (nchar(x.title) == 0 && length(matrix.labels) == 2)
        x.title <- matrix.labels[1]
    x.labels.full <- rownames(chart.matrix)
    if (any(is.na(chart.matrix)))
        warning("Missing values have been omitted.")

    # Constants
    if (grepl("^curved", tolower(shape)))
        shape <- "spline"
    if (grepl("^straight", tolower(shape)))
        shape <- "linear"
    if (is.null(marker.show) || marker.show == "none" || marker.show == FALSE)
    {
        marker.show <- FALSE
        series.mode <- "lines"
    } else
    {
        marker.show <- TRUE
        series.mode <- "lines+markers"
    }
    if (is.null(opacity))
        opacity <- if (fit.type == "None") 1 else 0.6
    if (is.null(marker.opacity))
        marker.opacity <- opacity
    if (is.null(marker.border.opacity))
        marker.border.opacity <- marker.opacity
    eval(colors) # not sure why, but this is necessary for bars to appear properly

    line.type <- vectorize(tolower(line.type), ncol(chart.matrix))
    marker.symbols <- vectorize(marker.symbols, ncol(chart.matrix))
    data.label.show <- vectorize(data.label.show, ncol(chart.matrix))
    dlab.color <- if (data.label.font.autocolor) colors
                  else vectorize(data.label.font.color, ncol(chart.matrix))
    dlab.pos <- vectorize(tolower(data.label.position), ncol(chart.matrix))
    dlab.prefix <- vectorize(data.label.prefix, ncol(chart.matrix), split = NULL)
    dlab.suffix <- vectorize(data.label.suffix, ncol(chart.matrix), split = NULL)
    data.label.font = lapply(dlab.color,
        function(cc) list(family = data.label.font.family, size = data.label.font.size, color = cc))
    title.font = list(family = title.font.family, size = title.font.size, color = title.font.color)
    subtitle.font = list(family = subtitle.font.family, size = subtitle.font.size, color = subtitle.font.color)
    x.title.font = list(family = x.title.font.family, size = x.title.font.size, color = x.title.font.color)
    y.title.font = list(family = y.title.font.family, size = y.title.font.size, color = y.title.font.color)
    ytick.font = list(family = y.tick.font.family, size = y.tick.font.size, color = y.tick.font.color)
    xtick.font = list(family = x.tick.font.family, size = x.tick.font.size, color = x.tick.font.color)
    footer.font = list(family = footer.font.family, size = footer.font.size, color = footer.font.color)
    legend.font = list(family = legend.font.family, size = legend.font.size, color = legend.font.color)

    legend.show <- setShowLegend(legend.show, NCOL(chart.matrix))
    legend <- setLegend(type, legend.font, legend.ascending, legend.fill.color, legend.fill.opacity,
                        legend.border.color, legend.border.line.width,
                        legend.position.x, legend.position.y, FALSE, legend.orientation)
    footer <- autoFormatLongLabels(footer, footer.wrap, footer.wrap.nchar, truncate=FALSE)

    # Format axis labels
    axisFormat <- formatLabels(chart.matrix, type, x.tick.label.wrap, x.tick.label.wrap.nchar,
                               x.tick.format, y.tick.format)
    x.range <- setValRange(x.bounds.minimum, x.bounds.maximum, axisFormat, x.zero, is.null(x.tick.distance))
    y.range <- setValRange(y.bounds.minimum, y.bounds.maximum, chart.matrix, y.zero, is.null(y.tick.distance))
    xtick <- setTicks(x.range$min, x.range$max, x.tick.distance, x.data.reversed)
    ytick <- setTicks(y.range$min, y.range$max, y.tick.distance, y.data.reversed)

    yaxis <- setAxis(y.title, "left", axisFormat, y.title.font,
                  y.line.color, y.line.width, y.grid.width * grid.show, y.grid.color,
                  ytick, ytick.font, y.tick.angle, y.tick.mark.length, y.tick.distance, y.tick.format,
                  y.tick.prefix, y.tick.suffix,
                  y.tick.show, y.zero, y.zero.line.width, y.zero.line.color,
                  y.hovertext.format)
    xaxis <- setAxis(x.title, "bottom", axisFormat, x.title.font,
                  x.line.color, x.line.width, x.grid.width * grid.show, x.grid.color,
                  xtick, xtick.font, x.tick.angle, x.tick.mark.length, x.tick.distance, x.tick.format,
                  x.tick.prefix, x.tick.suffix, x.tick.show, x.zero, x.zero.line.width, x.zero.line.color,
                  x.hovertext.format, axisFormat$labels)

    # Data label formatting
    data.label.function <- ifelse(percentFromD3(data.label.format), FormatAsPercent, FormatAsReal)
    data.label.decimals <- decimalsFromD3(data.label.format)

    # Work out margin spacing
    margins <- list(t = 20, b = 20, r = 60, l = 80, pad = 0)
    margins <- setMarginsForAxis(margins, axisFormat, xaxis)
    margins <- setMarginsForText(margins, title, subtitle, footer, title.font.size,
                                 subtitle.font.size, footer.font.size)

    legend.text <- autoFormatLongLabels(colnames(chart.matrix), legend.wrap, legend.wrap.nchar)
    margins <- setMarginsForLegend(margins, legend.show, legend, legend.text)
    margins <- setCustomMargins(margins, margin.top, margin.bottom, margin.left,
                    margin.right, margin.inner.pad)

    ## Initiate plotly object
    p <- plot_ly(as.data.frame(chart.matrix))
    if (is.null(rownames(chart.matrix)))
        rownames(chart.matrix) <- 1:nrow(chart.matrix)
    x.labels <- axisFormat$labels
    y.labels <- colnames(chart.matrix)
    xaxis2 <- NULL

    ## Add a trace for each col of data in the matrix
    if (is.character(line.thickness))
    {
        tmp.txt <- TextAsVector(line.thickness)
        line.thickness <- suppressWarnings(as.numeric(tmp.txt))
        na.ind <- which(is.na(line.thickness))
        if (length(na.ind) == 1)
            warning("Non-numeric line thickness value '", tmp.txt[na.ind], "' was ignored.")
        if (length(na.ind) > 1)
            warning("Non-numeric line thickness values '",
            paste(tmp.txt[na.ind], collapse = "', '"), "' were ignored.")
    }
    line.thickness <- readLineThickness(line.thickness, ncol(chart.matrix))
    opacity <- opacity * rep(1, ncol(chart.matrix))
    for (i in 1:ncol(chart.matrix))
    {
        y <- as.numeric(chart.matrix[, i])
        x <- x.labels

        lines <- list(width = line.thickness[i], dash = line.type[i],
                      shape = shape, smoothing = smoothing,
                      color = toRGB(colors[i], alpha = opacity[i]))

        # add invisible line to force all categorical labels to be shown
        if (i == 1)
            p <- add_trace(p, x = x, y = rep(min(y,na.rm = T), length(x)),
                           type = "scatter", mode = "lines",
                           hoverinfo = "none", showlegend = F, opacity = 0)

        marker <- NULL
        if (!is.null(series.mode) && regexpr('marker', series.mode) >= 1)
            marker <- list(size = marker.size,
                       color = toRGB(marker.colors[i], alpha = marker.opacity),
                       symbol = marker.symbols[i],
                       line = list(
                       color = toRGB(marker.border.colors[i], alpha = marker.border.opacity),
                       width = marker.border.width))
        y.label <- y.labels[i]


        # Draw line - main trace
        if (any(!is.na(y)))
            p <- add_trace(p, x = x, y = y, type = "scatter", mode = series.mode,
                   connectgaps = FALSE, line = lines, marker = marker, name = legend.text[i],
                   showlegend = (type == "Line"), legendgroup = i,
                   text = autoFormatLongLabels(x.labels.full, wordwrap=T, truncate=F),
                   hoverlabel = list(font = list(color = autoFontColor(colors[i]),
                   size = hovertext.font.size, family = hovertext.font.family)),
                   hovertemplate = setHoverTemplate(i, xaxis, chart.matrix))

        # single points (no lines) need to be added separately
        not.na <- is.finite(y)
        is.single <- not.na & c(TRUE, !not.na[-nrow(chart.matrix)]) & c(!not.na[-1], TRUE)
        if (any(is.single) && type == "Line")
        {
            p <- add_trace(p,
                       type = "scatter",
                       mode = "markers",
                       x = x[is.single],
                       y = y[is.single],
                       legendgroup = i,
                       name = y.label,
                       marker = if (!is.null(marker)) marker
                                else list(color = toRGB(colors[i]),
                                     size = marker.size),
                       text = autoFormatLongLabels(x.labels.full[is.single], wordwrap=T, truncate=F),
                       hoverlabel = list(font = list(color = autoFontColor(colors[i]),
                       size = hovertext.font.size, family = hovertext.font.family)),
                       hovertemplate = setHoverTemplate(i, xaxis, chart.matrix),
                       showlegend = FALSE)
        }
        if (fit.type != "None")
        {
            tmp.fname <- if (ncol(chart.matrix) == 1)  fit.line.name
                     else sprintf("%s: %s", fit.line.name, y.labels[i])
            tmp.fit <- fitSeries(x, y, fit.type, fit.ignore.last, xaxis$type, fit.CI.show, fit.window.size)
            p <- add_trace(p, x = tmp.fit$x, y = tmp.fit$y, type = 'scatter', mode = "lines",
                      name = tmp.fname, legendgroup = i, showlegend = FALSE,
                      hoverlabel = list(font = list(color = autoFontColor(fit.line.colors[i]),
                      size = hovertext.font.size, family = hovertext.font.family)),
                      line = list(dash = fit.line.type, width = fit.line.width,
                      color = fit.line.colors[i], shape = 'spline'), opacity = fit.line.opacity)
            if (fit.CI.show && !is.null(tmp.fit$lb))
            {
                p <- add_trace(p, x = tmp.fit$x, y = tmp.fit$lb, type = 'scatter',
                        mode = 'lines', name = "Lower bound of 95%CI",
                        showlegend = FALSE, legendgroup = i,
                        hoverlabel = list(font = list(color = autoFontColor(fit.CI.colors[i]),
                        size = hovertext.font.size, family = hovertext.font.family)),
                        line=list(color=fit.CI.colors[i], width=0, shape='spline'))
                p <- add_trace(p, x = tmp.fit$x, y = tmp.fit$ub, type = 'scatter',
                        mode = 'lines', name = "Upper bound of 95% CI",
                        fill = "tonexty", fillcolor = toRGB(fit.CI.colors[i], alpha = fit.CI.opacity),
                        showlegend = FALSE, legendgroup = i,
                        hoverlabel = list(font = list(color = autoFontColor(fit.CI.colors[i]),
                        size = hovertext.font.size, family = hovertext.font.family)),
                        line = list(color=fit.CI.colors[i], width=0, shape='spline'))
            }
        }
    }

    # Add data labels last to ensure they show on top of the lines
    # This also overrides the hoverlabels so we need to re-create them
    # We use a text trace instead of annotations because it will toggle with the legend
    for (i in 1:ncol(chart.matrix))
    {
        if (data.label.show[i])
        {
            y <- as.numeric(chart.matrix[, i])
            x <- x.labels
            source.text <- paste(dlab.prefix[i],
                 data.label.function(chart.matrix[, i], decimals = data.label.decimals),
                 dlab.suffix[i], sep = "")

            data.label.offset <- line.thickness[i]/2
            if (marker.show)
                data.label.offset <- max(data.label.offset, marker.size)
            p <- add_trace(p, x = x, y = y, type = "scatter", name = y.label,
                   cliponaxis = FALSE, text = source.text, mode = "markers+text",
                   marker = list(size = data.label.offset, color=colors[i], opacity = 0),
                   textfont = data.label.font[[i]], textposition = dlab.pos[i],
                   showlegend = FALSE, legendgroup = i,
                   hoverlabel = list(font = list(color = autoFontColor(colors[i]),
                   size = hovertext.font.size, family = hovertext.font.family),
                   bgcolor = toRGB(colors[i], alpha = opacity)),
                   hovertemplate = setHoverTemplate(i, xaxis, chart.matrix))
        }
    }

    annot <- list(setSubtitle(subtitle, subtitle.font, margins),
                           setTitle(title, title.font, margins),
                           setFooter(footer, footer.font, margins))
    annot <- Filter(Negate(is.null), annot)

    p <- config(p, displayModeBar = modebar.show)
    p$sizingPolicy$browser$padding <- 0
    p <- layout(p,
        showlegend = legend.show,
        legend = legend,
        yaxis = yaxis,
        xaxis2 = xaxis2,
        xaxis = xaxis,
        margin = margins,
        plot_bgcolor = toRGB(charting.area.fill.color, alpha = charting.area.fill.opacity),
        paper_bgcolor = toRGB(background.fill.color, alpha = background.fill.opacity),
        annotations = annot,
        hovermode = if (tooltip.show) "closest" else FALSE,
        hoverlabel = list(namelength = -1, bordercolor = "transparent",
            font = list(size = hovertext.font.size, family = hovertext.font.family))
    )
    result <- list(htmlwidget = p)
    class(result) <- "StandardChart"
    result
}

