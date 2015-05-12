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

This script runs the MGE portion of the following Makefile.

```
R_OPTS=--no-save --no-restore --no-init-file --no-site-file # --vanilla, but without --no-environ

pdf:
	R ${R_OPTS} -e 'library(roxygen2);roxygenize("./")'
	R CMD Rd2pdf --no-preview --force ../DataScraper/

html:
	R ${R_OPTS} -e 'library(roxygen2);roxygenize("./")'
	R CMD INSTALL --html --no-inst ../DataScraper/

MGE:
	R ${R_OPTS} -e 'library(knitr);opts_knit$$set(root.dir = ".");knit2html("./vignette/MGE.Rmd","./html/MGE.html")' # If cron fails try using the full path to R here
```

The file `MGE.Rmd` contains the R script.  Make sure that DataScraper
is installed with `R CMD INSTALL Vargo/DataScraper` as well as the packages
'knitr', 'parallel' and 'XML'.

We could do without parallel if we wanted to.

