Samuel G. Younkin
Tue 12 May 2015 10:59:45 AM CDT

Welcome to the Vargo repository! I hope you will be loving it!

To run the MGE data scraper simply clone Vargo into your home
directory, install DataScraper, and run `Vargo/DataScraper/bash/MGE`

Something like:

```
cd ~
git clone git@github.com:syounkin/Vargo.git
cd Vargo
R CMD INSTALL DataScraper
./DataScraper/bash/MGE
```

You will need to have knitr and XML installed.

Details:

The bash script runs the program "make" which runs R.

./DataScraper/bash/MGE
```
#!/bin/bash
## Set the location of the Vargo repository
DIR=$HOME # Mine is in my home directory
cd $DIR/Vargo/DataScraper/
make MGE &> $DIR/Vargo/log/make.log
```

./DataScraper/bash/Makefile (Called by make.  See MGE.)
```

pdf:
	R --vanilla -e 'library(roxygen2);roxygenize("./")'
	R CMD Rd2pdf --no-preview --force ../DataScraper/

html:
	R --vanilla -e 'library(roxygen2);roxygenize("./")'
	R CMD INSTALL --html --no-inst ../DataScraper/

MGE:
	/home/sgy/bin/R --vanilla -e 'library(knitr);opts_knit$$set(root.dir = ".");knit2html("./vignette/MGE.Rmd","./html/MGE.html")' # If cron fails try using the full path to R here

diagnostics:
	/home/sgy/bin/R --vanilla -e 'library(knitr);opts_knit$$set(root.dir = ".");knit2html("./vignette/diagnostics.Rmd","./html/diagnostics.html")' # If cron fails try using the full path to R here
```

The file `MGE.Rmd` contains the R script.  Make sure that DataScraper
is installed with `R CMD INSTALL Vargo/DataScraper` as well as the packages
'knitr', 'parallel' and 'XML'.

We could do without parallel if we wanted to.
