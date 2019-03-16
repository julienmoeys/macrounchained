
rm(list=ls(all=TRUE)) 

#   Project name
prjName <- "macrounchained"

#   Package name (in the project)
pkgName <- "macrounchained"

setwd( file.path( Sys.getenv( x = "rPackagesDir" ), prjName, 
    pkgName ) )

library( "codeinfo" )
library( "macroutils2" )
library( "rmacrolite" )

#   Source package
source( sprintf( "R/%s.r", pkgName ) )
