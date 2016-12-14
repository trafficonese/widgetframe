knit_print.widgetframe <- function(x, ..., options = NULL) {

  # Knit child widget
  childWidget <- attr(x$x,'widget')

  #outputDir <- getwd()

  # Use the chunk label if available for placing the enclosed widget's HTML
  if(!is.null(options) && !is.null(options$label)) {
    # TODO We may need to sanitize options$label
    childFile <- paste0('widget_',options$label,'.html')
  } else {
    childFile <- paste0(basename(tempfile('widget_', '.')),'.html')
  }

  #childDir <- file.path(outputDir,'widgets')
  #dir.create(childDir,recursive = TRUE, showWarnings = FALSE)
  #setwd(childDir)

  if(file.exists(childFile)) {
    unlink(childFile, force = TRUE)
  }
  # For now the child widget is selfcontained, i.e. one big HTML with JS/CSS as data URIs.
  # TODO figure out if we can read self_contained argument of the Rmd file and
  # change behavior accordingly.
  htmlwidgets::saveWidget(childWidget, childFile, libdir = 'widget_libs',
                          knitrOptions = options)
  #setwd(outputDir)

  # Set the relative URL for child HTML
  #x$x$url <- paste(basename(childDir),childFile, sep='/')
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
