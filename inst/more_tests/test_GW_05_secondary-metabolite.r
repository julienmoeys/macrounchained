
# +--------------------------------------------------------+
# | Test of secondary metabolites. Not an official FOCUS   |
# | dummy substance and metabolites. Called here GW-M      |
# |                                                        |
# | The results are compared with those initially obtained |
# | with macrounchained, in order to detect accidental     |
# | changes. No benchmark currently available to compare   |
# | with in the case of secondary metabolites              |
# +--------------------------------------------------------+



rm(list=ls(all=TRUE)) 

prj_name  <- "macrounchained" 
pkg_name  <- "macrounchained"
test_name <- "test_GW_04_two-applications"

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

param <- data.frame( 
    "id"                = c(     1L,       2L,       3L ), 
    "name"              = c( "GW-M", "Met-M1", "Met-M2" ), 
    "kfoc"              = c(     12,     114,        46 ), 
    "nf"                = c(      1,     0.9,       0.9 ), 
    "dt50"              = c(     23,      19,       136 ), 
    "dt50_ref_temp"     = c(     20,      20,        20 ), 
    "dt50_pf"           = c(      2,       2,         2 ), 
    "exp_temp_resp"     = c(  0.079,   0.079,     0.079 ), 
    "exp_moist_resp"    = c(   0.49,    0.49,      0.49 ), 
    "crop_upt_f"        = c(    0.5,     0.5,       0.5 ), 
    "diff_coef"         = c(  5E-10,   5E-10,     5E-10 ), 
    "parent_id"         = c(     NA,      1L,        2L ), 
    "g_per_mol"         = c(    381,     183,       140 ), 
    "transf_f"          = c(     NA,     0.2,       1.0 ), # mol met formed / mol parent degraded
    "g_as_per_ha"       = c(     6,        0,         0 ), 
    "app_j_day"         = c(   309L,    309L,      309L ), 
    stringsAsFactors    = FALSE 
)   



parfile <- system.file( "par-files", 
    "chat_winCer_GW-X_900gHa_d182.par", package = "rmacrolite" )



res <- macrounchainedFocusGW( 
    s         = param, 
    parfile   = parfile, 
    overwrite = TRUE ) 

# parfile = "inst/par-files/chat_winCer_GW-X_900gHa_d182_1910-1911.par", 

res
