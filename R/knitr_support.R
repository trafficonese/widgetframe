knit_print.widgetframe <- function(x, ..., options = NULL) {

  # Knit child widget
  childWidget <- attr(x$x,'widget')

  # Use the chunk label if available for enclosed widget's HTML file name
  if (!is.null(options) && !is.null(options$label)) {
    # TODO We may need to sanitize options$label
    childFile <- paste0('widget_',options$label,'.html')
  } else {
    childFile <- paste0(basename(tempfile('widget_', '.')),'.html')
  }

  # Should the widget be self_contained HTML i.e. deps inlined?
  selfContained <- FALSE

  if (!is.null(options) && !is.null(options$widgetframe_self_contained) &&
     options$widgetframe_self_contained == TRUE) {
    selfContained <- TRUE
  }

  # Should dependencies of widgets of different types be isolated?
  # This has no effect if selfContained = TRUE as in that case the deps are inlined.
  isolateWidgets <- TRUE

  if (!is.null(options) && !is.null(options$widgetframe_isolate_widgets) &&
     options$widgetframe_isolate_widgets == FALSE) {
    isolateWidgets <- FALSE
  }

  # Hack-ish way to get dependencies folder for the parent document.
  # See https://github.com/yihui/knitr/issues/1390
  defWidgetsDir <- file.path(knitr::opts_chunk$get('fig.path'), 'widgets')

  widgetsDir <- NULL

  if (!is.null(options) && !is.null(options$widgetframe_widgetsdir)) {
    widgetsDir <- options$widgetframe_widgetsdir
  }

  # We need a widgetsdir if not self_contained
  if(!selfContained && is.null(widgetsDir)) {
    widgetsDir <- defWidgetsDir
  }

  # Place child widget inside `widgetsDir` if provided
  if(!is.null(widgetsDir)) {
    if(!dir.exists(widgetsDir)) {
      dir.create(widgetsDir, recursive = TRUE)
    }
    oldwd <- setwd(widgetsDir)
    on.exit(setwd(oldwd), add = TRUE)
  }

  if (file.exists(childFile)) {
    unlink(childFile, force = TRUE)
  }

  # Directory where to put child widget's dependencies.
  childWidgetLibs <- 'libs'
  # If widget dependencis should be isolated by widget type, place each widget type's
  # dependencies in seperate folder.
  # This allows mixing widgets dependent on different versions of the same JS/CSS libs.
  if(isolateWidgets) {
    widgetClass <- class(childWidget)[[1]]
    childWidgetLibs <- paste0(widgetClass,'_libs')
  }

  htmlwidgets::saveWidget(childWidget, childFile, knitrOptions = options,
                          libdir = childWidgetLibs, selfcontained = selfContained)

  # go back up since we decended into the child widget dir.
  if(!is.null(widgetsDir)) {
    setwd(oldwd)
  }

  # Point parent widget to proper path of child widget's HTML
  if(is.null(widgetsDir)) {
    x$x$url <- childFile
    # Below is a hack for bookdown to pick up dependencies
    # See https://github.com/rstudio/bookdown/issues/271
    x <- x %>%
    htmlwidgets::appendContent(
      htmltools::HTML(sprintf("<!-- widgetframe widget-href=\"%s\" -->", childFile)))
  } else {
    x$x$url <- file.path(widgetsDir,childFile)
  }

  # Knit parent widget
  NextMethod()
}

# Register the knitr_print.widgetframe as a Method of the knit_print generic.
# Shamelessly copied from htmlwidget code.
.onLoad <- function(...) {
  pkg <- 'knitr'
  generic <- 'knit_print'
  class <- 'widgetframe'
  func <- get('knit_print.widgetframe')
  if (pkg %in% loadedNamespaces()) {
    registerS3method(generic, class, func, envir = asNamespace(pkg))
  }
  setHook(
    packageEvent(pkg, "onLoad"),
    function(...) {
      registerS3method(generic, class, func, envir = asNamespace(pkg))
    }
  )
}
