
rm(list=ls(all=TRUE)) 

prj_name  <- "macrounchained" 
pkg_name  <- "macrounchained"
test_name <- "test_GW_06_import-Excel-templates"

if( as.logical( as.integer( Sys.getenv( "macrounchained_developer", unset = "0" ) ) ) ){
    rPackagesDir <- Sys.getenv( "rPackagesDir", unset = NA_character_ )
    
    if( !is.na( rPackagesDir ) ){ 
         output_dir <- file.path( rPackagesDir, prj_name, 
            pkg_name, "inst", "more_tests", "results" ) 
    }else{
        output_dir <- getwd()
    }   
}else{
    output_dir <- getwd()
}   

library( "macrounchained" )
# library( "readxl" ) 

xlsx <- system.file( "xlsx", "macrounchainedFocusGW-with-met.xlsx", 
    package = "macrounchained" ) 

param <- readxl::read_excel( 
    path = xlsx, 
    sheet = "s" )

#   Inspect
as.data.frame( param ) 



res <- macrounchainedFocusGW( 
    s         = param, 
    overwrite = TRUE, 
    run       = FALSE ) # Dry run 




xlsx2 <- system.file( "xlsx", 
    "macrounchainedFocusGW-multiple-applications.xlsx", 
    package = "macrounchained" ) 

param2 <- readxl::read_excel( 
    path = xlsx2, 
    sheet = "s" )

#   Inspect
as.data.frame( param2 ) 



res2 <- macrounchainedFocusGW( 
    s         = param2, 
    overwrite = TRUE, 
    run       = FALSE ) # Dry run 




xlsx3 <- system.file( "xlsx", 
    "macrounchainedFocusGW-every-other-year.xlsx", 
    package = "macrounchained" ) 

param3 <- readxl::read_excel( 
    path = xlsx3, 
    sheet = "s" )

#   Inspect
as.data.frame( param3 ) 



res3 <- macrounchainedFocusGW( 
    s         = param3, 
    overwrite = TRUE, 
    run       = FALSE ) # Dry run 


