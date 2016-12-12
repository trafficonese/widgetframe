pymjsDependency <- function() {
  list(
    htmltools::htmlDependency(
      name = 'pymjs', version = '1.1.2',
      src = system.file('htmlwidgets/pymjs', package = 'widgetframe'),
      script = c('pym.v1.min.js')
    )
  )
}

addPymjsDependency <- function(widget) {
  widget$dependencies <- c(widget$dependencies, pymjsDependency())
  widget
}

#' Options for widget's iframe.
#' @description Taken from \href{http://blog.apps.npr.org/pym.js/api/pym.js/1.1.2/module-pym.Parent.html}{Pym.js Documentation}. In addition also check out the \href{https://developer.mozilla.org/en-US/docs/Web/HTML/Element/iframe}{iframe documentation}.
#' @param xdomain xdomain to validate messages received.
#' @param title If passed it will be assigned to the iframe title attribute.
#' @param name If passed it will be assigned to the iframe name attribute.
#' @param id If passed it will be assigned to the iframe id attribute.
#' @param allowfullscreen If TRUE it will set the iframe allowfullscreen attribute to true.
#' @param sandbox If passed it will be assigned to the iframe sandbox attribute.
#' @export
frameOptions <- function(xdomain = '*', title=NULL, name=NULL,
                         id = NULL, allowfullscreen=FALSE,
                         sandbox=NULL) {
  purrr::keep(
  list(
    xdomain = xdomain,
    title = title,
    name = name,
    id = id,
    allowfullscreen = allowfullscreen,
    sandbox = sandbox
  ), ~!is.null(.))
}

#' @title Adds pymjs initialization code to a htmlwidget.
#' @description
#' This function augments a htmlwidget so that when saved,
#' the resulting HTML document can be rendered inside a responsive iframe
#' (created using \href{http://blog.apps.npr.org/pym.js/}{Pym.js}) of another HTML document.
#' @details
#' Generate your htmlwidget in the normal way and then call this function
#' passing in your widget. Then call \code{\link[htmlwidgets]{saveWidget}()} and the saved HTML file is now embeddable inside a Pym.js iframe of another HTML document. See \href{http://blog.apps.npr.org/pym.js/}{Pym.js} documentation on how to create an HTML document with a responsive iframe.
#' @param widget The widget to add the pymjs code to.
#' @param renderCallback An optional Javascript function wrapped in \code{\link[htmlwidgets]{JS}()} which will be called when parent sends a resize event.
#' @examples \dontrun{
#' library(leaflet)
#' l <- leaflet() %>% addTiles() %>% setView(0,0,1)
#' htmlwidgets::saveWidget(
#'   widgetframe::frameableWidget(l),'some-directory-on-your-disk')
#' }
#' @seealso \code{\link{frameWidget}()}.
#' @export
frameableWidget <- function(widget, renderCallback = NULL) {
  if(!("htmlwidget" %in% class(widget))) {
    stop ("the input widget argument is not an actual htmldidget")
  }

  # is it already frameable
  if('frameablewidget' %in% class(widget)) {
    return(widget)
  }

  # Add 'frameablewidget' to the class list of this widget at the last but one position
  numClasses <- length(class(widget))
  class(widget) <- c(class(widget)[1:(numClasses-1)],
                     'frameablewidget', class(widget)[[numClasses]])

  # Padding throws off pym.js calculations
  widget$sizingPolicy$padding <- 0
  widget$sizingPolicy$viewer$padding <- 0
  widget$sizingPolicy$browser$padding <- 0

  initChildJsCode <- NULL
  if(is.null(renderCallback)) {
    initChildJsCode <- "HTMLWidgets.pymChild = new pym.Child();"
  } else {
    initChildJsCode <- sprintf("HTMLWidgets.pymChild = new pym.Child({renderCallback : %s});", renderCallback)
  }
  # Send the child widget's height after a small delay to the parent.
  initChildJsCode <- paste0(initChildJsCode,"HTMLWidgets.addPostRenderHandler(function(){setTimeout(function(){HTMLWidgets.pymChild.sendHeight();},100);});")

  widget %>%
    addPymjsDependency() %>%
    htmlwidgets::appendContent(htmltools::tags$script(initChildJsCode))
  }

