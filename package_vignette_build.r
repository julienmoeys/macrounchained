
rm(list=ls(all=TRUE)) 

#   Project name
prjName <- "macrounchained"

#   Package name (in the project)
pkgName <- "macrounchained"

setwd( file.path( Sys.getenv( x = "rPackagesDir" ), prjName, 
    pkgName, "vignettes" ) )

#   Source package
# knitr::knit2html( input = "macrounchainedfocusgw-manual.Rmd", 
    # output = "macrounchainedfocusgw-manual.html" )



# rmarkdown::render( input = "macrounchainedfocusgw-manual.Rmd", envir = e <- new.env() )



knitr::knit( input = "macrounchainedfocusgw-manual.Rmd", envir = e <- new.env() )

rmarkdown::render( input = "macrounchainedfocusgw-manual.md", envir = e <- new.env() )

