knit_print.widgetframe <- function(x, ..., options = NULL) {

  # Knit child widget
  childWidget <- attr(x$x,'widget')

  # Use the chunk label if available for placing the enclosed widget's HTML
  if (!is.null(options) && !is.null(options$label)) {
    # TODO We may need to sanitize options$label
    childFile <- paste0('widget_',options$label,'.html')
  } else {
    childFile <- paste0(basename(tempfile('widget_', '.')),'.html')
  }

  if (file.exists(childFile)) {
    unlink(childFile, force = TRUE)
  }

  selfcontained <- FALSE

  if (!is.null(options) && !is.null(options$self_contained_widgetframes) &&
     options$self_contained_widgetframes == TRUE) {
    selfcontained <- TRUE
  }

  htmlwidgets::saveWidget(childWidget, childFile, libdir = 'widget_libs',
                          knitrOptions = options,
                          selfcontained = selfcontained)

  x$x$url <- childFile

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
