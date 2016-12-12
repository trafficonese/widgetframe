knit_print.widgetframe <- function(x, ..., options = NULL) {

  # Knit child widget
  childWidget <- attr(x$x,'widget')

  outputDir <- getwd()

  childDir <- tempfile('widget_', outputDir)
  dir.create(childDir)
  setwd(childDir)
  htmlwidgets::saveWidget(childWidget, 'index.html',
                          knitrOptions = options)
  setwd(outputDir)

  # Set the relative URL for child HTML
  x$x$url <- file.path('.',basename(childDir),'index.html')

  # Knit parent widget
  NextMethod()
}

# Register the knitr_print.widgetframe as a Method of the knit_print generic.
# Shamelessly copied from htmlwidgets code.
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
