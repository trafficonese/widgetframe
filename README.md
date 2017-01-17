# widgetframe: htmlwidgets inside responsive iframes.

The goal of widgetframe is to be able to embed widgets inside iframes using NPR's [Pymjs](http://blog.apps.npr.org/pym.js/) library for responsive iframes.

This package provides two functions `frameableWidget`, and `frameWidget`. The `frameableWidget` is used to add extra code to a htmlwidget which allows is to be rendered inside a responsive iframe. The `frameWidget` returns a htmlwidget which displays content of another htmlwidget inside a responsive iframe. 

### Information

#### Project Status

[![Project Status: Active – The project is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active) [![Last-changedate](https://img.shields.io/badge/last%20change-2017--01--17-yellowgreen.svg)](/commits/master)

- Currently doesn't work inside a shiny env.
- Not heavily tested for bookdown / R Markdown site.

#### Build Status

[![Travis-CI Build Status](https://travis-ci.org/bhaskarvk/widgetframe.svg?branch=master)](https://travis-ci.org/bhaskarvk/widgetframe) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/bhaskarvk/widgetframe?branch=master&svg=true)](https://ci.appveyor.com/project/bhaskarvk/widgetframe)


### Getting Started.

#### `frameableWidget` function.

The `frameableWidget` function should be used when you need a HTML which can be embedded in a CMS system like WordPress/blogger or a static HTML website using the [Pymjs](http://blog.apps.npr.org/pym.js/) library.

```r
library(leaflet)
library(widgetframe)
l <- leaflet() %>% addTiles()
htmlwidgets::saveWidget(frameableWidget(l),'leaflet.html')
```

The resulting leaflet.html contains the necessary Pym.js Child initialization code and will work inside a regular iFrame or better yet a Pym.js responsive iFrame. It is expected that the site which is going to embed this widget's content has the necessary Pymjs Parent initialization code as described [here](http://blog.apps.npr.org/pym.js/).

#### `frameWidget` function

`frameWidget` function takes an existing htmlwidget as an argument and returns a new htmlwidget which when rendered, wraps the input htmlwdiget inside a responsive iFrame. This function can be used to knit htmlwidgets such that they are unaffected by the parent HTML file's CSS. This could be useful in [bookdown](https://bookdown.org/) or [R Markdown Websites](http://rmarkdown.rstudio.com/rmarkdown_websites.html) to embed widgets such that they are unaffected by the site's global CSS/JS.

You can use `widgetFrame` inside your R Markdowns as shown below.


<pre>
```{r 01}
library(leaflet)
library(widgetframe)
l <- leaflet(height=300) %>% addTiles() %>% setView(0,0,1)
frameWidget(l)
```
</pre>

<pre>
```{r 02}
library(dygraphs)
ts <- dygraph(nhtemp, main = "New Haven Temperatures", height=250, width='95%')
frameWidget(ts)
```
</pre>
