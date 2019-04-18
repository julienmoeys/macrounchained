

library( "macrounchained" )

param <- data.frame( 
    "id"                = c(     1L,     2L,         3L ), 
    "name"              = c( "GW-D", "GW-D",     "GW-A" ), 
    "kfoc"              = c(     60,     60,        103 ), 
    "nf"                = c(    0.9,    0.9,        0.9 ), 
    "dt50"              = c(     20,     20,         20 ), 
    "dt50_ref_temp"     = c(     20,     20,         20 ), 
    "dt50_pf"           = c(      2,      2,          2 ), 
    "exp_temp_resp"     = c(  0.079,  0.079,      0.079 ), 
    "exp_moist_resp"    = c(   0.49,   0.49,       0.49 ), 
    "crop_upt_f"        = c(    0.5,    0.5,        0.5 ), 
    "diff_coef"         = c(  5E-10,  5E-10,      5E-10 ), 
    "parent_id"         = c(     NA,     NA,         NA ), 
    "g_per_mol"         = c(    300,    300,        300 ), 
    "transf_f"          = c(     NA,     NA,         NA ), 
    "g_as_per_ha"       = c(   1000,   1000, "1000|950" ), 
    "app_j_day"         = c(   119L,   119L,  "298|305" ), 
    "f_int"             = 0, 
    "parfile"           = c(
        system.file( "par-files", 
            "chat_winCer_GW-X_900gHa_d182.par", 
            package = "rmacrolite" ), 
        system.file( "par-files", 
            "chat_pot_GW-X_900gHa_d182_biennial.par", 
            package = "macrounchained" ), 
        system.file( "par-files", 
            "chat_winCer_GW-X_2appln.par", 
            package = "rmacrolite" )
    ),  
    stringsAsFactors    = FALSE ) 


res <- macrounchained( 
    s               = param, 
    analyse         = macroutils2::macroutilsFocusGWConc, 
    analyse_summary = macroutils2::macroutilsFocusGWConc_summary, 
    overwrite       = TRUE, 
    run             = FALSE ) 

