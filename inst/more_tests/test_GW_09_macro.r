


rm(list=ls(all=TRUE)) 

prj_name  <- "macrounchained" 
pkg_name  <- "macrounchained"
test_name <- "test_GW_09_macro"

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

rmacrolite::rmacroliteSetModelVar( path = "C:/swash/MACRO52" )

# param <- data.frame( 
    # "id"                = 1L, 
    # "name"              = "GW-A", 
    # "kfoc"              = 103, 
    # "nf"                = 0.9, 
    # "dt50"              = 60, 
    # "dt50_ref_temp"     = 20, 
    # "dt50_pf"           = 2, 
    # "exp_temp_resp"     = 0.079, 
    # "exp_moist_resp"    = 0.49, 
    # "crop_upt_f"        = 0.5, 
    # "diff_coef"         = 5E-10, 
    # "g_as_per_ha"       = 1000, 
    # "app_j_day"         = 298, 
    # "f_int"             = 0, 
    # stringsAsFactors    = FALSE ) 

param <- data.frame( 
    "id"                = c(     1L,      2L ), 
    "name"              = c( "GW-C", "Met_C" ), 
    "kfoc"              = c(    172,      52 ), 
    "nf"                = 0.9, 
    "dt50"              = c(     20,     100 ), 
    "dt50_ref_temp"     = 20, 
    "dt50_pf"           = 2, 
    "exp_temp_resp"     = 0.079, 
    "exp_moist_resp"    = c(   0.49,    0.7 ), 
    "crop_upt_f"        = 0.5, 
    "diff_coef"         = 5E-10, 
    "parent_id"         = c(     NA,      1L ), 
    "g_per_mol"         = c(    200,     150 ), 
    "transf_f"          = c(     NA, .53/.75 ), # mol met formed / mol parent degraded
    "g_as_per_ha"       = c(   1000,       0 ), 
    "app_j_day"         = 298L, 
    "f_int"             = 0, 
    stringsAsFactors    = FALSE ) 



average_gw_conc <- function( x, ... ){ 
    perc_acc_mm <- sum( x[,"WWW"] * 24 )
    
    #   SSS is mass m-2 h-1
    #   Unit is mg so SSS is mg/m2/h-1 for this case
    mg_per_m2 <- sum( x[,"SSS"] * 24 )
    
    # max( x[,"mg_per_m2"] )
    
    #   Average conc, mg/m3 == ug/L
    ug_per_L <- mg_per_m2 / 
        ( perc_acc_mm/1000 )
    
    return( data.frame( "ug_per_L" = ug_per_L, 
        "perc_acc_mm" = perc_acc_mm ) )
}   



average_gw_conc_summary <- function(
    x,
    info, 
    ...
){  
    n <- length( x ) 
    
    if( !("data.frame" %in% class( info )) ){
        stop( sprintf( 
            "'info' should be a data.frame (now class %s)", 
            paste( class( info ), collapse = ", " )
        ) ) 
    }   
    
    if( nrow( info ) != n ){
        stop( sprintf( 
            "Number of rows in 'info' should be the same as number of items in 'x' (now respectively %s and %s).", 
            nrow( info ), n 
        ) ) 
    }   
    
    info_expected_cols <- c( "id", "run_id" )
    
    test_info_expected_cols <- 
        info_expected_cols %in% colnames(info)
    
    if( !all( test_info_expected_cols ) ){
        stop( sprintf( 
            "Some columns expected in 'info' are missing: %s.", 
            paste( info_expected_cols[ !test_info_expected_cols ], 
                collapse = ", " ) 
        ) ) 
    }   
    
    template_out <- data.frame(
        "ug_per_L"    = NA_real_, 
        "perc_acc_mm" = NA_real_, 
        "output_type" = "lower_boundary", 
        stringsAsFactors = FALSE 
    )   
    
    out <- lapply(
        X   = 1:n, 
        FUN = function(i){
            if( is.null( x[[ i ]] ) ){
                out_i <- data.frame(
                    info[ i,, drop = FALSE ], 
                    template_out, 
                    stringsAsFactors = FALSE )   
                
                out_i <- out_i[ -1L,, drop = FALSE ]
                
            }else{
                out_i <- template_out
                
                out_i[, "ug_per_L" ]    <- x[[ i ]][ , "ug_per_L" ] 
                out_i[, "perc_acc_mm" ] <- x[[ i ]][ , "perc_acc_mm" ] 
                
                out_i <- data.frame(
                    info[ i,, drop = FALSE ], 
                    out_i, 
                    stringsAsFactors = FALSE )   
            }   
            
            return( out_i ) 
        }   
    )   
    
    out <- do.call( what = "rbind", args = out )
    
    rownames( out ) <- NULL 
    
    return( out )
}   