#' @title A widget that wraps another widget inside a responsive iframe.
#' @description
#' Uses \href{http://blog.apps.npr.org/pym.js/}{Pym.js}.
#' Pym.js embeds and resizes an iframe responsively (width and height) within
#' its parent container. It also bypasses the usual cross-domain issues.
#'
#' @details
#' This widget can be used in places where a HTML page's CSS rules or Javascript code
#' can cause issues in a widget. Wrapping your widgets this way allows for the widget
#' code to be unaffected by the parent HTML's CSS/JS. The target widget is
#' conveniently displaed in a responsive iframe and not subject to parent HTML's CSS/JS.
#'
#' @param targetWidget The widget to embed inside an iframe.
#' @param width Defaults to 100%. You can either specify '10%', '50%' etc. or
#'  100, 200 (in pixel).
#' @param elementId The element ID of the parent widget.
#' @param options Options for the iframe.
#'
#' @import htmlwidgets
#' @examples \dontrun{
#' l <- leaflet() %>% addTiles() %>% setView(0,0,1)
#' frameWidget(l)
#' }
#'
#' @seealso \code{\link{frameOptions}()}.
#' @export
frameWidget <- function(targetWidget, width = '100%', elementId = NULL,
                        options = frameOptions()) {

  ## Add Pym.js init code to the target widget if not already done so.
  widget <- NULL
  if('frameablewidget' %in% class(targetWidget)) {
    widget <- targetWidget
  } else {
    widget <- frameableWidget(targetWidget)
  }

  widgetData = structure(
    list(
      url = 'about:blank', # this will be overwritten in the print.widgetframe function.
      options = options
    ), widget = widget )

  # create widget
  htmlwidgets::createWidget(
    name = 'widgetframe',
    x = widgetData,
    width = width,
    height = targetWidget$height, # Use target widget's height if provided
    package = 'widgetframe',
    elementId = elementId
  )
}

#' @export
print.widgetframe <- function(x, ..., view = interactive()) {

  # Should we use RStudio's viewer or simply open in a browser.
  viewer <- getOption("viewer", utils::browseURL)

  # This will be where parent widget's HTML will be written
  parentDir <- tempfile('widgetframe')
  dir.create(parentDir)

  childWidget <- attr(x$x,'widget')

  if(!is.null(childWidget)) {

    childDir <- file.path(parentDir,'widget')
    dir.create(childDir)
    childHTML <- file.path(childDir, "index.html")

    # Save child widget's HTML inside '/widget' folder inside parent widget's HTML folder.
    htmltools::save_html(
      htmltools::as.tags(childWidget, standalone=TRUE), file = childHTML)

    # Set the relative URL for child HTML
    x$x$url <- './widget/index.html'
  }

  # The parentHTML is saved after child HTML because ...
  # parent needs to know the path to the child HTML

  parentHTML <- file.path(parentDir,'index.html')
  # Save parent widget's HTML
  htmltools::save_html(
    htmltools::as.tags(x, standalone=TRUE), file = parentHTML)

  if(view) {
    viewer(parentHTML)
  }

  invisible(x)
}

#' Save a widgetframe and its child widget to HTML files
#'
#' Save a rendered widgetframe and its child widget to HTML files.
#'
#' @param widget widgetframe to save
#' @param file File to save  the parent HTML into. The child HTML will be saved to `basename(file)_widget/index.html`.
#' @param selfcontained Whether to save the parent and child HTML as a single self-contained files.
#'   (with external resources base64 encoded) or files with external resources
#'   placed in an adjacent directory.
#' @param libdir Directory to copy HTML dependencies into (defaults to
#'   filename_files).
#' @param background Text string giving the html background color of the widget.
#'   Defaults to white.
#' @param knitrOptions A list of \pkg{knitr} chunk options.
#' @export
saveWidgetframe <- function(widget, file, selfcontained = FALSE,
                             libdir = NULL,
                             background = "white", knitrOptions = list()) {
  parentWidget <- NULL
  if('widgetframe' %in% class(widget)) {
    parentWidget <- widget
  } else {
    parentWidget <- frameWidget(widget)
  }
  childDir <- file.path(
    dirname(file),
    paste0(tools::file_path_sans_ext(basename(file)),'_widget'))
  dir.create(childDir)
  childFile <- file.path(childDir,'index.html')

  parentWidget$x$url <-  paste0(
    tools::file_path_sans_ext(basename(file)),'_widget/index.html')

  childWidget <- attr(parentWidget$x,'widget')

  oldwd <- setwd(childDir)
  htmlwidgets::saveWidget(childWidget, 'index.html', selfcontained = selfcontained,
                          libdir = libdir, background = background,
                          knitrOptions = knitrOptions)
  setwd(oldwd)
  htmlwidgets::saveWidget(parentWidget, file, selfcontained = selfcontained,
                          libdir = libdir, background = background,
                          knitrOptions = knitrOptions)

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
