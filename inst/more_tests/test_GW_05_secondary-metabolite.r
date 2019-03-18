
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
test_name <- "test_GW_05_secondary-metabolite"

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
    "soil"              = "chateaudun", 
    "crop"              = "cereals, winter", 
    "id"                = c(     1L,       2L,       3L ), 
    "name"              = c( "GW-M", "Met-M1", "Met-M2" ), 
    "kfoc"              = c(     12,     114,        46 ), 
    "nf"                = c(      1,     0.9,       0.9 ), 
    "dt50"              = c(     23,      19,       136 ), 
    "dt50_ref_temp"     = c(     20,      20,        20 ), 
    "dt50_pf"           = c(      2,       2,         2 ), 
    "exp_temp_resp"     = c( 0.0948,  0.0948,    0.0948 ), 
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







#   Results obtained on 2019/01/23 with MACRO In FOCUS 5.5.4 
#   macrounchained 0.9.0 (git revision: cbfe075), 
#   rmacrolite 0.9.2 (git revision: b792510) and 
#   macroutils2 2.2.1 (git revision: fafcc2b)
expected_results_s <- data.frame(
    "name"                  = c( "GW-M", "Met-M1", "Met-M2" ), 
    "target_ug_per_L_rnd"   = c(  0.140,  0.00269,  0.04150 ), 
    "target_index_period1"  = c(     14,        7,        8 ), 
    "target_index_period2"  = c(      7,       15,        2 ), 
    stringsAsFactors        = FALSE ) 

expected_results_w <- data.frame(
    "name"                  = c(    "GW-M",  "Met-M1",  "Met-M2" ), 
    "perc_period1_mm"       = c(  234.0759,  256.3556,  237.0148 ), 
    "perc_period2_mm"       = c( 256.35547,  38.68237,  19.49554 ), 
    stringsAsFactors        = FALSE ) 






res <- macrounchainedFocusGW( 
    s         = param, 
    overwrite = TRUE, 
    run       = TRUE ) 






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