parfile <- system.file( "par-files", "default_GW-X_d182_900gHa.par", 
    package = "macrounchained" )

res <- macrounchained( 
    s               = param, 
    parfile         = parfile, 
    analyse         = average_gw_conc, 
    analyse_summary = average_gw_conc_summary,
    overwrite       = TRUE, 
    run             = TRUE ) 






expected_results <- data.frame(
    "name"        = c(   "GW-C",  "Met_C" ), 
    "ug_per_L"    = c( 2.158807, 3.487456 ), 
    "perc_acc_mm" = c( 575.9063, 575.9063 ), 
    stringsAsFactors = FALSE ) 

expected_parfiles <- data.frame(
    "name"      = c( "GW-C",     "Met_C" ), 
    "nb_diff"   = c(     3L, NA_integer_ ), 
    "is_inter"  = FALSE, 
    "parfile"   = c( system.file( "par-files", 
        "default_GW-C_d298_1000gHa.par", 
        package = "macrounchained" ), NA ), 
    stringsAsFactors = FALSE ) 






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

for( i in 1L ){ # 1:nrow( expected_parfiles )
    #   i <- 1L
    
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

macrounchained:::.muc_logMessage( m = "Expected results (water and solute):", 
    verbose = verbose, log_width = log_width, 
    logfiles = log_file, append = TRUE )

macrounchained:::.muc_print( x = expected_results, 
    verbose = verbose, log_width = log_width, 
    logfiles = log_file, append = TRUE )

macrounchained:::.muc_logMessage( m = "Obtained results (water and solute):", 
    verbose = verbose, log_width = log_width, 
    logfiles = log_file, append = TRUE )

macrounchained:::.muc_print( x = obtained_results, 
    verbose = verbose, log_width = log_width, 
    logfiles = log_file, append = TRUE )

obtained_results <- obtained_results[, colnames( obtained_results ) 
    %in% colnames( expected_results ) ] 

expected_results[, colnames( expected_results ) != "name" ] <- 
    round( expected_results[, colnames( expected_results ) != "name" ], 4L )

obtained_results[, colnames( obtained_results ) != "name" ] <- 
    round( obtained_results[, colnames( obtained_results ) != "name" ], 4L )

all.equal_result <- all.equal( target = expected_results, current = obtained_results )

if( all( all.equal_result == TRUE ) ){
    macrounchained:::.muc_logMessage( m = "Test conclusions (water and solute): ALL EQUAL", 
        verbose = verbose, log_width = log_width, 
        logfiles = log_file, append = TRUE ) 

}else{
    all.equal_result <- as.character( all.equal_result )
    
    for( k in 1:length( all.equal_result ) ){
        macrounchained:::.muc_logMessage( m = "Test conclusions %s: %s", 
            verbose = verbose, log_width = log_width, 
            logfiles = log_file, append = TRUE, 
            values = list( k, all.equal_result[ k ] )) 
    }   
}   

macrounchained:::.muc_logMessage( m = "END", 
    verbose = verbose, log_width = log_width, 
    logfiles = log_file, append = TRUE )
