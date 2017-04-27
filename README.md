
[![Project Status: Active – The project is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active) [![Last-changedate](https://img.shields.io/badge/last%20change-2017--04--26-green.svg)](/commits/master) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![keybase verified](https://img.shields.io/badge/keybase-verified-brightgreen.svg)](https://gist.github.com/bhaskarvk/46fbf2ba7b5713151d7e) [![Travis-CI Build Status](https://travis-ci.org/bhaskarvk/widgetframe.svg?branch=master)](https://travis-ci.org/bhaskarvk/widgetframe) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/bhaskarvk/widgetframe?branch=master&svg=true)](https://ci.appveyor.com/project/bhaskarvk/widgetframe) [![minimal R version](https://img.shields.io/badge/R%3E%3D-3.1.0-6666ff.svg)](https://cran.r-project.org/) [![packageversion](https://img.shields.io/badge/Package%20version-0.2.0-orange.svg?style=flat-square)](commits/master) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/widgetframe)](https://cran.r-project.org/package=widgetframe) [![](http://cranlogs.r-pkg.org/badges/grand-total/widgetframe)](http://cran.rstudio.com/web/packages/widgetframe/index.html)

widgetframe: htmlwidgets inside responsive iframes.
---------------------------------------------------

The goal of widgetframe is to be able to embed widgets inside iframes using NPR's [Pymjs](http://blog.apps.npr.org/pym.js/) library for responsive iframes.

This package provides two functions `frameableWidget`, and `frameWidget`. The `frameableWidget` is used to add extra code to a htmlwidget which allows is to be rendered inside a responsive iframe. The `frameWidget` returns a htmlwidget which displays content of another htmlwidget inside a responsive iframe.

### Current Status

-   Works With
    -   [Flex Dashboard](http://rmarkdown.rstudio.com/flexdashboard/): Check out this [Demo](https://rawgit.com/bhaskarvk/widgetframe/master/inst/examples/flexdashboard/dashboard.html).
    -   [RMarkdown](rmarkdown.rstudio.com) + [knitr](yihui.name/knitr/): Check out this [Demo](https://rawgit.com/bhaskarvk/widgetframe/master/inst/examples/rmarkdown/knitr_example.html).
    -   [RMarkdown Website](http://rmarkdown.rstudio.com/lesson-13.html): Check out this [Demo](https://rawgit.com/bhaskarvk/widgetframe/master/inst/examples/rmarkdown-website/index.html).
    -   [Xaringan Presentations](https://slides.yihui.name/xaringan/): Check out this [Demo](https://rawgit.com/bhaskarvk/widgetframe/master/inst/examples/xaringan/widgetframe.html#1).<br/>(May also work with other RMarkdown + knitr based presentations.)

<br/>

-   Does Not (Yet) Work With
    -   Shiny
    -   [bookdown](https://bookdown.org/): See [issue\#271](https://github.com/rstudio/bookdown/issues/271)
    -   [blogdown](https://github.com/rstudio/blogdown/): See [issue\#38](https://github.com/rstudio/blogdown/issues/38)

### Installation

``` r
if(!require(devtools)) {
  install.packages('devtools')
}
devtools::install_github('bhaskarvk/widgetframe')
```

### Usage

#### `frameableWidget` function.

The `frameableWidget` function should be used when you need a HTML which can be embedded in a CMS system like WordPress/blogger or a static HTML website using the [Pymjs](http://blog.apps.npr.org/pym.js/) library.

``` r
library(leaflet)
library(widgetframe)
l <- leaflet() %>% addTiles()
htmlwidgets::saveWidget(frameableWidget(l),'leaflet.html')
```

The resulting leaflet.html contains the necessary Pym.js Child initialization code and will work inside a regular iFrame or better yet a Pym.js responsive iFrame. It is expected that the site which is going to embed this widget's content has the necessary Pymjs Parent initialization code as described [here](http://blog.apps.npr.org/pym.js/).

#### `frameWidget` function

`frameWidget` function takes an existing htmlwidget as an argument and returns a new htmlwidget which when rendered, wraps the input htmlwdiget inside a responsive iFrame. This function can be used to knit htmlwidgets such that they are unaffected by the parent HTML file's CSS. This could be useful in [bookdown](https://bookdown.org/) or [R Markdown Websites](http://rmarkdown.rstudio.com/rmarkdown_websites.html) to embed widgets such that they are unaffected by the site's global CSS/JS.

You can use `widgetFrame` inside your R Markdowns as shown below.

<pre><code>```{r 01}
library(leaflet)
library(widgetframe)
l <- leaflet(height=300) %>% addTiles() %>% setView(0,0,1)
frameWidget(l)
```</code></pre>
<pre><code>```{r 02}
library(dygraphs)
ts <- dygraph(nhtemp, main = "New Haven Temperatures",
              height=250, width='95%')
frameWidget(ts)
```</code></pre>
### Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
