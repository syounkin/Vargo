
pdf:
	/home/sgy/bin/R --vanilla -e 'library(roxygen2);roxygenize("./")'
	/home/sgy/bin/R CMD Rd2pdf --no-preview --force ../DataScraper/

html:
	/home/sgy/bin/R --vanilla -e 'library(roxygen2);roxygenize("./")'
	/home/sgy/bin/R CMD INSTALL --html --no-inst ../DataScraper/

MGE:
	/home/sgy/bin/R --vanilla -e 'library(knitr);opts_knit$$set(root.dir = ".");knit2html("./vignette/MGE.Rmd","./html/MGE.html")' # If cron fails try using the full path to R here

diagnostics:
	/home/sgy/bin/R --vanilla -e 'library(knitr);opts_knit$$set(root.dir = ".");knit2html("./vignette/diagnostics.Rmd","./html/diagnostics.html")' # If cron fails try using the full path to R here
