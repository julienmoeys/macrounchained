
rm(list=ls(all=TRUE)) 

#   Project name
prjName <- "macrounchained"

#   Package name (in the project)
pkgName <- "macrounchained"

vignetteName <- "macrounchainedfocusgw-manual.%s"

setwd( file.path( Sys.getenv( x = "rPackagesDir" ), prjName, 
    pkgName ) )

pkgdown::build_site()
