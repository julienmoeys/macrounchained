
# +--------------------------------------------------------+
# | Test of secondary metabolites. Not an official FOCUS   |
# | dummy substance and metabolites. Called here GW-M      |
# |                                                        |
# | The results are compared with those initially obtained |
# | with macrounchained, in order to detect accidental     |
# | changes. No benchmark currently available to compare   |
# | with in the case of secondary metabolites              |
# +--------------------------------------------------------+



#   options( warn = 2, error = recover )

rm(list=ls(all=TRUE)) 

prj_name  <- "macrounchained" 
pkg_name  <- "macrounchained"
test_name <- "test_GW_10_multiple-paths"

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
    "soil"           = "chateaudun", 
    "crop"           = "cereals, spring", 
    "id"             = c(     1L,       2L,        3L,            4L,    5L,        6L ), 
    "name"           = c( "GW-M", "Met-M0",  "Met-M1",      "Met-M2", "GW-N", "Met-N1" ), 
    "kfoc"           = c(     12,       10,       114,            71,    46,        89 ), 
    "nf"             = c(      1,      0.8,       0.9,           0.9,   1.0,       0.8 ), 
    "dt50"           = c(     23,       26,        19,           128,     5,       207 ), 
    "dt50_ref_temp"  = 20, 
    "dt50_pf"        = 2, 
    "exp_temp_resp"  = 0.0948, 
    "exp_moist_resp" = 0.49, 
    "crop_upt_f"     = c(    0.5,      0.0,       0.0,           0.0,   0.0,      0.0 ), 
    "diff_coef"      = 5E-10, 
    "parent_id"      = c(     NA,      "1",     "1|2",       "1|3|6",     NA,      "5" ), 
    "g_per_mol"      = c(    381,      367,       183,           140,    395,      154 ), 
    "transf_f"       = c(     NA,    "0.2", "0.2|1.0", "0.2|1.0|1.0",     NA,    "0.8" ), # mol met formed / mol parent degraded
    "g_as_per_ha"    = c(     3,         0,         0,             0,      6,        0 ), 
    "app_j_day"      = 70L, # Day after emergence
    stringsAsFactors = FALSE 
)   

#   Reverse order to check that algorithm is re-ordering 
#   simulations
param[ 2:4, ] <- param[ 4:2, ]



res <- macrounchainedFocusGW( 
    s         = param, 
    overwrite = TRUE, 
    run       = TRUE ) 



