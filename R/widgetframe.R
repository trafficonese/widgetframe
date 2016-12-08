#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
widgetframe <- function(url, width = '100%', height = NULL, elementId = NULL) {

  # forward options using x
  x = list(
    url = url
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'widgetframe',
    x,
    width = width,
    height = height,
    package = 'widgetframe',
    elementId = elementId
  )
}

#' Shiny bindings for widgetframe
#'
#' Output and render functions for using widgetframe within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a widgetframe
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name widgetframe-shiny
#'
#' @export
widgetframeOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'widgetframe', width, height, package = 'widgetframe')
}

#' @rdname widgetframe-shiny
#' @export
renderWidgetframe <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, widgetframeOutput, env, quoted = TRUE)
}
