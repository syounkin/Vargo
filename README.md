Samuel G. Younkin
Tue 12 May 2015 10:59:45 AM CDT

Welcome to the Vargo repository! I hope you will be loving it!

To run the MGE data scraper simply clone Vargo into your home
directory and run `Vargo/DataScraper/bash/MGE`

```
    #!/bin/bash
    ## Set the location of the Vargo repository
    DIR=$HOME # Mine is in my home directory
    cd $DIR/Vargo/DataScraper/
    make MGE
```

```
R_OPTS=--no-save --no-restore --no-init-file --no-site-file # --vanilla, but without --no-environ

pdf:
	R ${R_OPTS} -e 'library(roxygen2);roxygenize("./")'
	R CMD Rd2pdf --no-preview --force ../DataScraper/

html:
	R ${R_OPTS} -e 'library(roxygen2);roxygenize("./")'
	R CMD INSTALL --html --no-inst ../DataScraper/

MGE:
	/home/sgy/bin/R ${R_OPTS} -e 'library(knitr);opts_knit$$set(root.dir = ".");knit2html("./vignette/MGE.Rmd","./html/MGE.html")'
```
