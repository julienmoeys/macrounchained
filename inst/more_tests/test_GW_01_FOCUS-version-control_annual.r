
# +--------------------------------------------------------+
# | Test FOCUS dummy groundwater (GW) substances as        |
# | in MACRO In FOCUS official version control, and        |
# | compare the output of macrounchained with the official |
# | result of the version control                          |
# |                                                        |
# | Substances applied every year (annual application      |
# | interval)                                              |
# +--------------------------------------------------------+



rm(list=ls(all=TRUE)) 

prj_name  <- "macrounchained" 
pkg_name  <- "macrounchained"
test_name <- "test_GW_01_FOCUS-version-control_annual"

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
    "id"                = c(     1L,     2L,     3L,      4L,     5L ), 
    "name"              = c( "GW-A", "GW-B", "GW-C", "Met_C", "GW-D" ), 
    "kfoc"              = c(    103,     17,    172,      52,     60 ), 
    "nf"                = 0.9, 
    "dt50"              = c(     60,     20,     20,     100,     20 ), 
    "dt50_ref_temp"     = 20, 
    "dt50_pf"           = 2, 
    "exp_temp_resp"     = 0.079, 
    "exp_moist_resp"    = c(   0.49,   0.49,   0.49,    0.7,    0.49 ), 
    "crop_upt_f"        = 0.5, 
    "diff_coef"         = 5E-10, 
    "parent_id"         = c(     NA,     NA,     NA,      3L,     NA ), 
    "g_per_mol"         = c(    300,    300,    200,     150,    300 ), 
    "transf_f"          = c(     NA,     NA,     NA, .53/.75,     NA ), # mol met formed / mol parent degraded
    "g_as_per_ha"       = c(   1000,   1000,   1000,       0,   1000 ), 
    "app_j_day"         = 298L, 
    stringsAsFactors    = FALSE ) 



res <- macrounchainedFocusGW( 
    s         = param, 
    overwrite = TRUE, 
    run       = TRUE ) 






expected_results_s <- data.frame(
    "name"           = c( "GW-A", "GW-B",  "GW-C", "Met_C", "GW-D" ), 
    "ug_per_L_rnd"   = c(   2.86,    7.2, 1.45E-5,    23.3,  0.154 ), 
    "index_period1"  = c(      7,      4,       7,       8,     10 ), 
    "index_period2"  = c(      8,      6,       8,      10,      7 ), 
    stringsAsFactors        = FALSE ) 

expected_results_w <- data.frame(
    "name"                  = c( "GW-A", "GW-B", "GW-C", "Met_C", "GW-D" ), 
    "perc_period1_mm"       = c( 256.42, 200.46, 256.42,  237.04, 307.55 ), 
    "perc_period2_mm"       = c( 237.04, 202.54, 237.04,  307.55, 256.42 ), 
    stringsAsFactors        = FALSE ) 

expected_parfiles <- data.frame(
    "name"      = c( "GW-A", "GW-B", "GW-C", "GW-C", "Met_C", "GW-D" ), 
    "is_inter"  = c(  FALSE,  FALSE,  FALSE,   TRUE,   FALSE,  FALSE ), 
    "nb_diff"   = c(     1L,     1L,     1L,     1L,      3L,     1L ), 
    "parfile"   = c( 
        "chat_winCer_GW-A_1kgHa_d298.par", 
        "chat_winCer_GW-B_1kgHa_d298.par", 
        "chat_winCer_GW-C_1kgHa_d298.par", 
        "chat_winCer_GW-C_1kgHa_d298_inter.par", 
        "chat_winCer_Met-GW-C_1kgHa_d298.par", 
        "chat_winCer_GW-D_1kgHa_d298_annual.par" 
    ), 
    stringsAsFactors        = FALSE ) 

expected_parfiles[, "parfile" ] <- system.file( 
    "par-files", 
    expected_parfiles[, "parfile" ], 
    package = "macrounchained" )




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



macrounchained:::.muc_logMessage( m = "Benchmark (par-file(s))", 
    frame = "*", verbose = verbose, log_width = log_width, 
    logfiles = log_file, append = TRUE )

op_reg <- res[["operation_register"]]
op_reg <- merge(
    x     = op_reg, 
    y     = param[, c("name","id") ], 
    by    = "id", 
    all.x = TRUE ) 

for( i in 1:nrow( expected_parfiles ) ){
    #   i <- 5L
    
    sel_subset <- 
        (op_reg[, "name" ] == expected_parfiles[ i, "name" ]) & 
        (op_reg[, "is_inter" ] == expected_parfiles[ i, "is_inter" ])
    
    op_reg0 <- op_reg[ sel_subset, ]
    
    macrounchained:::.muc_logMessage( m = "Substance: %s | id: %s | Is inter: %s)", 
        verbose = verbose, log_width = log_width, 
        logfiles = log_file, append = TRUE, values = list(
        expected_parfiles[ i, "name" ], op_reg0[ 1L, "id" ], 
        op_reg0[ 1L, "is_inter" ] ) )
    
    expected_parfile <- readLines( con = expected_parfiles[ i, "parfile" ] )
    obtained_parfile <- readLines( con = file.path( modelVar[[ "path" ]], op_reg0[ 1L, "par_file" ] ) )
    
    expected_n <- length( expected_parfile )
    obtained_n <- length( obtained_parfile )
    
    macrounchained:::.muc_logMessage( m = "Par-file comparison:", 
        verbose = verbose, log_width = log_width, 
        logfiles = log_file, append = TRUE )
    
    macrounchained:::.muc_logMessage( m = "* Number of rows. Expected %s, obtained %s (%s)", 
        verbose = verbose, log_width = log_width, 
        logfiles = log_file, append = TRUE, values = list(
        expected_n, obtained_n, 
        ifelse( test = expected_n == obtained_n, yes = "EQUAL", no = "DIFFERENCE" ) ) )
    
    if( expected_n == obtained_n ){
        compare <- expected_parfile != obtained_parfile 
        
        nb_diff <- expected_parfiles[ i, "nb_diff" ]
        
        macrounchained:::.muc_logMessage( m = "* Number of rows with differences %s (known: %s) (%s)", 
            verbose = verbose, log_width = log_width, 
            logfiles = log_file, append = TRUE, values = list(
            sum( compare ), nb_diff, 
            ifelse( test = sum( compare ) == nb_diff, yes = "EQUAL", no = "DIFFERENCE" ) ) )
        
    }   
    
}   



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
