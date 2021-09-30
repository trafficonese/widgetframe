# Project needs a new home.

Thank you all of you who have used this package and have contributed code/bugs/enhancements over the years. As you may have noticed I haven't been able to make any contributions to this project and others in the last two years. I was hoping to get back to developing/maintaining this package on a regular basis but my current work-life balance does not allow it and I don't see that situation changing anytime soon. 

So here is my humble request to the R geospatial community, if anyone wants to take over this project and maintain/develop it for the greater good, I will be more than happy to transfer the project over to your repo. Send me an email at bhaskarvk AT <google's mail domain>. Same offer holds of any of my other R packages that you might be interested in taking over.

**Please note that the javascripts being used in the current version are all almost 2 years old and counting and contain various security vulnerabilities. So I don't recommend anyone use this package anymore unless it is taken over and brought up to date by someone else. Until that happens please consider this project as abandonware.**

---

[![Project Status: Active – The project is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active) [![Last-changedate](https://img.shields.io/badge/last%20change-2017--12--19-green.svg)](/commits/master) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![keybase verified](https://img.shields.io/badge/keybase-verified-brightgreen.svg)](https://gist.github.com/bhaskarvk/46fbf2ba7b5713151d7e) [![Travis-CI Build Status](https://travis-ci.org/bhaskarvk/widgetframe.svg?branch=master)](https://travis-ci.org/bhaskarvk/widgetframe) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/bhaskarvk/widgetframe?branch=master&svg=true)](https://ci.appveyor.com/project/bhaskarvk/widgetframe) [![minimal R version](https://img.shields.io/badge/R%3E%3D-3.1.0-6666ff.svg)](https://cran.r-project.org/) [![packageversion](https://img.shields.io/badge/Package%20version-0.3.1-orange.svg?style=flat-square)](commits/master) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/widgetframe)](https://cran.r-project.org/package=widgetframe) [![](http://cranlogs.r-pkg.org/badges/grand-total/widgetframe)](http://cran.rstudio.com/web/packages/widgetframe/index.html)

widgetframe: htmlwidgets inside responsive iframes.
---------------------------------------------------

The goal of widgetframe is to be able to embed widgets inside iframes using NPR's [Pymjs](http://blog.apps.npr.org/pym.js/) library for responsive iframes.

This package provides two functions `frameableWidget`, and `frameWidget`. The `frameableWidget` is used to add extra code to a htmlwidget which allows it to be rendered inside a responsive iframe. The `frameWidget` returns a htmlwidget which displays content of another htmlwidget inside a responsive iframe.

### Current Status

-   Works With
    -   [Flex Dashboard](http://rmarkdown.rstudio.com/flexdashboard/): Check out this [Demo](https://rawgit.com/bhaskarvk/widgetframe/examples/flexdashboard/dashboard.html).
    -   [RMarkdown](rmarkdown.rstudio.com) + [knitr](yihui.name/knitr/): Check out this [Demo](https://rawgit.com/bhaskarvk/widgetframe/examples/rmarkdown/knitr_example.html).
    -   [RMarkdown Website](http://rmarkdown.rstudio.com/lesson-13.html): Check out this [Demo](https://rawgit.com/bhaskarvk/widgetframe/examples/rmarkdown-website/site/index.html).
    -   [Xaringan Presentations](https://slides.yihui.name/xaringan/): Check out this [Demo](https://rawgit.com/bhaskarvk/widgetframe/examples/xaringan/widgetframe.html#1).<br/>`widgetframe` should also work with other RMarkdown + knitr based presentations.
    -   [Bookdown](https://bookdown.org/) gitbook: Needs a Makefile, but works. Check out this [Demo](https://rawgit.com/bhaskarvk/widgetframe/examples/bookdown/book/index.html).
    -   [blogdown](https://github.com/rstudio/blogdown/): Check out this [Demo](https://rawgit.com/bhaskarvk/widgetframe/examples/blogdown/public/index.html).

<br/>

-   Does Not (Yet) Work With
    -   Shiny

### Installation

Release version

``` r
install.packages('widgetframe')
```

OR development version

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
