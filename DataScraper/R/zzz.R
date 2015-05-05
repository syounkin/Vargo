THISPKG <- "DataScraper"
.onAttach <- function(libname, pkgname) {
	version <- packageDescription("DataScraper", fields="Version")
	date <- packageDescription("DataScraper", fields="Date")
	packageStartupMessage(paste("Welcome to DataScraper version ", version, ".\nBuilt on ", date, "\n",
"~~~~~~~~~~~~~~~~~", "\n",
">()_  >()_  >()_ ", "\n",
" (__)  (__)  (__)", "\n",
"~~~~~~~~~~~~~~~~~", sep = "" ) )
}
