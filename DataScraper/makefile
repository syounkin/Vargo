R_OPTS=--no-save --no-restore --no-init-file --no-site-file # --vanilla, but without --no-environ

pdf:
	R ${R_OPTS} -e 'library(roxygen2);roxygenize("./")'
	R CMD Rd2pdf --no-preview --force ../DataScraper/

html:
	R ${R_OPTS} -e 'library(roxygen2);roxygenize("./")'
	R CMD INSTALL --html --no-inst ../DataScraper/
#	cp -v ~/R/x86_64-redhat-linux-gnu-library/3.0/DataScraper/html/* /ua/kendzior/public_html/CKGROUP/YOUNKIN/DataScraper-html/
#	cp -v ~/R/x86_64-redhat-linux-gnu-library/3.0/DataScraper/DESCRIPTION /ua/kendzior/public_html/CKGROUP/YOUNKIN/
#	cd /ua/kendzior/public_html/CKGROUP/YOUNKIN/DataScraper-html/; touch ./*.html

MGE:
	/home/sgy/bin/R ${R_OPTS} -e 'library(knitr);opts_knit$$set(root.dir = ".");knit2html("./vignette/MGE.Rmd","./html/MGE.html")'
	lftp -u 'syounk5','5(9MFSfV' syounkin.com -e "cd public_html/Vargo/DataScraper; put ./html/MGE.html; quit"
