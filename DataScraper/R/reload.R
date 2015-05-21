## #options(repos="http://cran.fhcrc.org")
## if(TRUE && interactive()){
##   tryCatch({
##     source("http://bioconductor.org/biocLite.R")
##   }, error=function(e) invisible(NULL),
##             warning=function(w) message("Not connected to the net"))
## }
                                        #tryCatch(options(error=utils::recover), error=function(e) invisible(NULL))
reload <- pkg <- function(p, ...){
    detach(paste("package", p, sep=":"),
           unload=TRUE, character.only=TRUE)
    ## necessary to use base::: if SweaveListingUtils is loaded
    base:::library(p, character.only=TRUE, ...)
}
reload <- function(...) suppressWarnings(reload <- pkg(...))
