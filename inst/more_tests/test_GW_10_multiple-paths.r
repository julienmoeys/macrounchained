
# +--------------------------------------------------------+
# | Test of multiple formation pathways, from two          |
# | active substances, here named GW-M and GW-N.           |
# |                                                        |
# | See test_GW_10_multiple-paths.svg in the same folder   |
# |                                                        |
# | Some metabolites are the degradation product of        |
# | several (2 to 3) substances that are either themselves |
# | metabolites or active substances.                      |
# |                                                        |
# | The properties of the metabolite Met-M2 (here also     |
# | named Met-N2) are different from those used in the     |
# | test "test_GW_05_secondary-metabolite". This is        |
# | supposed to represent a hypothetical situation where   |
# | new properties were agreed upon for Met-N2 during the  |
# | active substance peer-review of GW-N, some years after |
# | the properties of Met-M2 were agreed upon during the   |
# | active substance peer-review of GW-M                   | 
# |                                                        |
# | These are not official FOCUS dummy substances and      |
# | metabolites.                                           |
# |                                                        |
# | The results are compared with those initially obtained |
# | with macrounchained, in order to detect accidental     |
# | changes. No benchmark are currently available for this |
# | type of degradation pathways                           |
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






#   Results obtained on 2019/05/25 with MACRO In FOCUS 5.5.4 
#   macrounchained 0.13.0 4c22338, 
#   rmacrolite 0.9.7 9a38321, 
#   macroutils2 2.2.3  ef26fd7 and 
#   codeinfo 0.1.3 a595b27
expected_results_s <- data.frame(
    "name"           = c( "GW-M", "Met-M0", "Met-M1",  "GW-N", "Met-N1", "Met-M2" ), 
    "ug_per_L_rnd"   = c( 0.0143,   0.0017, 0.000447, 1.7e-06,  0.00125,   0.0581 ), 
    "index_period1"  = c(     14,        7,       10,      11,       18,       12 ), 
    "index_period2"  = c(      5,       12,       12,       5,       17,       14 ), 
    stringsAsFactors        = FALSE ) 

expected_results_w <- data.frame(
    "name"                  = c(   "GW-M", "Met-M0", "Met-M1",   "GW-N", "Met-N1", "Met-M2" ), 
    "perc_period1_mm"       = c( 256.1885, 274.9272, 352.7683, 133.1316, 139.7017, 190.6914 ), 
    "perc_period2_mm"       = c( 356.9637, 190.6914, 190.6914, 356.9637, 136.1738, 256.1885 ), 
    stringsAsFactors        = FALSE ) 



modelVar  <- rmacrolite::rmacroliteGetModelVar() 
log_file  <- file.path( output_dir, 
    sprintf( "%s_results.txt", test_name ) )
path      <- rmacrolite::rmacroliteGetModelVar()[["path"]]
log_width <- rmacrolite::getRmlPar( "log_width" )
verbose   <- TRUE 

file.copy(
    from = file.path( path, res[["extra_files"]]["log_file"] ), 
    to   = log_file, 
    overwrite = TRUE )   



macrounchained:::.muc_logMessage( m = "Benchmark (results)", 
    frame = "*", verbose = verbose, log_width = log_width, 
    logfiles = log_file, append = TRUE )

obtained_results <- res[[ "analyse_summary_output" ]]

macrounchained:::.muc_logMessage( m = "Expected results (water):", 
    verbose = verbose, log_width = log_width, 
    logfiles = log_file, append = TRUE )

macrounchained:::.muc_print( x = expected_results_w, 
    verbose = verbose, log_width = log_width, 
    logfiles = log_file, append = TRUE )

macrounchained:::.muc_logMessage( m = "Expected results (solute):", 
    verbose = verbose, log_width = log_width, 
    logfiles = log_file, append = TRUE )

macrounchained:::.muc_print( x = expected_results_s, 
    verbose = verbose, log_width = log_width, 
    logfiles = log_file, append = TRUE )

macrounchained:::.muc_logMessage( m = "Obtained results (water and solute):", 
    verbose = verbose, log_width = log_width, 
    logfiles = log_file, append = TRUE )

macrounchained:::.muc_print( x = obtained_results, 
    verbose = verbose, log_width = log_width, 
    logfiles = log_file, append = TRUE )

obtained_results_s <- obtained_results[, colnames( obtained_results ) 
    %in% colnames( expected_results_s ) ] 

obtained_results_w <- obtained_results[, colnames( obtained_results ) 
    %in% colnames( expected_results_w ) ] 

diff_w_percent <- ( (expected_results_w[, c( "perc_period1_mm", "perc_period2_mm" ) ] - 
                obtained_results[, c( "perc_period1_mm", "perc_period2_mm" ) ]) / 
            expected_results_w[, c( "perc_period1_mm", "perc_period2_mm" ) ] ) * 100 

macrounchained:::.muc_logMessage( m = "Differences in percolation: %s to %s %% of the expected percolation", 
    verbose = verbose, log_width = log_width, 
    logfiles = log_file, append = TRUE, 
    values = list( round( min( diff_w_percent ), 2L ), round( max( diff_w_percent ), 2L ) ) ) 

test_s <- all.equal( obtained_results_s, expected_results_s, 
    check.attributes = FALSE )

if( all( is.logical( test_s ) ) ){
    macrounchained:::.muc_logMessage( m = "Test conclusions (solute): ALL EQUAL", 
        verbose = verbose, log_width = log_width, 
        logfiles = log_file, append = TRUE ) 
    
}else{
    macrounchained:::.muc_logMessage( m = "Test conclusions (solute): DIFFERENCES DETECTED", 
        verbose = verbose, log_width = log_width, 
        logfiles = log_file, append = TRUE )
}   

macrounchained:::.muc_logMessage( m = "END", 
    verbose = verbose, log_width = log_width, 
    logfiles = log_file, append = TRUE )



