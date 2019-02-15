
rm(list=ls(all=TRUE)) 

#   Project name
prjName <- "macrounchained"

#   Package name (in the project)
pkgName <- "macrounchained"

vignetteName <- "macrounchainedfocusgw-manual.%s"

setwd( file.path( Sys.getenv( x = "rPackagesDir" ), prjName, 
    pkgName ) )

#   Source package
# knitr::knit2html( input = "macrounchainedfocusgw-manual.Rmd", 
    # output = "macrounchainedfocusgw-manual.html" )



# rmarkdown::render( input = "macrounchainedfocusgw-manual.Rmd", envir = e <- new.env() )

knitr::knit( 
    input  = file.path( "vignettes", sprintf( vignetteName, "Rmd" ) ), 
    output = file.path( "vignettes", sprintf( vignetteName, "md" ) ), 
    envir  = e1 <- new.env() )

rmarkdown::render( 
    input       = file.path( "vignettes", sprintf( vignetteName, "md" ) ), 
    output_file = sprintf( vignetteName, "html" ), 
    output_dir  = file.path( getwd(), "inst", "doc" ), 
    envir       = e2 <- new.env() )

