R_OPTS=--no-save --no-restore --no-init-file --no-site-file # --vanilla, but without --no-environ

pdf:
	R ${R_OPTS} -e 'library(roxygen2);roxygenize("./")'
	R CMD Rd2pdf --no-preview --force ../DataScraper/

html: foo
	R ${R_OPTS} -e 'library(roxygen2);roxygenize("./")'
	R CMD INSTALL --html --no-inst ../DataScraper/
	lftp -u 'syounk5','5(9MFSfV' syounkin.com -e "cd public_html/Vargo/DataScraper; put /home/sgy/lib/R-3.1.3/library/DataScraper/html/00Index.html; quit"
	lftp -u 'syounk5','5(9MFSfV' syounkin.com -e "cd public_html/Vargo/DataScraper; put /home/sgy/lib/R-3.1.3/library/DataScraper/html/DataScraper.html; quit"
	lftp -u 'syounk5','5(9MFSfV' syounkin.com -e "cd public_html/Vargo/DataScraper; put /home/sgy/lib/R-3.1.3/library/DataScraper/html/expand_address.html; quit"
	lftp -u 'syounk5','5(9MFSfV' syounkin.com -e "cd public_html/Vargo/DataScraper; put /home/sgy/lib/R-3.1.3/library/DataScraper/html/parseEnergyTable.html; quit"
	lftp -u 'syounk5','5(9MFSfV' syounkin.com -e "cd public_html/Vargo/DataScraper; put /home/sgy/lib/R-3.1.3/library/DataScraper/html/R.css; quit"
	lftp -u 'syounk5','5(9MFSfV' syounkin.com -e "cd public_html/Vargo/DataScraper; put /home/sgy/lib/R-3.1.3/library/DataScraper/html/reshape_EnergyUseTable.html; quit"

MGE:
	/home/sgy/bin/R ${R_OPTS} -e 'library(knitr);opts_knit$$set(root.dir = ".");knit2html("./vignette/MGE.Rmd","./html/MGE.html")'
	lftp -u 'syounk5','5(9MFSfV' syounkin.com -e "cd public_html/Vargo/DataScraper; put ./html/MGE.html; quit"

postProcess:
	/home/sgy/bin/R ${R_OPTS} -e 'library(knitr);opts_knit$$set(root.dir = ".");knit2html("./vignette/postProcess.Rmd","./html/postProcess.html")'
	lftp -u 'syounk5','5(9MFSfV' syounkin.com -e "cd public_html/Vargo/DataScraper; put ./html/postProcess.html; quit"
