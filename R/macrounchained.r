
# +--------------------------------------------------------+ 
# | Package:    See 'Package' in file ../DESCRIPTION       | 
# | Author:     Julien MOEYS                               | 
# | Language:   R                                          | 
# | Contact:    See 'Maintainer' in file ../DESCRIPTION    | 
# | License:    See 'License' in file ../DESCRIPTION       | 
# |             and file ../LICENSE                        | 
# +--------------------------------------------------------+ 



# .onAttach ================================================

#'@importFrom utils packageVersion
NULL

.onAttach <- function(# Internal. Message displayed when loading the package.
    libname, 
    pkgname  
){  
    # .rml_testDateFormat()
    
    # .rml_testDecimalSymbol() 
    
    # Welcome message
    if( interactive() ){ 
        gitRevision <- system.file( "GIT_REVISION", package = pkgname ) 
        
        if( gitRevision != "" ){ 
            gitRevision <- readLines( con = gitRevision )[ 1L ] 
            gitRevision <- strsplit( x = gitRevision, split = " ", 
                fixed = TRUE )[[ 1L ]][ 1L ]
            gitRevision <- sprintf( "(git revision: %s)", gitRevision ) 
        }else{ 
            gitRevision <- "(git revision: ?)" 
        }   
        
        msg <- sprintf( 
            "%s %s %s. For help type: help(pack='%s')", 
            pkgname, 
            as.character( utils::packageVersion( pkgname ) ), 
            gitRevision, 
            pkgname ) 
        
        packageStartupMessage( msg ) 
    }   
}   



# .muc_internals ===========================================

#   Environment that will be used to pass information from 
#   generic functions to methods or from higher level functions 
#   to lower level functions.
.muc_internals <- new.env() 



# .muc_logMessage ==========================================

.muc_justify_text <- function( 
    txt, 
    log_width = 60L, 
    indent = "    " 
){  
    txt <- strsplit( x = txt, split = " " )[[ 1L ]]
    txt[ txt == "" ] <- " "
    txt_nchar <- nchar( txt ) 
    
    output <- vector( length = length(txt), mode = "list" )
    
    current_row <- 1L
    
    for( i in 1:length(txt) ){
        if( is.null( output[[ current_row ]] ) ){
            output[[ current_row ]] <- txt[ i ]
        }else{
            tmp <- paste( output[[ current_row ]], txt[ i ], 
                sep = ifelse( test = txt[ i ] == " ", 
                yes = "", no = " " ) )
            
            if( nchar( tmp ) < log_width ){
                output[[ current_row ]] <- tmp 
            }else{
                current_row <- current_row + 1L 
                
                output[[ current_row ]] <- paste( 
                    indent, txt[ i ], sep = "" )
            }   
        }   
    }   
    
    row_not_null <- !unlist( lapply( X = output, 
        FUN = is.null ) )
    
    output <- output[ row_not_null ]
    
    output <- paste( unlist( output ), collapse = "\n" )
    
    return( output )
}

    # test_txt <- c(
        # "<1905-01-01_23:13:59> alpha beta gamma delta epsilon zeta eta theta.", 
        # "theta eta zeta epsilon delta gamma beta alpha.", 
        # "alpha beta gamma delta epsilon zeta eta theta.", 
        # "theta eta zeta epsilon delta gamma beta alpha.", 
        # "alpha beta gamma delta epsilon zeta eta theta." )
    # test_txt <- paste( test_txt, collapse = " " ) 
    # message( .muc_justify_text( txt = test_txt, log_width = 30L ) ) 

.muc_text_to_files <- function(text,logfiles,append){
    n_logfiles <- length( logfiles )
    
    if( n_logfiles != 0 ){
        if( (length( append ) == 1L) & (n_logfiles > 1L) ){
            append <- rep( append, times = n_logfiles )
        }   
        
        silence <- lapply( 
            X   = 1:n_logfiles, 
            FUN = function(i){
            con <- file( 
                description = logfiles[ i ], 
                open        = ifelse( 
                    test = append[ i ], 
                    yes  = "at", 
                    no   = "wt" ), 
                encoding    = "UTF-8" )
            
            on.exit( close( con ) )
            
            writeLines( text = text, con = con, 
                sep = "\n" )
        } )
    }   
}   

#'@importFrom utils flush.console
NULL

## # Send one or several information message(s) about work progresses
## # 
## # Send one or several information message(s) about work progresses. 
## #   Wrapper around \code{message(sprintf())}, with an additional 
## #   information about message time and date.
## # 
## # 
## # @param m
## #   See \code{fmt} in \code{\link[base]{sprintf}}. Message 
## #   to be displayed whenever \code{verbose} is >= 1.
## # 
## # @param verbose
## #   See \code{verbose} in \code{\link[rrmacrolite]{rmlPar}}.
## # 
## # @param \dots
## #   See \code{\link[base]{sprintf}}.
## # 
## # @return 
## #   Does not return anything. Output messages
## # 
## # 
## # @rdname .muc_logMessage
## # 
#'@importFrom rmacrolite getRmlPar
.muc_logMessage <- function( 
    m, 
    # fmt2 = NULL, 
    verbose = 1L, 
    fun = message, 
    # infix = "", 
    frame = NULL, 
    log_width = getRmlPar("log_width"), 
    values = NULL, # a list
    logfiles = NULL, 
    append = rep(FALSE,length(logfiles))
){  
    if( verbose >= 1L ){ 
        
        frame_not_null <- !is.null(frame)
        
        if( frame_not_null ){
            frame0 <- rep( x = substr( frame, 1L, 1L ), 
                times = log_width ) 
            
            frame0 <- paste( frame0, collapse = "" )
            
            .muc_text_to_files( text = frame0, logfiles = logfiles, 
                append = append )
            
            fun( frame0 )
        }   
        
        if( !is.null( values ) ){
            m <- do.call( what = "sprintf", 
                args = c( list( "fmt" = paste( "<%s>", m, sep = " " ), 
                format( Sys.time(), "%Y-%m-%d|%H:%M:%S" ) ), 
                values ) )
            
        }else{
            m <- sprintf( paste( "<%s>", m, sep = " " ), format( 
                Sys.time(), "%Y-%m-%d|%H:%M:%S" ) )
        }   
        
        # fun( sprintf( paste( "<%s>", m ), Sys.time(), ... ) ) 
        m <- .muc_justify_text( txt = m, log_width = log_width )
        
        .muc_text_to_files( text = m, logfiles = logfiles, 
            append = append )
        
        fun( m ) 
        
        if( frame_not_null ){
            .muc_text_to_files( text = frame0, logfiles = logfiles, 
                append = append )
            
            fun( frame0 )
        }   
        
        utils::flush.console() 
    }   
}   

    # .muc_logMessage( m = "Hello" )
    # .muc_logMessage( m = "Hello %s", values = list( "you" ) )
    # .muc_logMessage( m = "Hello %s", values = list( "you" ), infix = "    " )
    # .muc_logMessage( m = "Hello %s", values = list( "you" ), frame = "*+" )



# .muc_print ===============================================

#'@importFrom utils capture.output
.muc_print_to_files <- function(x,logfiles,append,...){
    n_logfiles <- length( logfiles )
    
    if( n_logfiles != 0 ){
        if( (length( append ) == 1L) & (n_logfiles > 1L) ){
            append <- rep( append, times = n_logfiles )
        }   
        
        dotdotdot <- list(...)
        
        silence <- lapply( 
            X   = 1:n_logfiles, 
            FUN = function(i){
            con <- file( 
                description = logfiles[ i ], 
                open        = ifelse( 
                    test = append[ i ], 
                    yes  = "at", 
                    no   = "wt" ), 
                encoding    = "UTF-8" )
            
            on.exit( close( con ) )
            
            capture.output( 
                # do.call( what = "print", args = c( list( x = x, dotdotdot ) ) ), 
                print( x = x, ... ), 
                file  = con, 
                type  = "output", 
                split = FALSE )
        } )
    }   
}   

#'@importFrom utils flush.console
#'@importFrom rmacrolite getRmlPar
.muc_print <- function( 
    x, 
    verbose = 1L, 
    log_width = getRmlPar("log_width"), 
    logfiles = NULL, 
    append = rep(FALSE,length(logfiles)), 
    ...
){  
    if( verbose >= 1L ){ 
        
        old_width <- options( "width" )[[1L]]
        on.exit( options( "width" = old_width ) )
        options( "width" = log_width )
        
        #   Print to console
        print( x = x, ... )
        
        #   Print to logfiles
        .muc_print_to_files( x = x, logfiles = logfiles, 
            append = append )
        
        options( "width" = old_width )
        on.exit( NULL ) 
        
        utils::flush.console() 
    }   
}   



# .muc_justify_path ========================================

.muc_justify_path <- function( 
    txt, 
    split = "/", 
    log_width = 60L, 
    sep = " " 
){  
    txt <- strsplit( x = txt, split = split, fixed = TRUE )[[ 1L ]]
    txt_nchar <- nchar( txt ) 
    
    output <- vector( length = length(txt), mode = "list" )
    
    current_row <- 1L
    
    for( i in 1:length(txt) ){
        if( is.null( output[[ current_row ]] ) ){
            output[[ current_row ]] <- txt[ i ]
        }else{
            tmp <- paste( output[[ current_row ]], txt[ i ], 
                sep = split )
            
            if( nchar( tmp ) < log_width ){
                output[[ current_row ]] <- tmp 
            }else{
                current_row <- current_row + 1L 
                
                output[[ current_row ]] <- paste( 
                    sep, txt[ i ], sep = "" )
            }   
        }   
    }   
    
    row_not_null <- !unlist( lapply( X = output, 
        FUN = is.null ) )
    
    output <- output[ row_not_null ]
    
    output <- paste( unlist( output ), 
        collapse = sprintf( "%s", split ) )
    
    return( output )
}



# .muc_anonymisePath =======================================

### remove user name and user profile from a path, 
### in order to preserve the user anonymity.
### To be used together with .muc_logMessage(), 
### or with sprintf( output )
.muc_anonymisePath <- function( 
    path, 
    anonymise = TRUE, 
    x2 = FALSE, 
    winslash = "/", 
    log_width = 60L, 
    sep = " " 
){  
    #   Normalise the path
    
    path <- unlist( lapply(
        X   = path, 
        FUN = function(p){
            if( !is.na( p ) ){
                p <- normalizePath( path = p, mustWork = FALSE, 
                    winslash = winslash )
            }   
            
            if( anonymise ){
                #   Fetch user name, profile and home path
                user_profile <-  Sys.getenv( "USERPROFILE", 
                    unset = NA_character_ ) 
                
                home_path <-  Sys.getenv( "HOMEPATH", 
                    unset = NA_character_ ) 
                
                user_name <- Sys.getenv( "USERNAME", 
                    unset = NA_character_ ) 
                
                if( !is.na( user_profile ) ){
                    user_profile <- normalizePath( 
                        path     = user_profile, 
                        mustWork = FALSE, 
                        winslash = winslash )
                    
                    p <- gsub( 
                        pattern     = user_profile, 
                        replacement = ifelse( x2, "%%USERPROFILE%%", 
                            "%USERPROFILE%" ), 
                        x           = p, 
                        # ignore.case = TRUE, 
                        fixed       = TRUE )
                }   
                
                if( !is.na( home_path ) ){
                    home_path <- normalizePath( 
                        path     = home_path, 
                        mustWork = FALSE, 
                        winslash = winslash )
                    
                    p <- gsub( 
                        pattern     = home_path, 
                        replacement = ifelse( x2, "%%HOMEPATH%%", 
                            "%HOMEPATH%" ), 
                        x           = p, 
                        # ignore.case = TRUE, 
                        fixed       = TRUE )
                }   
                
                if( !is.na( user_name ) ){
                    user_name <- normalizePath( 
                        path     = user_name, 
                        mustWork = FALSE, 
                        winslash = winslash )
                    
                    p <- gsub( 
                        pattern     = user_name, 
                        replacement = ifelse( x2, "%%USERNAME%%", 
                            "%USERNAME%" ), 
                        x           = p, 
                        # ignore.case = TRUE, 
                        fixed       = TRUE )
                }   
            }   
            
            p <- .muc_justify_path( 
                txt       = p, 
                split     = winslash, 
                log_width = log_width, 
                sep       = sep ) 
            
            return( p )
        }   
    ) ) 
    
    return( path ) 
}   



# .muc_vbar_to_numeric =====================================

.muc_vbar_to_numeric <- function( x ){
    if( any( c( "list", "AsIs" ) %in% class( x ) ) ){
        
        test_x <- unlist( lapply( X = x, FUN = is.character ) )
        
        if( !all( test_x ) ){
            stop( "Some items in 'x' are not character-class" )
        }   
        
        x <- lapply(
            X   = x, 
            FUN = function(y){
                out0 <- strsplit( 
                    x     = y, 
                    split = "|", 
                    fixed = TRUE )[[ 1L ]] 
                
                return( as.numeric( out0 ) ) 
            }   
        )   
        
        x <- I( x ) 
        
    }else if( all( is.character( x ) ) ){
        x <- lapply(
            X   = x, 
            FUN = function(y){
                out0 <- strsplit( 
                    x     = y, 
                    split = "|", 
                    fixed = TRUE )[[ 1L ]] 
                
                return( as.numeric( out0 ) ) 
            }   
        )   
        
        x_length <- unlist( lapply( X = x, FUN = length ) )
        
        if( all( x_length <= 1L ) ){
            x <- unlist( x ) 
        }else{
            x <- I( x ) 
        }   
        
    }else if( !any( c( "numeric", "integer" ) %in% class( x ) ) ){
        stop( sprintf( 
            "'x' should be of class 'list', 'AsIs', 'character' or 'numeric'. Now class %s", 
            paste( class( x ), collapse = " " ) 
        ) )
    }   
    
    return( x ) 
}   

    # .muc_vbar_to_numeric( x = "1000|900" )
    # # [[1]]
    # # [1] 1000  900

    # .muc_vbar_to_numeric( x = c( 1000, "900|800" ) )
    # # [[1]]
    # # [1] 1000

    # # [[2]]
    # # [1] 900 800

    # .muc_vbar_to_numeric( x = list( "1000", "900|800" ) )
    # # [[1]]
    # # [1] 1000

    # # [[2]]
    # # [1] 900 800

    # .muc_vbar_to_numeric( x = data.frame( a = I(list( "1000", "900|800" )), b = 1:2 )[,1L] )
    # # [[1]]
    # # [1] 1000

    # # [[2]]
    # # [1] 900 800

    # .muc_vbar_to_numeric( x = c( "1000", "800" ) )
    # # [1] 1000  800

    # .muc_vbar_to_numeric( x = c( 1000, 900 ) )
    # # [1] 1000  900



# .muc_tar =================================================

#'@importFrom utils tar
.muc_tar <- function( tarfile, files ){
    where_tar <- Sys.getenv( "tar", unset = NA_character_ )
    
    if( is.na( where_tar ) ){
        suppressWarnings( where_tar <- tryCatch( system2( 
            command = "where", 
            args    = "tar.exe", 
            stdout  = TRUE ) ) ) 
        
        if( is.character( where_tar ) ){
            utils::tar( 
                tarfile     = tarfile, 
                files       = files,
                compression = "gzip", 
                tar         = "tar.exe" ) 
             
            out <- TRUE 
        }else{
            out <- FALSE 
        }   
    }else{
        utils::tar( 
            tarfile     = tarfile, 
            files       = files,
            compression = "gzip", 
            tar         = where_tar ) 
        
        out <- TRUE 
    }   
    
    return( out ) 
}   



# macrounchained ===========================================

#' Batch run MACRO simulations with different substance properties and application patterns
#'
#' Batch run MACRO simulations with different substance 
#'  properties and application patterns, starting from a 
#'  template imported MACRO par-file, including metabolites.
#'
#'
#'@param s
#'  A \code{\link[base]{data.frame}} containing different sets 
#'  of substance properties and application patterns to be 
#'  simulated. Each row is a substance. The order of the 
#'  column has no importance, but the order of the row 
#'  will steer the simulation order. Substances deriving 
#'  from the same applied substance will nonetheless be 
#'  simulated together. The following columns 
#'  must or can be provided 
#'  \itemize{
#'      \item{"id"}{Integer-value, between 1 and 998. Unique 
#'          identifier of the substance. Will also be used as 
#'          a Run ID.} 
#'      \item{"name"}{Character-string. Name of the substance. 
#'          Names don't need to be unique, but it may be a 
#'          good idea if they are.} 
#'      \item{"kfoc"}{Numeric-value. [L/kg]. Freundlich 
#'          adsorption coefficient of the substance.} 
#'      \item{"nf"}{Numeric-value. [-]. Freundlich exponent 
#'          of the substance.} 
#'      \item{"dt50"}{Numeric-value. [days]. Half-life of 
#'          the substance in soil.} 
#'      \item{"dt50_ref_temp"}{Numeric-value. [Degrees Celsius]. 
#'          Reference temperature at which the half-life was 
#'          measured.} 
#'      \item{"dt50_pf"}{Integer-value. [log10(cm)]. pF at 
#'          which the DT50 was measured.} 
#'      \item{"exp_temp_resp"}{Numeric-value. [-]. Exponent 
#'          of the temperature response (effect of temperature 
#'          on degradation).} 
#'      \item{"exp_moist_resp"}{Numeric-value. [-]. Exponent 
#'          of the moisture response (effect of soil water 
#'          content on degradation).} 
#'      \item{"crop_upt_f"}{Numeric-value.  [-]. Crop uptake 
#'          factor. Between 0 (no root uptake of the substance) 
#'          and 1 (passive uptake of the substance with root 
#'          water uptake).} 
#'      \item{"diff_coef"}{Numeric-value. [m2/s]. Substance 
#'          diffusion coefficient (in water).} 
#'      \item{"parent_id"}{Integer-value. Only for metabolites. 
#'          Leave empty (\code{NA_integer_}) for substances 
#'          that are not the degradation product of another 
#'          substance. \code{id} of the parent substance, i.e. 
#'          the substance that degrades into the metabolite 
#'          described in this row. For secondary metabolites 
#'          (and further), the "parent" will also be a 
#'          metabolite.} 
#'      \item{"g_per_mol"}{Numeric-value. [g/mol]. Molar mass 
#'          of the substance. Only needed when the substance 
#'          is degrading into a degradation product or is 
#'          the degradation product of another substance. 
#'           Leave empty (\code{NA_integer_}) otherwise.} 
#'      \item{"g_as_per_ha"}{Numeric-value or, in case of 
#'          multiple applications, character string. [g/ha]. 
#'          Application 
#'          rate (in g substance per hectare) of the substance. 
#'          Set to 0 g/ha if the substance is a degradation 
#'          product. In case of several applications per year, 
#'          give the values separated with a vertical bar 
#'          (see https://en.wikipedia.org/wiki/Vertical_bar). 
#'          Do quote the values. For example, for two 
#'          applications of 1000g/ha and 90g/ha, respectively, 
#'          type \code{"1000|900"}.} 
#'      \item{"app_j_day"}{Integer-value or, in case of 
#'          multiple applications, character string. Between 
#'          1 and 365. 
#'          [Julian day]. Application date of the substance. 
#'          Use the application date of the applied substance 
#'          (the top parent) if the substance is a 
#'          degradation product. In case of several 
#'          applications per year, give the values separated 
#'          with a vertical bar (see https://en.wikipedia.org/wiki/Vertical_bar). 
#'          Do quote the values. For example, for two 
#'          applications on Julian days 298 and 305, 
#'          respectively, type \code{"298|305"}} 
#'      \item{"f_int"}{Numeric-value. [-]. Fraction of the 
#'          applied product that is intercepted by the crop 
#'          canopy.} 
#'  }   
#'  The columns \code{"parent_id"} and \code{"g_per_mol"} can 
#'  be entirely skipped (missing), and should at least be 
#'  only \code{NA} when no metabolite is to be simulated.
#'
#'@param parfile
#'  A \code{macroParFile}, as imported with 
#'  \code{\link[rmacrolite]{rmacroliteImportParFile-methods}}
#'
#'@param verbose
#'  Single integer value. If set to a value \code{< 1}, 
#'  the program is silent (except on errors or warnings). If 
#'  set to \code{1}, the program outputs messages. Values 
#'  \code{> 1} may also activate messages from lower level 
#'  functions (for debugging purpose).
#'
#'@param indump
#'  Single logical value. If \code{TRUE} (the default), 
#'  the so called \code{indump.tmp} parameter file is produced. 
#'  Must be \code{TRUE} when \code{run} is \code{TRUE}.
#'
#'@param run
#'  Single logical value. If \code{TRUE} (the default), 
#'  the parametrised simulations are run.
#'
#'@param overwrite
#'  Single logical value. If \code{FALSE} (the default), 
#'  the function will check that the files to be created 
#'  do not exist yet, and will \code{\link[base]{stop}} if 
#'  some of the files already exist. Set to \code{TRUE} to 
#'  silently overwrite existing files.
#'
#'@param analyse 
#'  Single R \code{\link[base]{function}}. Function to be 
#'  used by \code{macrounchained} to analyse the results of 
#'  MACRO simulations. An example of such function is 
#'  \code{\link[macroutils2:macroutilsFocusGWConc-methods]{macroutilsFocusGWConc}}.
#'  Notice that the appropriate function depends on what 
#'  output needs to be analysed and what parameters are 
#'  exported from MACRO, as defined in \code{parfile}, so 
#'  there is no generic all purpose function to be used here.
#'  When \code{analyse} is \code{NULL} (the default), MACRO 
#'  output is not analysed.
#'
#'@param analyse_args 
#'  A \code{\link[base]{list}} containing named-items to 
#'  be passed as arguments to \code{analyse}. An example 
#'  of use is \code{analyse_args =} \code{list( "quiet" = TRUE )}.
#'
#'@param analyse_summary 
#'  Single R \code{\link[base]{function}}. Function to be 
#'  used by \code{macrounchained} to summarise all the results 
#'  of MACRO simulations, as output by \code{analyse}.
#'  An example of such function is 
#'  \code{\link[macrounchained:macroutilsFocusGWConc_summary-methods]{macroutilsFocusGWConc_summary}}.
#'  Notice that the appropriate function depends on what 
#'  output needs to be summarised and what output \code{analyse} 
#'  is returning, so there is no generic all purpose function 
#'  to be used here.
#'
#'@param dt50_depth_f
#'  See \code{\link[rmacrolite:rmacroliteDegradation-methods]{rmacroliteDegradation}}.
#'
#'@param anonymise
#'  Single boolean value. If \code{TRUE}, the function 
#'  tries to replace USERNAME, HOMEPATH and USERPROFILE 
#'  (i.e Windows environment variables) in paths displayed 
#'  in messages by their environment variables, in order 
#'  to preserve the user anonymity in the logs produced.
#'
#'@param archive
#'  Single boolean value. If \code{TRUE}, all the files 
#'  generated are archived in a \code{.tar.gz}-file when 
#'  all other operations are finished. Default to 
#'  \code{FALSE}.
#'
#'@param keep0conc
#'  See \code{\link[rmacrolite:rmacroliteApplications-methods]{rmacroliteApplications}}.
#'
#'@param focus_mode
#'  See \code{\link[rmacrolite:rmacroliteApplications-methods]{rmacroliteApplications}}.
#'
#'@param \dots
#'  Additional parameters passed to specific methods. 
#'  Currently not used.
#'
#'
#'@return
#'  TO BE WRITTEN.
#' 
#'
#'@rdname macrounchained-methods
#'@aliases macrounchained
#'
#'@export 
#'
#'@docType methods
#'
#'@importFrom utils packageName
macrounchained <- function( 
    s, 
    ... 
    # .internal = list() 
){  
    if( is.null( .muc_internals[[ "match_call" ]] ) ){
        .muc_internals[[ "match_call" ]] <- match.call()
    }   
    
    if( is.null( .muc_internals[[ "package" ]] ) ){
        .muc_internals[[ "package" ]] <- utils::packageName()
    }   
    
    if( is.null( .muc_internals[[ "timeStart" ]] ) ){
        .muc_internals[[ "timeStart" ]] <- Sys.time()
    }   
    
    UseMethod( generic = "macrounchained" )
}   



#'@rdname macrounchained-methods
#'
#'@method macrounchained data.frame
#'
#'@export 
#'
#'@importFrom stats na.omit
#'@importFrom utils write.csv
#'@importFrom utils write.table
#'@importFrom rmacrolite getRmlPar 
#'@importFrom rmacrolite rmlPar 
#'@importFrom rmacrolite rmacroliteImportParFile
#'@importFrom rmacrolite rmacroliteGetModelVar
#'@importFrom rmacrolite rmacroliteExportParFile
#'@importFrom rmacrolite rmacroliteRunId<-
#'@importFrom rmacrolite rmacroliteSimType<-
#'@importFrom rmacrolite rmacroliteSorption<-
#'@importFrom rmacrolite rmacroliteDegradation<-
#'@importFrom rmacrolite rmacroliteCropUptF<-
#'@importFrom rmacrolite rmacroliteDiffCoef<-
#'@importFrom rmacrolite rmacroliteApplications
#'@importFrom rmacrolite rmacroliteApplications<-
#'@importFrom rmacrolite rmacroliteInfo<-
#'@importFrom rmacrolite rmacroliteRun
#'@importFrom rmacrolite rmacroliteMacroVersion 
#'@importFrom codeinfo codeinfo
macrounchained.data.frame <- function( 
    s, 
    parfile, 
    verbose = 1L, 
    indump = TRUE, 
    run = TRUE, 
    overwrite = FALSE, 
    analyse = NULL, 
    analyse_args = NULL, 
    analyse_summary = NULL, 
    dt50_depth_f = NULL, 
    keep0conc = TRUE, 
    focus_mode = "no", 
    anonymise = TRUE, 
    archive = TRUE, 
    ... 
    # .internal = list() 
){  
    log_width <- getRmlPar( "log_width" )
    
    #   Create a temporary log-file
    temp_log <- tempfile( pattern = "rml_log_", fileext = ".txt" ) 
    
    .muc_logMessage( m = "Temporary log-file %s", 
        verbose = verbose, log_width = log_width, 
        values = list( .muc_anonymisePath( path = temp_log, 
        anonymise = anonymise, winslash = "/", 
        log_width = log_width ) ), 
        logfiles = temp_log, append = FALSE )
    
    
    
    if( run ){
        .muc_logMessage( m = "Parametrise and run MACRO simulations", 
            verbose = verbose, log_width = log_width, 
            frame = "*", logfiles = temp_log, append = TRUE )
        
        if( !indump ){
            stop( "Argument 'indump' must be TRUE when 'run' is TRUE." )
        }   
    }else{
        .muc_logMessage( m = "Parametrise MACRO simulations", 
            verbose = verbose, log_width = log_width, 
            frame = "*", logfiles = temp_log, append = TRUE )
    }   
    
    
    
    # ======================================================
    # Traceability
    # ======================================================
    
    if( is.null( .muc_internals[[ "match_call" ]] ) ){
        .muc_internals[[ "match_call" ]] <- match.call()
    }   
    
    if( is.null( .muc_internals[[ "package" ]] ) ){
        .muc_internals[[ "package" ]] <- utils::packageName()
    }   
    
    if( is.null( .muc_internals[[ "timeStart" ]] ) ){
        .muc_internals[[ "timeStart" ]] <- Sys.time()
    }   
    
    
    
    # ======================================================
    # Check parameter table 's'
    # ======================================================
    
    .muc_logMessage( m = "Check input parameter-table ('s')", 
        verbose = verbose, log_width = log_width, 
        logfiles = temp_log, append = TRUE )
    
    if( !(focus_mode %in% c( "no", "gw" )) ){
        stop( sprintf( 
            "Argument 'focus_mode' can either be 'no' or 'gw' (currently %s)", 
            focus_mode ) )
    }   
    
    #   List of compulsory columns in s
    columns_subst <- c( "id", "kfoc", "nf", "dt50", 
        "dt50_ref_temp", "dt50_pf", "exp_temp_resp", 
        "exp_moist_resp", "crop_upt_f", "diff_coef" ) # "name", 
    
    #   Columns required for running metabolites
    columns_met <- c( "parent_id", "g_per_mol", "transf_f" )
    
    #   Columns with applied dose and application Julian day
    #   (also always needed)
    columns_appln <- c( "g_as_per_ha", "app_j_day", "f_int" )
    
    #   Convert from "tibble" to pure data.frame
    #   (if imported from Excel)
    if( any(c( "tbl_df", "tbl" ) %in% class(s)) ){
        s <- as.data.frame( s ) 
    }   
    
    #   Test s and its columns
    if( !("data.frame" %in% class(s)) ){
        stop( sprintf( 
            "'s' must be a data.frame. Now class %s", 
            paste( class(s), collapse = ", " ) ) ) 
    }   
    
    if( focus_mode == "gw" ){
        columns_appln <- c( columns_appln, "years_interval" )
        
        if( !("years_interval" %in% colnames( s )) ){
            s <- data.frame( s, "years_interval" = 1L, 
                stringsAsFactors = FALSE )
        }   
    }   
    
    test_columns <- c( columns_subst, columns_appln ) %in% 
        colnames( s )
    
    if( any( !test_columns ) ){
        stop( sprintf( 
            "Some compulsory columns are missing in 's': %s", 
            paste( c( columns_subst, columns_appln )[ !test_columns ], 
                collapse = ", " ) ) ) 
    };  rm( test_columns )
    
    test_met_columns <- columns_met %in% colnames( s ) 
    
    metabolites <- ifelse( test = any( test_met_columns ), 
        yes = TRUE, no = FALSE )
    
    if( metabolites & (!all(test_met_columns)) ){
        stop( sprintf( 
            "Some columns related to metabolites are given in 's' while other are missing: %s", 
            paste( columns_met[ !test_met_columns ], 
                collapse = ", " ) ) ) 
    };  rm( test_met_columns )
    
    
    
    #   Check that none of the required column contains NA
    #   (substance properties)
    for( i in 1:length( columns_subst ) ){
        if( any( is.na( s[, columns_subst[ i ] ] ) ) ){ 
            stop( sprintf( "NA-values detected in s[,'%s']. Missing values not allowed.", 
                columns_subst[ i ] 
            ) ) 
        }   
        
        if( !all( is.numeric( s[, columns_subst[ i ] ] ) ) ){ 
            stop( sprintf( "Non-numeric values detected in s[,'%s'].", 
                columns_subst[ i ] 
            ) ) 
        }   
    };  rm( i )
    
    
    
    #   Check that none of the required column contains NA
    #   (application pattern)
    for( i in 1:length( columns_appln ) ){
        test_class <- any( c( "AsIs", "list", "character", 
            "numeric", "integer" ) %in% class( s[, columns_appln[ i ] ] ) )
        
        if( !test_class ){
            stop( sprintf( 
                "Column '%s' in 's' must be of class 'AsIs', 'list', 'numeric' or 'character'. Now %s", 
                columns_appln[ i ], 
                paste( class( s[, columns_appln[ i ] ] ), 
                    collapse = " " )
            ) ) 
            
        }else{
            s[[ columns_appln[ i ] ]] <- .muc_vbar_to_numeric( 
                x = s[, columns_appln[ i ] ] ) 
        }   
        
        rm( test_class ) 
        
        if( any( is.na( unlist( s[, columns_appln[ i ] ] ) ) ) ){ 
                      # unlist() required here for AsIs columns
            stop( sprintf( "NA-values detected in s[,'%s']. Missing values not allowed.", 
                columns_appln[ i ] 
            ) ) 
        }   
        
        if( !all( is.numeric( unlist( s[, columns_appln[ i ] ] ) ) ) ){ 
            stop( sprintf( "Non-numeric values detected in s[,'%s'].", 
               columns_appln[ i ] 
            ) ) 
        }   
    };  rm( i )
    
    
    
    #   Ignore the metabolite columns if they are all NA
    if( metabolites ){
        metabolites <- ifelse( test = all( is.na( s[, columns_met ] ) ), 
            yes = FALSE, no = TRUE )
    }   
    
    
    
    if( metabolites ){
        parent_id_NA <- is.na( s[, "parent_id" ] )
        
        for( i in 1:length( columns_met ) ){
            if( any( is.na( s[, columns_met[ i ] ] ) & (!parent_id_NA) ) ){
                stop( sprintf( "NA-values detected in s[,'%s'] while s[,'parent_id'] is not NA.", 
                    columns_met[ i ] 
                ) ) 
            }   
        };  rm( i )
        
        #   Check that "g_per_mol" is also given for the parent
        parent_M_is_NA <- is.na( s[, "g_per_mol" ] ) & 
            (s[, "id" ] %in% stats::na.omit( s[, "parent_id" ] ))
            
        if( any( parent_M_is_NA ) ){
            stop( sprintf( "s[,'g_per_mol'] is missing (NA) for some parent-substances (id: %s)", 
                paste( s[ parent_M_is_NA, "id" ], collapse = ", " ) ) ) 
        };  rm( parent_M_is_NA )
        
    }   
    
    
    
    #   Add a column "name" if missing:
    names_provided <- ("name" %in% colnames( s ))
    if( !names_provided ){
        s[, "name" ] <- sprintf( "subst_%s", formatC( 
            x = s[, "id" ], flag = "0", 
            width = max( nchar( s[, "id" ] ) ) ) )
    }   
    
    
    
    #   Number of rows in s (number of parameter sets)
    n <- nrow( s )
    
    #   Check that id is unique
    if( any( dup <- duplicated( s[, "id" ] ) ) ){
        stop( sprintf( 
            "Some values in s[,'id'] are duplicated (should be unique): %s", 
            paste( unique( s[ dup,'id'] ), 
                collapse = ", " ) ) ) 
    };  rm( dup )
    
    #   Check that id is between 1 and 999
    id_range <- getRmlPar( "id_range" )
    
    if( any( (s[, "id" ] < min(id_range)) | (s[, "id" ] > max(id_range)) ) ){
        stop( sprintf( 
            "s[,'id'] must be between %s and %s. Now between %s and %s.", 
            min(id_range), max(id_range), 
            min(s[, "id" ]), max(s[, "id" ]) ) ) 
    }   
    
    
    
    #   Does 's' contains a column 'parfile'?
    parfile_in_s <- "parfile" %in% colnames( s ) 
    
    parfile_table_template <- data.frame(
        "parfile_id" = NA_integer_, 
        "path"       = NA_character_, 
        stringsAsFactors = FALSE )   
    
    if( parfile_in_s ){
        if( !missing( parfile ) ){
            stop( "'s' contains a column 'parfile' while argument 'parfile' is given too. Provide one but not both." )
        }   
        
        if( !("character" %in% class( s[, "parfile" ] )) ){
            stop( sprintf( 
                "Column 'parfile' in 's' should be character-class. Now class %s", 
               paste( class( s[, "parfile" ] ), collapse = " " ) ) ) 
        }   
        
        parfile_table <- unique( s[, "parfile" ] ) 
        parfile_table <- data.frame(
            "parfile_id" = 1:length( parfile_table ), 
            "path"       = parfile_table, 
            stringsAsFactors = FALSE ) 
        rownames( parfile_table ) <- parfile_table[, "path" ] 
        
        #   Add a column 'parfile_id' to 's' and remove the 
        #   column 'parfile'
        s[, "parfile_id" ] <- as.integer( parfile_table[ 
            parfile_table[, "path" ], 
            "parfile_id" ] ) 
        
        rownames( parfile_table ) <- NULL 
        
        s <- s[, colnames( s ) != "parfile" ] 
    }   
    
    
    
    # ======================================================
    # Check other parameters
    # ======================================================
    
    dotdotdot <- list( ... ) 
    
    if( length( list(...) ) > 0L ){
        warning( sprintf(  
            "Additional arguments passed via '...', while '...' currently not in use (%s)", 
            paste( names( dotdotdot ), collapse = ", " )
        ) ) 
    }   
    
    
    
    # ======================================================
    # Import the parfiles, if needed
    # ======================================================
    
    if( !parfile_in_s ){
        if( missing( "parfile" ) ){
            stop( "Argument 'parfile' is missing and no column 'parfile' in 's'. One must be given." )
            
        }else if( is.character( parfile ) ){
            parfile_table <- data.frame(
                "parfile_id" = 1L, 
                "path"       = parfile, 
                stringsAsFactors = FALSE ) 
            
            s[, "parfile_id" ] <- parfile_table[, "parfile_id" ]
            
            
        }else if( !("macroParFile" %in% class( parfile )) ){
            stop( sprintf(
                "Argument 'parfile' should be a character string or a macroParFile-object. Now %s", 
                paste( class( parfile ), collapse = ", " )
            ) ) 
        }else{
            parfile_table <- data.frame(
                "parfile_id" = 1L, 
                "path"       = NA_character_, 
                stringsAsFactors = FALSE ) 
            
            s[, "parfile_id" ] <- parfile_table[, "parfile_id" ]
            
            parfile_list <- list( parfile )
        }   
    }   
    
    #   Import all the parfiles
    if( !exists( "parfile_list" ) ){
        parfile_list <- lapply(
            X   = 1:nrow( parfile_table ), 
            FUN = function(i){
                .muc_logMessage( m = "Import par-file id %s (%s)", 
                    verbose = verbose, values = list( 
                    parfile_table[ i, "parfile_id" ], 
                    .muc_anonymisePath( path = 
                    parfile_table[ i, "path" ], 
                    anonymise = anonymise, winslash = "/", 
                    log_width = log_width ) ), 
                    log_width = log_width, logfiles = temp_log, 
                    append = TRUE )
                
                return( rmacroliteImportParFile( 
                    file = parfile_table[ i, "path" ], 
                    verbose = verbose - 1L ) ) 
            }   
        )   
    }   #   parfile
    
    if( focus_mode != "gw" ){
        #   Find how many applications there are for each 
        #   par-file
        .muc_logMessage( 
            m = "Check that the number of applications is coherent between 's' and the par-file(s)", 
            verbose = verbose, log_width = log_width, 
            logfiles = temp_log, append = TRUE )
        
        #   Number of applications in the par-file(s)
        parfile_table[, "nb_appln" ] <- unlist( lapply(
            X   = parfile_list, 
            FUN = function(pl){
                appln <- rmacroliteApplications( x = pl ) 
                appln <- unique( appln )
                
                #   Remove applications without solute
                if( !all( appln[, "g_as_per_ha" ] == 0 ) ){
                    appln <- appln[ appln[, "g_as_per_ha" ] != 0, ]
                }   
                
                return( nrow( appln ) ) 
            }   
        ) ) 
        
        #   Number of applications in 's'
        nb_appln_in_s <- unlist( lapply(
            X   = 1:nrow(s), 
            FUN = function(i){
                g_as_per_ha <- s[ i, "g_as_per_ha" ] 
                
                if( any( c( "AsIs", "list" ) %in% class( g_as_per_ha ) ) ){
                    g_as_per_ha <- g_as_per_ha[[ 1L ]]
                }   
                
                nb_doses <- length( g_as_per_ha ) 
                
                app_j_day <- s[ i, "app_j_day" ]
                
                nb_app_j_day <- length( app_j_day )
                
                if( any( c( "AsIs", "list" ) %in% class( app_j_day ) ) ){
                    app_j_day <- app_j_day[[ 1L ]]
                }   
                
                f_int <- s[ i, "f_int" ]
                
                if( any( c( "AsIs", "list" ) %in% class( f_int ) ) ){
                    f_int <- f_int[[ 1L ]]
                }   
                
                nb_f_int <- length( f_int ) 
                
                return( max( c( nb_doses, nb_app_j_day, nb_f_int ) ) )
            }   
        ) )
        
        rownames( parfile_table ) <- as.character( 
            parfile_table[, "parfile_id" ] ) 
        
        test_nb_appln <- parfile_table[ as.character( s[, "parfile_id" ] ), "nb_appln" ] == nb_appln_in_s
        
        if( !all( test_nb_appln ) ){
            stop( "The number of applications in the par-file(s) does not match the number of applications in 's' (at least for some rows)." )
        }   
        rm( test_nb_appln, nb_appln_in_s )
    }   
    
    rownames( parfile_table ) <- NULL 
    
    
    
    # ======================================================
    # Define the operation register
    # ======================================================
    
    fileNameTemplate <- getRmlPar( "fileNameTemplate" ) 
    idWidth <- getRmlPar( "idWidth" ) 
    
    #   Template table (row) for operation register
    op_reg0 <- data.frame(
        "id"            = NA_integer_, 
        "run_id"        = NA_integer_, 
        "is_as"         = as.logical(NA), 
        "is_met"        = as.logical(NA), 
        "is_inter"      = as.logical(NA), 
        "par_file"      = NA_character_, 
        "drivingfile"   = NA_character_, 
        "output_macro"  = NA_character_, 
        "output_rename" = NA_character_, 
        "indump_rename" = NA_character_, 
        "summary_file"  = NA_character_, 
        stringsAsFactors = FALSE 
    )   
    
    if( metabolites ){
        .muc_logMessage( 
            m = "Find-out order of simulations (metabolite(s) transformation pathway)", 
            verbose = verbose, log_width = log_width, 
            logfiles = temp_log, append = TRUE )
        
        #   Check that all "parent_id" refer to an existing "id"
        test_parent_id <- s[, "parent_id" ] %in% s[, "id" ] 
        test_parent_id[ is.na( s[, "parent_id" ] ) ] <- TRUE 
        
        if( any( !test_parent_id ) ){
            stop( sprintf( 
                "Some values in s[,'parent_id'] are not found in s[,'id']: %s", 
                paste( unique( s[ !test_parent_id, 'parent_id' ] ), 
                    collapse = ", " ) ) ) 
        }   
        
        rm( test_parent_id )
        
        
        
        #   Determine the transformation pathway and operation 
        #   order:
        
        #   *   Find which substances are active substances
        #       (i.e. not a degradation product of other 
        #       substances)
        
        #   *   id of the active substance ("top parent")
        s[, "as_id" ]     <- NA_integer_ 
        
        #   *   0 = active substance, 1 = primary metabolite, 
        #       2 = secondary metabolite, ...
        s[, "met_level" ] <- NA_integer_ 
        
        #   *   MACRO conversion factor
        s[, "f_conv" ] <- NA_real_ 
        
        #   *   If the substance does not have a parent, 
        #       it is an active substance (even if it does 
        #       not have a metabolite)
        s[ is.na( s[, "parent_id" ] ), "as_id" ] <- 
            s[ is.na( s[, "parent_id" ] ), "id" ] 
        
        #   *   Active substances are level 0
        s[ is.na( s[, "parent_id" ] ), "met_level" ] <- 0L 
        
        #   *   Substances that have at least one metabolite
        s[, "has_met" ] <- s[, "id" ] %in% stats::na.omit( s[, "parent_id" ] )
        
        #   *   Note:
        #       met_level   has_met   description
        #       ----------------------------------------------------------
        #               0      TRUE   active substance with metabolites
        #               0     FALSE   active substance without metabolites
        #           not 0      TRUE   metabolites with metabolites
        #           not 0     FALSE   metabolites without metabolites
        
        nb_iter  <- 1L 
        max_iter <- max( id_range ) 
        
        current_met_level <- NA_integer_ 
        id_current_level  <- NA_integer_ 
        next_level        <- NA_integer_ 
        id_next_level     <- NA_integer_ 
        
        while( any( is.na( s[, "met_level" ] ) ) & (nb_iter <= max_iter) ){
            current_met_level <- max( stats::na.omit( s[, "met_level" ] ) ) 
            
            #   Find the id of the substance with the last 
            #   level attributed
            id_current_level <- s[, "met_level" ] == current_met_level 
            id_current_level[ is.na(id_current_level) ] <- FALSE 
            id_current_level <- s[ id_current_level, "id" ]
            
            #   Assign the next metabolite level
            next_level <- s[, "parent_id" ] %in% id_current_level
            s[ next_level, "met_level" ] <- current_met_level + 1L 
            
            #   Assign the top active substance
            id_next_level <- s[ next_level, "id" ]
            s[ next_level, "as_id" ] <- unlist( lapply(
                X   = id_next_level, 
                FUN = function(.id){
                    parent_id <- s[ s[,"id"] == .id, 
                        "parent_id" ]
                    return( s[ s[,"id"] == parent_id, "as_id" ] ) 
                } ) ) 
            
            s[ next_level, "f_conv" ] <- unlist( lapply(
                X   = id_next_level, 
                FUN = function(.id){
                    parent_id <- s[ s[,"id"] == .id, 
                        "parent_id" ]
                    
                    M_parent <- s[ s[,"id"] == parent_id, "g_per_mol" ] 
                    M_met    <- s[ s[,"id"] == .id,       "g_per_mol" ] 
                    transf_f <- s[ s[,"id"] == .id,       "transf_f" ] 
                    
                    return( (M_met/M_parent)*transf_f ) 
                } ) ) 
        }   
        
        #   Clean up
        rm( current_met_level, id_current_level, next_level, 
            id_next_level )
        
        #   Order the substances so that substances having 
        #   the same top active substances are simulated 
        #   together and in the right order
        s <- split( x = s, f = factor( 
            x       = s[, "as_id" ], 
            levels  = unique( s[, "as_id" ] ), 
            ordered = TRUE ) )
        
        s <- lapply(
            X   = s, 
            FUN = function(y){
                return( y[ order( y[, "met_level" ] ), ] )
            }   
        )   
        
        s <- do.call( what = "rbind", args = s ) 
        rownames( s ) <- NULL 
        
        
        
        .muc_logMessage( 
            m = "Prepare a list of operations (incl. metabolite(s) intermediate output)", 
            verbose = verbose, log_width = log_width, 
            logfiles = temp_log, append = TRUE) 
        
        #   Number of intermediate simulations to be run
        # run_with_inter <- (s[, "id" ] == s[, "as_id" ]) & 
            # (s[, "id" ] %in% s[, "parent_id" ])
        run_with_inter <- s[, "id" ] %in% s[, "parent_id" ]
        nb_inter <- sum( run_with_inter ) 
        
        #   Prepare id to be attributed to the intermediate 
        #   runs
        free_id <- min( s[, "id" ] ):max( id_range )
        free_id <- free_id[ !(free_id %in% s[, "id" ]) ] 
        
        if( length( free_id ) < nb_inter ){
            stop( sprintf(
                "Not enough free id between min(s[,'id']) (%s) and max allowed (%s) to attribute to intermediate runs (%s runs).", 
                min( s[, "id" ] ), max( id_range ), nb_inter ) ) 
        }else{
            free_id <- free_id[ 1:nb_inter ]
        }   
        
        #   Create a register of operations:
        operation_register <- vector( length = nrow(s), 
            mode = "list" )
        
        for( o in 1:length( operation_register ) ){
            operation_register[[ o ]] <- op_reg0 
            operation_register[[ o ]][, "id" ]     <- s[ o, "id" ] 
            operation_register[[ o ]][, "run_id" ] <- s[ o, "id" ] 
            
            operation_register[[ o ]][, "is_as" ] <- ifelse( 
                test = s[ o, "id" ] == s[ o, "as_id" ], 
                yes  = TRUE, 
                no   = FALSE ) 
            
            operation_register[[ o ]][, "is_met" ] <- ifelse( 
                test = !is.na( s[ o, "parent_id" ] ), 
                yes  = TRUE, 
                no   = FALSE ) 
            
            operation_register[[ o ]][, "is_inter" ] <- FALSE 
            
            operation_register[[ o ]][, "par_file" ] <- 
                sprintf( fileNameTemplate[[ "r" ]], 
                    formatC( x = s[ o, "id" ], width = idWidth, 
                    flag = "0" ), "par" )
            
            if( operation_register[[ o ]][, "is_met" ] ){
                operation_register[[ o ]][, "drivingfile" ] <- 
                    sprintf( fileNameTemplate[[ "r" ]], 
                    sprintf( "%s_inter", formatC( 
                    x = s[ o, "parent_id" ], width = idWidth, 
                    flag = "0" ) ), "bin" )
            }else{
                operation_register[[ o ]][, "drivingfile" ] <- 
                    sprintf( fileNameTemplate[[ "r" ]], 
                    sprintf( "%s_inter", formatC( 
                    x = 0L, width = idWidth, 
                    flag = "0" ) ), "bin" )
            }   
            
            operation_register[[ o ]][, "output_macro" ] <- 
                sprintf( fileNameTemplate[[ "macro" ]], 
                    formatC( x = s[ o, "id" ], width = idWidth, 
                    flag = "0" ), "BIN" )
            
            operation_register[[ o ]][, "output_rename" ] <- 
                sprintf( fileNameTemplate[[ "r" ]], 
                    formatC( x = s[ o, "id" ], width = idWidth, 
                    flag = "0" ), "bin" )
            
            operation_register[[ o ]][, "indump_rename" ] <- 
                sprintf( fileNameTemplate[[ "r" ]], sprintf( 
                    "%s_indump", formatC( x = s[ o, "id" ], 
                    width = idWidth, flag = "0" ) ), "tmp" )
            
            operation_register[[ o ]][, "summary_file" ] <- 
                sprintf( fileNameTemplate[[ "r" ]], sprintf( 
                    "%s_summary", formatC( x = s[ o, "id" ], 
                    width = idWidth, flag = "0" ) ), "txt" )
            
            if( run_with_inter[ o ] ){
                operation_register[[ o ]] <- rbind(
                    operation_register[[ o ]], 
                    op_reg0 
                )   
                
                operation_register[[ o ]][ 2L, "id" ] <- 
                    operation_register[[ o ]][ 1L, "id" ] 
                
                operation_register[[ o ]][ 2L, "run_id" ] <- 
                    free_id[ 1L ] 
                free_id <- free_id[ -1L ] 
                
                operation_register[[ o ]][ 2L, "is_as" ] <- 
                    operation_register[[ o ]][ 1L, "is_as" ] 
                
                operation_register[[ o ]][ 2L, "is_met" ] <- 
                    operation_register[[ o ]][ 1L, "is_met" ] 
                
                operation_register[[ o ]][ 2L, "is_inter" ] <- TRUE 
                
                operation_register[[ o ]][ 2L, "par_file" ] <- 
                    sprintf( fileNameTemplate[[ "r" ]], 
                        sprintf( "%s_inter", formatC( 
                        x = s[ o, "id" ], width = idWidth, 
                        flag = "0" ) ), "par" )
                
                operation_register[[ o ]][ 2L, "drivingfile" ] <- 
                    operation_register[[ o ]][ 1L, "drivingfile" ]
                
                operation_register[[ o ]][ 2L, "output_macro" ] <- 
                    sprintf( fileNameTemplate[[ "macro" ]], formatC( 
                        x = operation_register[[ o ]][ 2L, "run_id" ], 
                        width = idWidth, flag = "0" ), "BIN" )
                
                operation_register[[ o ]][ 2L, "output_rename" ] <- 
                    sprintf( fileNameTemplate[[ "r" ]], sprintf( 
                        "%s_inter", formatC( 
                        x = operation_register[[ o ]][ 1L, "id" ], 
                        width = idWidth, flag = "0" ) ), "bin" )
                
                operation_register[[ o ]][ 2L, "indump_rename" ] <- 
                    sprintf( fileNameTemplate[[ "r" ]], sprintf( 
                        "%s_indump", formatC( 
                        x = operation_register[[ o ]][ 2L, "run_id" ], 
                        width = idWidth, flag = "0" ) ), "tmp" )
                
                # operation_register[[ o ]][ 2L, "summary_file" ] <- 
                    # NA_character_
                
            }   
        }   
        
        operation_register <- do.call( what = "rbind", 
            args = operation_register )
        
        .muc_logMessage( 
            m = "Identified %s simulations for %s substances (%s intermediate-outputs)", 
            verbose = verbose, log_width = log_width, 
            values = list( nrow( operation_register ), 
            nrow( s ), sum( operation_register[, "is_inter" ] ) ), 
            logfiles = temp_log, append = TRUE ) 
        
    }else{
        #   s does not contain metabolites
        .muc_logMessage( 
            m = "Prepare a list of operations", 
            verbose = verbose, log_width = log_width, 
            logfiles = temp_log, append = TRUE ) 
        
        operation_register <- lapply(
            X   = 1:nrow(s), 
            FUN = function(i){
                op_reg <- op_reg0 
                op_reg[, "id" ]     <- s[ i, "id" ] 
                op_reg[, "run_id" ] <- s[ i, "id" ] 
                
                op_reg[, "is_as" ] <- TRUE 
                
                op_reg[, "is_met" ] <- FALSE 
                
                op_reg[, "is_inter" ] <- FALSE 
                
                op_reg[, "par_file" ] <- 
                    sprintf( fileNameTemplate[[ "r" ]], 
                        formatC( x = s[ i, "id" ], width = idWidth, 
                        flag = "0" ), "par" )
                
                op_reg[, "drivingfile" ] <- 
                    sprintf( fileNameTemplate[[ "r" ]], 
                    sprintf( "%s_inter", formatC( 
                    x = 0L, width = idWidth, 
                    flag = "0" ) ), "bin" )
                
                op_reg[, "output_macro" ] <- 
                    sprintf( fileNameTemplate[[ "macro" ]], 
                        formatC( x = s[ i, "id" ], width = idWidth, 
                        flag = "0" ), "BIN" )
                
               op_reg[, "output_rename" ] <- 
                    sprintf( fileNameTemplate[[ "r" ]], 
                        formatC( x = s[ i, "id" ], width = idWidth, 
                        flag = "0" ), "bin" )
               
               op_reg[, "indump_rename" ] <- 
                    sprintf( fileNameTemplate[[ "r" ]], sprintf( 
                        "%s_indump", formatC( x = s[ i, "id" ], 
                        width = idWidth, flag = "0" ) ), "tmp" ) 
                
                op_reg[, "summary_file" ] <- 
                    sprintf( fileNameTemplate[[ "r" ]], sprintf( 
                        "%s_summary", formatC( x = s[ i, "id" ], 
                        width = idWidth, flag = "0" ) ), "txt" ) 
                
                return( op_reg ) 
            }   
            
        )   
        
        operation_register <- do.call( what = "rbind", 
            args = operation_register )
        
        .muc_logMessage( 
            m = "Identified %s simulations for %s substances", 
            verbose = verbose, log_width = log_width, 
            values = list( nrow( operation_register ), 
            nrow( s ) ), logfiles = temp_log, append = TRUE ) 
    }   
    
    
    
    .muc_logMessage( 
        m = "Substance properties (updated):", 
        verbose = verbose, log_width = log_width, 
        logfiles = temp_log, append = TRUE ) 
    
    .muc_print( x = s, verbose = verbose, 
        log_width = log_width, logfiles = temp_log, 
        append = TRUE )
    
    
    
    .muc_logMessage( 
        m = "Table of par-file(s):", 
        verbose = verbose, log_width = log_width, 
        logfiles = temp_log, append = TRUE ) 
    
    # parfile_table0 <- parfile_table
    # parfile_table0[, "path" ] <- .muc_anonymisePath( 
        # path = parfile_table0[, "path" ], anonymise = anonymise, 
        # winslash = "/" )
    
    .muc_print( 
        x = parfile_table[, colnames(parfile_table) != "path" ], 
        verbose = verbose, log_width = log_width, 
        logfiles = temp_log, append = TRUE )
    # rm( parfile_table0 )
    
    
    .muc_logMessage( 
        m = "Operations register:", 
        verbose = verbose, log_width = log_width, 
        logfiles = temp_log, append = TRUE ) 
    
    .muc_print( x = operation_register, verbose = verbose, 
        log_width = log_width, logfiles = temp_log, 
        append = TRUE )
    
    
    
    .muc_logMessage( 
        m = "Fetch MACRO executables names and location", 
        verbose = verbose, log_width = log_width, 
        logfiles = temp_log, append = TRUE ) 
    
    modelVar <- rmacroliteGetModelVar()
    
    from_to <- sprintf( 
        "%s-%s", 
        formatC( x = min( operation_register[, "run_id" ] ), 
            width = idWidth, flag = "0" ), 
        formatC( x = max( operation_register[, "run_id" ] ), 
            width = idWidth, flag = "0" ) )
    
    log_file <- sprintf( fileNameTemplate[[ "r" ]], sprintf( 
        "%s_log", from_to ), "txt" ) 
    
    s_updated_file <- sprintf( fileNameTemplate[[ "r" ]], sprintf( 
        "%s_s_updated", from_to ), "csv" ) 
    
    operation_register_file <- sprintf( fileNameTemplate[[ "r" ]], sprintf( 
        "%s_operation_register", from_to ), "csv" ) 
    
    par_template_file <- sprintf( fileNameTemplate[[ "r" ]], sprintf( 
        "%s_par_template_id%s", from_to, formatC( 
        x = parfile_table[, "parfile_id" ], 
        width = max( nchar( parfile_table[, "parfile_id" ] ) ), 
        flag = "0" ) ), "par" ) 
    
    analyse_summary_file <- sprintf( fileNameTemplate[[ "r" ]], sprintf( 
        "%s_summary", from_to ), "txt" ) 
    
    md5_file <- sprintf( fileNameTemplate[[ "r" ]], sprintf( 
        "%s_md5", from_to ), "txt" ) 
    
    archive_file <- sprintf( fileNameTemplate[[ "r" ]], sprintf( 
        "%s_archive", from_to ), "tar.gz" )
    
    extra_files <- c( 
        "log_file"           = log_file, 
        "s_updated"          = s_updated_file, 
        "operation_register" = operation_register_file, 
        "analyse_summary"    = analyse_summary_file, 
        "par_template_file"  = par_template_file, 
        "md5_file"           = md5_file, 
        "archive_file"       = archive_file )
    
    if( !overwrite ){
        .muc_logMessage( 
            m = "Check that the files to be created do not exist yet", 
            verbose = verbose, log_width = log_width, 
            logfiles = temp_log, append = TRUE ) 
        
        files_list <- unlist( operation_register[, "par_file" ] ) 
        
        if( indump ){
            files_list <- c( files_list, unlist( operation_register[, 
                "indump_rename" ] ) )
        }   
        
        if( run ){
            files_list <- c( files_list, unlist( operation_register[, 
                c( "output_macro", "output_rename" ) ] ) )
        }   
        
        files_list <- c( files_list, extra_files )
        files_list <- unique( as.character( files_list ) )
        
        files_test <- file.exists( file.path( modelVar[[ "path" ]], 
            files_list ) ) 
        
        if( any( files_test ) ){
            stop( sprintf( 
                "Some file(s) already exist in '%s'. Clean the folder or set 'overwrite' to TRUE to ignore them. %s.", 
                modelVar[["path"]], 
                paste( files_list[ files_test ], collapse = "; " )
            ) ) 
        }   
        
        rm( files_test )
    }   
    
    #   Move log-file
    copy_test <- file.copy(
        from      = temp_log, 
        to        = file.path( modelVar[["path"]], log_file ), 
        overwrite = overwrite )
    
    if( !copy_test ){
        warning( sprintf( 
            "The log-file could not be copied from %s to %s", 
            temp_log, 
            file.path( modelVar[["path"]], log_file )
        ) ) 
        
        log_file <- temp_log
    }else{
        log_file <- file.path( modelVar[["path"]], log_file ) 
        
        .muc_logMessage( m = "All output-files will be now saved in %s", 
            verbose = verbose, log_width = log_width, 
            values = list( .muc_anonymisePath( 
            path = modelVar[["path"]], anonymise = anonymise, 
            winslash = "/", log_width = log_width ) ), 
            logfiles = log_file, append = TRUE ) 
        
        .muc_logMessage( m = "Log-file continues in %s", 
            verbose = verbose, log_width = log_width, 
            values = list( .muc_anonymisePath( path = log_file, 
            anonymise = anonymise, winslash = "/", 
            log_width = log_width ) ), logfiles = log_file, 
            append = TRUE ) 
        
    }   
    
    
    
    .muc_logMessage( 
        m = "Exporting updated substance parameters: %s", 
        verbose = verbose, log_width = log_width, 
        values = list( s_updated_file ), 
        logfiles = log_file, append = TRUE ) 
    
    utils::write.csv( x = s, file = file.path( modelVar[["path"]], 
        s_updated_file ), row.names = FALSE, 
        fileEncoding = "UTF-8" )
    
    
    
    .muc_logMessage( 
        m = "Exporting operation register: %s", 
        verbose = verbose, log_width = log_width, 
        values = list( operation_register_file ), 
        logfiles = log_file, append = TRUE ) 
    
    utils::write.csv( x = operation_register, file = file.path( modelVar[["path"]], 
        operation_register_file ), row.names = FALSE, 
        fileEncoding = "UTF-8" )
    
    
    
    .muc_logMessage( 
        m = "Exporting par-file template(s):", 
        verbose = verbose, log_width = log_width, 
        # values = list( par_template_file ), 
        logfiles = log_file, append = TRUE ) 
    
    for( i in 1:nrow( parfile_table ) ){
        .muc_logMessage( 
            m = "* parfile id %s (%s)", 
            verbose = verbose, log_width = log_width, 
            values = list( parfile_table[ i, "parfile_id" ], 
            par_template_file[ i ] ), 
            logfiles = log_file, append = TRUE ) 
        
        rmacroliteExportParFile( x = parfile_list[[ i ]], 
            f = file.path( modelVar[[ "path" ]], 
            par_template_file[ i ] ), verbose = verbose - 1L )
    }   
    
    
    
    if( run ){
        .muc_logMessage( 
            m = "Parametrising, exporting par-files and running simulations", 
            verbose = verbose, log_width = log_width, 
            frame = "=", logfiles = log_file, append = TRUE ) 
    }else{
        
        .muc_logMessage( 
            m = "Parametrising and exporting par-files", 
            verbose = verbose, log_width = log_width, 
            frame = "=", logfiles = log_file, append = TRUE ) 
    }   
    
    analyse_output <- output_run <- vector( 
        length = nrow(operation_register), 
        mode   = "list" )
    
    for( o in 1:nrow(operation_register) ){
        index_width <- nchar( nrow(operation_register) )
        
        .muc_logMessage( m = "Simulation %s/%s", 
            verbose = verbose, log_width = log_width, frame = "-", 
            values = list( formatC( x = o, width = index_width, 
            flag = "0" ), nrow(operation_register) ), 
            logfiles = log_file, append = TRUE ) 
        
        sel_subst <- s[, "id" ] == operation_register[ o, "id" ] 
        
        if( names_provided ){
            .muc_logMessage( 
                m = "Substance %s. id %s, run id %s", 
                verbose = verbose, log_width = log_width, 
                values = list( 
                    s[ sel_subst, "name" ], 
                    operation_register[ o, "id" ], 
                    operation_register[ o, "run_id" ] ), 
                logfiles = log_file, append = TRUE ) 
            
        }else{
            .muc_logMessage( 
                m = "Substance id %s, run id %s", 
                verbose = verbose, log_width = log_width, 
                values = list( 
                    operation_register[ o, "id" ], 
                    operation_register[ o, "run_id" ] ), 
                logfiles = log_file, append = TRUE ) 
        }   
        
        #   Copy the template parametrisation
        x_o <- parfile_list[[ s[ sel_subst, "parfile_id" ] ]] 
        
        .muc_logMessage( m = "Set substance properties:", 
            verbose = verbose, log_width = log_width, 
            logfiles = log_file, append = TRUE) 
        
        
        
        .muc_logMessage( m = "* Run id", 
            verbose = verbose, log_width = log_width, 
            logfiles = log_file, append = TRUE) 
        
        rmacroliteRunId( x_o ) <- operation_register[ o, "run_id" ]
        
        
        
        #   Note: call to rmacroliteApplications() must be 
        #   done before call to rmacroliteSimType() as the later 
        #   sets the concentration in the irrigation 
        #   water to 0 if it is a metabolite, and that 
        #   causes rmacroliteApplications() not to 
        #   change the irrigation day and fraction 
        #   intercepted either when called after.
        
        .muc_logMessage( 
            m = "* Application rate and date (Julian day) and crop interception", 
            verbose = verbose, log_width = log_width, 
            logfiles = log_file, append = TRUE ) 
        
        if( operation_register[ o, "is_as" ] ){
            g_as_per_ha <- s[ sel_subst, "g_as_per_ha" ] 
            
        }else{
            g_as_per_ha <- 0 
        }   
        
        if( any( c( "AsIs", "list" ) %in% class( g_as_per_ha ) ) ){
            g_as_per_ha <- g_as_per_ha[[ 1L ]]
        }   
        
        app_j_day <- s[ sel_subst, "app_j_day" ]
        
        if( any( c( "AsIs", "list" ) %in% class( app_j_day ) ) ){
            app_j_day <- app_j_day[[ 1L ]]
        }   
        
        f_int <- s[ sel_subst, "f_int" ]
        
        if( any( c( "AsIs", "list" ) %in% class( f_int ) ) ){
            f_int <- f_int[[ 1L ]]
        }   
        
        if( focus_mode == "gw" ){
            rmacroliteApplications( x = x_o, keep0conc = keep0conc, 
                focus_mode = focus_mode ) <- list(
                "g_as_per_ha"    = g_as_per_ha,
                "app_j_day"      = app_j_day,
                "f_int"          = f_int, 
                "years_interval" = s[ sel_subst, "years_interval" ] ) 
        }else{
            rmacroliteApplications( x = x_o, keep0conc = keep0conc, 
                focus_mode = focus_mode ) <- list(
                "g_as_per_ha" = g_as_per_ha,
                "app_j_day"   = app_j_day,
                "f_int"       = f_int ) 
        }   
        
        rm( g_as_per_ha, app_j_day, f_int )
        
        
        
        if( metabolites ){
            .muc_logMessage( m = "* Simulation type", 
                verbose = verbose, log_width = log_width, 
                logfiles = log_file, append = TRUE) 
        }else{
            .muc_logMessage( 
                m = "* Simulation type (incl metabolites conversion factor) and information", 
                verbose = verbose, log_width = log_width, 
                logfiles = log_file, append = TRUE) 
        }   
        
        if( operation_register[ o, "is_as" ] & (!operation_register[ o, "is_inter" ]) ){
            #   Parent/ active substance, not intermediate
            type      <- 1L 
            type_text <- "parent"
            
        }else if( operation_register[ o, "is_as" ] & operation_register[ o, "is_inter" ] ){
            #   Parent/ active substance, intermediate
            type      <- 2L 
            type_text <- "parent, intermediate"
            
        }else if( (!operation_register[ o, "is_as" ]) & (!operation_register[ o, "is_inter" ]) ){
            #   Parent/ active substance, not intermediate
            type      <- 3L 
            type_text <- "metabolite"
            
        }else{
            #   Parent/ active substance, not intermediate
            type      <- 4L 
            type_text <- "metabolite, intermediate"
            
        }   
        
        .muc_logMessage( 
            m = "* Simulation identified as: %s", 
            verbose = verbose, log_width = log_width, 
            values = list( type_text ), 
            logfiles = log_file, append = TRUE ) 
        
        if( metabolites ){
            rmacroliteSimType( x = x_o ) <- list( 
                "type"        = type, 
                "drivingfile" = operation_register[ o, "drivingfile" ], 
                "f_conv"      = ifelse( 
                    test = operation_register[ o, "is_as" ], 
                    yes  = 0, 
                    no   = s[ sel_subst, "f_conv" ] ) )
            
        }else{
            rmacroliteSimType( x = x_o ) <- list( 
                "type"        = type, 
                "drivingfile" = operation_register[ o, "drivingfile" ], 
                "f_conv"      = 0 )
        }   
        
        
        
        .muc_logMessage( m = "* Sorption parameters", 
            verbose = verbose, log_width = log_width, 
            logfiles = log_file, append = TRUE ) 
        
        rmacroliteSorption( x = x_o ) <- c( 
            "kfoc" = s[ sel_subst, "kfoc" ], 
            "nf" = s[ sel_subst, "nf" ] ) 
        
        
        
        .muc_logMessage( m = "* Degradation parameters", 
            verbose = verbose, log_width = log_width, 
            logfiles = log_file, append = TRUE ) 
        
        rmacroliteDegradation( 
            x            = x_o, 
            dt50_depth_f = dt50_depth_f ) <- c( 
            "dt50" = s[ sel_subst, "dt50" ], 
            "dt50_ref_temp" = s[ sel_subst, "dt50_ref_temp" ], 
            "dt50_pf" = s[ sel_subst, "dt50_pf" ], 
            "exp_temp_resp" = s[ sel_subst, "exp_temp_resp" ], 
            "exp_moist_resp" = s[ sel_subst, "exp_moist_resp" ] ) 
        
        
        
        .muc_logMessage( m = "* Crop uptake factor", 
            verbose = verbose, log_width = log_width, 
            logfiles = log_file, append = TRUE ) 
        
        rmacroliteCropUptF( x = x_o ) <- s[ sel_subst, "crop_upt_f" ] 
        
        
        
        .muc_logMessage( m = "* Diffusion coefficient", 
            verbose = verbose, log_width = log_width, 
            logfiles = log_file, append = TRUE ) 
        
        rmacroliteDiffCoef( x = x_o ) <- s[ sel_subst, "diff_coef" ]
        
        
        
        .muc_logMessage( 
            m = "* Information section (end of par-file)", 
            verbose = verbose, log_width = log_width, 
            logfiles = log_file, append = TRUE ) 
        
        
        new_info <- list( 
            "output_file" = file.path( modelVar[["path"]], 
                tolower( operation_register[ o, "output_macro" ] ), 
                fsep = "\\" ), 
            "type" = type_text, 
            "compound" = s[ sel_subst, "name" ] )
        
        if( focus_mode == "gw" ){
            new_info <- c( new_info, list( "years_interval" = 
                s[ sel_subst, "years_interval" ] ) )
        }   
        
        rmacroliteInfo( x = x_o ) <- new_info
        
        
        
        .muc_logMessage( m = "Exporting the par-file (%s)", 
            verbose = verbose, log_width = log_width, values = 
            list( operation_register[ o, "par_file" ] ), 
            logfiles = log_file, append = TRUE ) 
        
        f <- operation_register[ o, "par_file" ]
        
        rmacroliteExportParFile( x = x_o, 
            f = file.path( modelVar[[ "path" ]], f ), 
            verbose = verbose - 1L )
        
        
        if( indump & run ){
            .muc_logMessage( m = "Generate indump.tmp and run MACRO simulation", 
                verbose = verbose, log_width = log_width, 
                logfiles = log_file, append = TRUE ) 
        }else if( indump ){
            .muc_logMessage( m = "Generate indump.tmp", 
                verbose = verbose, log_width = log_width, 
                logfiles = log_file, append = TRUE ) 
        }else{
            .muc_logMessage( m = "Generate indump.tmp: SKIPPED", 
                verbose = verbose, log_width = log_width, 
                logfiles = log_file, append = TRUE ) 
        }   
        
        if( indump | run ){
            output_run[[ o ]] <- rmacroliteRun( 
                x = normalizePath( file.path( modelVar[[ "path" ]], f ) ), 
                export = FALSE, verbose = verbose - 1L, 
                indump = indump, run = run ) 
        }   
        
        if( !run ){
            .muc_logMessage( m = "Run MACRO simulation: SKIPPED", 
                verbose = verbose, log_width = log_width, 
                logfiles = log_file, append = TRUE ) 
        }   
        
        if( indump ){
            indump_rename <- operation_register[ o, "indump_rename" ] 
            
            .muc_logMessage( m = "Rename indump.tmp to %s", 
                verbose = verbose, log_width = log_width, 
                values = list( indump_rename ), 
                logfiles = log_file, append = TRUE ) 
            
            rename_result0 <- file.rename( 
                from = file.path( modelVar[[ "path" ]], "indump.tmp" ), 
                to   = file.path( modelVar[[ "path" ]], indump_rename ) )
            
            if( !rename_result0 ){
                warning( sprintf(
                    "Unable to rename the file (from indump.tmp to %s, in %s).", 
                    indump_rename, 
                    modelVar[[ "path" ]]
                ) ) 
            };  rm( rename_result0 )
        }   
        
        if( run ){
            macro_runtime <- attr( x = output_run[[ o ]], 
                which = "macro_runtime" )
            
            .muc_logMessage( m = "MACRO runtime %s min", 
                verbose = verbose, log_width = log_width, 
                values = list( round( macro_runtime, 2L ) ), 
                logfiles = log_file, append = TRUE ) 
            
            output_macro  <- operation_register[ o, "output_macro" ] 
            output_rename <- operation_register[ o, "output_rename" ]
            
            .muc_logMessage( m = "Rename MACRO output from %s to %s", 
                verbose = verbose, log_width = log_width, 
                values = list( output_macro, output_rename ), 
                logfiles = log_file, append = TRUE ) 
            
            
            rename_result <- file.rename( 
                from = file.path( modelVar[[ "path" ]], output_macro ), 
                to   = file.path( modelVar[[ "path" ]], output_rename ) )
            
            if( !rename_result ){
                warning( sprintf(
                    "Unable to rename the file (from %s to %s, in %s). Errors may occur later", 
                    output_macro, 
                    output_rename, 
                    modelVar[[ "path" ]]
                ) ) 
            };  rm( rename_result )
            
            if( (!operation_register[ o, "is_inter" ]) & (!is.null( analyse )) ){                
                .muc_logMessage( m = "Analyse simulation results:", 
                    verbose = verbose, log_width = log_width, 
                    logfiles = log_file, append = TRUE ) 
                
                if( length( analyse_args ) > 0L ){
                    analyse_output[[ o ]] <- do.call( 
                        what = "analyse", args = c( list( 
                        "x" = output_run[[ o ]] ), analyse_args ) )
                }else{
                    analyse( x = output_run[[ o ]] )
                }   
                
                .muc_print( x = analyse_output[[ o ]], 
                    verbose = verbose, 
                    log_width = log_width, 
                    logfiles = c( log_file, file.path( 
                        modelVar[["path"]], 
                        operation_register[ o, "summary_file" ] ) ), 
                    append = c( TRUE, FALSE ) ) 
            }   
        }   
        
    }   
    
    
    
    .muc_logMessage( m = "Post-processing operations", 
        verbose = verbose, log_width = log_width, 
        logfiles = log_file, append = TRUE, frame = "=" ) 
    
    .muc_logMessage( m = "Information (traceability & reproducibility)", 
        verbose = verbose, log_width = log_width, 
        logfiles = log_file, append = TRUE, frame = "-") 
    
    
    
    .muc_logMessage( m = "Call from package: '%s'", 
        verbose = verbose, log_width = log_width, 
        logfiles = log_file, append = TRUE, 
        values = list( ifelse( 
        test = is.null( .muc_internals[[ "package" ]] ), 
        yes = "Not an R package; May be an R-script.", 
        no = .muc_internals[[ "package" ]] ) ) ) 
    
    
    
    macro_version <- rmacroliteMacroVersion( 
        path = modelVar[[ "path" ]] )
    
    if( all( is.na( macro_version ) ) ){
        .muc_logMessage( m = "Model: (unknown)", 
            verbose = verbose, log_width = log_width, 
            logfiles = log_file, append = TRUE ) 
    }else{
        .muc_logMessage( m = "Model: %s; core-model version: %s", 
            verbose = verbose, log_width = log_width, 
            logfiles = log_file, append = TRUE, 
            values = list( macro_version[[ "name" ]], 
            macro_version[[ "model_v" ]] ) ) 
    }   
    
    
    
    .muc_logMessage( m = "Information on system, packages and executables", 
        verbose = verbose, log_width = log_width, 
        logfiles = log_file, append = TRUE ) 
    
    #   Find all .exe and .dll in model directory
    exe_dll <- list.files( modelVar[[ "path" ]] ) 
    test_exe_dll <- nchar( exe_dll ) 
    test_exe_dll <- substr( 
        x     = tolower( exe_dll ), 
        start = test_exe_dll - 3L, 
        stop  = test_exe_dll )
    exe_dll <- exe_dll[ test_exe_dll %in% c( ".exe", ".dll" ) ]
    
    code_info <- codeinfo( 
        r = TRUE, 
        packages = c( "macrounchained", "rmacrolite", 
            "macroutils2", "codeinfo" ), 
        files = exe_dll, 
        files_path = modelVar[[ "path" ]], 
        objects = list( "analyse" = analyse, 
            "analyse_summary" = analyse_summary ) ) 
    
    rm( test_exe_dll, exe_dll )
    
    .muc_print( x = code_info, 
        verbose = verbose, 
        log_width = log_width, 
        logfiles = log_file, 
        append = TRUE ) 
    
    
    
    .muc_logMessage( m = "Original call:", 
        verbose = verbose, log_width = log_width, 
        logfiles = log_file, append = TRUE )
    
    .muc_logMessage( m = paste( deparse( 
        .muc_internals[[ "match_call" ]], width.cutoff = 500L ), 
        collapse = "" ), 
        verbose = verbose, log_width = log_width, 
        logfiles = log_file, append = TRUE )
    
    # .muc_logMessage( m = "Call arguments:", 
        # verbose = verbose, log_width = log_width, 
        # logfiles = log_file, append = TRUE )
    
    # .muc_print( x = original_args, verbose = verbose, 
        # log_width = log_width, logfiles = temp_log, 
        # append = TRUE )
    
    
    
    .muc_logMessage( m = "Final step(s)", frame = "-", 
        verbose = verbose, log_width = log_width, 
        logfiles = log_file, append = TRUE ) 
    
    
    
    if( run & !is.null( analyse_summary ) ){
        info <- operation_register[ c( "id", "run_id" ) ] 
        
        if( names_provided ){
            info <- merge(
                x     = info, 
                y     = s[, c( "id", "name" ) ], 
                by    = "id", 
                all.x = TRUE, 
                sort  = FALSE 
            )   
        }   
        
        analyse_summary_output <- analyse_summary( 
            x    = analyse_output, 
            info = info )
        
        rm( info ) 
        
        .muc_logMessage( m = "Output summary (%s):", 
            verbose = verbose, log_width = log_width, 
            logfiles = log_file, append = TRUE, 
            values = list( analyse_summary_file ) ) 
        
        .muc_print( x = analyse_summary_output, 
            verbose = verbose, 
            log_width = log_width, 
            logfiles = c( log_file, file.path( 
                        modelVar[["path"]], 
                        analyse_summary_file ) ), 
            append = c( TRUE, FALSE ) )
    }else{
        analyse_summary_output <- NULL 
    }   
    
    
    
    .muc_logMessage( m = "Formatting output", 
        verbose = verbose, log_width = log_width, 
        logfiles = log_file, append = TRUE ) 
    
    out <- list( 
        # "original_args"      = original_args, 
        "s_updated"              = s, 
        "operation_register"     = operation_register, 
        "extra_files"            = extra_files, 
        "analyse_output"         = analyse_output, 
        "analyse_summary_output" = analyse_summary_output ) 
    
    
    
    #   Save the start time, for later use
    timeStart <- .muc_internals[[ "timeStart" ]]
    
    .muc_logMessage( m = "Internal clean-up", 
        verbose = verbose, log_width = log_width, 
        logfiles = log_file, append = TRUE ) 
    
    rm( list = ls( envir = .muc_internals, all.names = TRUE ), 
        envir = .muc_internals )
    
    
    
    duration  <- as.numeric( difftime( Sys.time(),  timeStart, 
        units = "mins" ) ) 
    
    .muc_logMessage( m = "Total operation time at this point: %s mins", 
        verbose = verbose, log_width = log_width, 
        logfiles = log_file, append = TRUE, 
        values = round( duration, 3 ) ) 
    
    
    
    if( archive ){
        .muc_logMessage( m = "FINAL STEP: Calculate md5-checksums for generated files (%s) and archive them (%s)", 
            verbose = verbose, log_width = log_width, 
            logfiles = log_file, append = TRUE, 
            values = list( md5_file, archive_file ) ) 
    }else{
        .muc_logMessage( m = "FINAL STEP: Calculate md5-checksums for generated files (%s)", 
            verbose = verbose, log_width = log_width, 
            logfiles = log_file, append = TRUE, 
            values = list( md5_file ) ) 
    }   
    
    all_files <- unlist( operation_register[, c( "par_file", 
        "summary_file" ) ] ) 
    
    if( indump ){
        all_files <- c( all_files, 
            unlist( operation_register[, "indump_rename" ] ) )
    }   
    
    if( run ){
        all_files <- c( all_files, 
            unlist( operation_register[, "output_rename" ] ) )
    }   
    
    all_files <- as.character( c( all_files, extra_files ) ) 
    all_files <- all_files[ !is.na( all_files ) ] 
    # names( all_files ) <- NULL 
    # all_files <- file.path( modelVar[[ "path" ]], all_files )
    all_files <- all_files[ file.exists( file.path( 
        modelVar[[ "path" ]], all_files ) ) ] 
    all_files <- all_files[ all_files != archive_file ] 
    all_files <- all_files[ all_files != md5_file ] 
    
    code_info2 <- codeinfo( 
        r          = FALSE, 
        files      = all_files, 
        files_path = modelVar[[ "path" ]] ) 
    
    utils::write.table(
        x     = code_info2[[ "files" ]][, c("md5_checksums", "files" ) ], 
        file  = file.path( modelVar[[ "path" ]], md5_file ), 
        sep   = " ", 
        quote = FALSE, 
        row.names    = FALSE,
        col.names    = FALSE, 
        fileEncoding = "UTF-8" ) 
    
    all_files <- c( all_files, md5_file )
    
    if( archive ){
        archive_file0 <- file.path( modelVar[[ "path" ]], 
            archive_file ) 
        
        if( file.exists( archive_file0 ) ){
            if( !file.remove( archive_file0 ) ){
                .muc_logMessage( m = "WARNING: could not remove file %s", 
                    fun = warning, verbose = verbose, 
                    log_width = log_width, logfiles = log_file, 
                    append = TRUE, values = list( archive_file ) ) 
            }   
        }   
        
         muc_tar_out <- .muc_tar( 
            tarfile = archive_file0, 
            files   = file.path( modelVar[[ "path" ]], 
                all_files ) ) 
        
        if( !muc_tar_out ){
            .muc_logMessage( m = "WARNING: archiving failed", 
                fun = warning, verbose = verbose, 
                log_width = log_width, logfiles = log_file, 
                append = TRUE ) 
        }   
    }   
    
    
    
    return( out )
}   



# macroutilsFocusGWConc_summary ============================

#' Summarise one or several output results from macroutilsFocusGWConc (package macroutils2)
#'
#' Summarise one or several output results from 
#'  \code{\link[macroutils2:macroutilsFocusGWConc-methods]{macroutilsFocusGWConc}} 
#'  (package macroutils2). The functions is designed to be 
#'  passed to \code{\link[macrounchained:macrounchained-methods]{macrounchained}}, 
#'  via the argument \code{analyse_summary}.
#'
#'
#'@param x
#'  A \code{\link{list}}, where each item is the output from 
#'  \code{\link[macroutils2:macroutilsFocusGWConc-methods]{macroutilsFocusGWConc}}.
#'
#'@param info
#'  A \code{\link[base]{data.frame}} with as many rows as 
#'  items in \code{x}. Expected columns are \code{id} (the 
#'  substance identifier), \code{run_id} (the simulation 
#'  identifier) and optionally \code{name} (the name of the 
#'  substance).
#'
#'@param \dots
#'  Additional parameters passed to specific methods. 
#'  Currently not used.
#' 
#'
#'@return
#'  A \code{\link[base]{data.frame}} with selected output 
#'  variables from \code{x} merged with \code{info}. Items 
#'  in \code{x} that are \code{NULL} are not retained.
#' 
#'
#'@rdname macroutilsFocusGWConc_summary-methods
#'@aliases macroutilsFocusGWConc_summary
#'
#'@export 
#'
#'@docType methods
#'
macroutilsFocusGWConc_summary <- function(
    x,
    ...
){  
    UseMethod( "macroutilsFocusGWConc_summary" )
}   



#'@rdname macroutilsFocusGWConc_summary-methods
#'
#'@method macroutilsFocusGWConc_summary list
#'
#'@export 
#'
macroutilsFocusGWConc_summary.list <- function(
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
        "target_ug_per_L"       = NA_real_, 
        "target_ug_per_L_rnd"   = NA_real_, 
        "target_index_period1"  = NA_real_, 
        "target_index_period2"  = NA_real_, 
        "perc_period1_mm"       = NA_real_, 
        "perc_period2_mm"       = NA_real_  
        # "perc_ug_per_L"         = NA_real_, 
        # "perc_ug_per_L_rnd"     = NA_real_, 
        # "perc_index_period1"    = NA_real_, 
        # "perc_index_period2"    = NA_real_ 
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
                
                out_i[, "target_ug_per_L" ] <- 
                    x[[ i ]][[ "conc_target_layer" ]][ , "ug_per_L" ]
                    
                out_i[, "target_ug_per_L_rnd" ] <- 
                    x[[ i ]][[ "conc_target_layer" ]][ , "ug_per_L_rnd" ]
                    
                out_i[, "target_index_period1" ] <- 
                    x[[ i ]][[ "conc_target_layer" ]][ , "index_period1" ]
                    
                out_i[, "target_index_period2" ] <- 
                    x[[ i ]][[ "conc_target_layer" ]][ , "index_period2" ]
                
                out_i[, "perc_period1_mm" ] <- 
                    x[[ i ]][[ "water_perc_by_period" ]][ 
                        out_i[, "target_index_period1" ], 
                        "mm" ]
                
                out_i[, "perc_period2_mm" ] <- 
                    x[[ i ]][[ "water_perc_by_period" ]][ 
                        out_i[, "target_index_period2" ], 
                        "mm" ]
                
                # out_i[, "perc_ug_per_L" ] <- 
                    # x[[ i ]][[ "conc_perc" ]][ , "ug_per_L" ]
                # out_i[, "perc_ug_per_L_rnd" ] <- 
                    # x[[ i ]][[ "conc_perc" ]][ , "ug_per_L_rnd" ]
                # out_i[, "perc_index_period1" ] <- 
                    # x[[ i ]][[ "conc_perc" ]][ , "index_period1" ]
                # out_i[, "perc_index_period2" ] <- 
                    # x[[ i ]][[ "conc_perc" ]][ , "index_period2" ]
                
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



# macrounchainedFocusGW ====================================

#' Batch run MACRO In FOCUS groundwater simulations with different substance properties and application patterns
#'
#' Batch run MACRO In FOCUS groundwater simulations with 
#'  different substance properties and application patterns, 
#'  starting from a template imported MACRO par-file, 
#'  including metabolites. Wrapper for 
#'  \code{\link[macrounchained]{macrounchained-methods}}.
#'
#'
#'@param s
#'  See \code{\link[macrounchained]{macrounchained-methods}}, 
#'  with the exception of the column \code{f_int}, that should 
#'  not be provided here, as it is internally set to 0\%.
#'  The results are analysed automatically with 
#'  \code{\link[macroutils2:macroutilsFocusGWConc-methods]{macroutilsFocusGWConc}} and 
#'  \code{\link[macrounchained:macroutilsFocusGWConc_summary-methods]{macroutilsFocusGWConc_summary}}.
#'
#'@param parfile
#'  See \code{\link[macrounchained]{macrounchained-methods}}.
#'
#'@param verbose
#'  See \code{\link[macrounchained]{macrounchained-methods}}.
#'
#'@param indump
#'  See \code{\link[macrounchained]{macrounchained-methods}}.
#'
#'@param run
#'  See \code{\link[macrounchained]{macrounchained-methods}}.
#'
#'@param overwrite
#'  See \code{\link[macrounchained]{macrounchained-methods}}.
#'
#'@param analyse_args 
#'  See \code{\link[macrounchained]{macrounchained-methods}}.
#'  List of additional arguments passed to 
#'  \code{\link[macroutils2:macroutilsFocusGWConc-methods]{macroutilsFocusGWConc}}.
#'
#'@param dt50_depth_f
#'  See \code{\link[rmacrolite:rmacroliteDegradation-methods]{rmacroliteDegradation}}.
#'
#'@param anonymise
#'  See \code{\link[macrounchained]{macrounchained-methods}}.
#'
#'@param archive
#'  See \code{\link[macrounchained]{macrounchained-methods}}.
#'
#'@param \dots
#'  See \code{\link[macrounchained]{macrounchained-methods}}.
#'
#'
#'@return
#'  TO BE WRITTEN.
#' 
#'
#'@rdname macrounchainedFocusGW-methods
#'@aliases macrounchainedFocusGW
#'
#'@export 
#'
#'@docType methods
#'
macrounchainedFocusGW <- function( 
    s, 
    ... 
){  
    .muc_internals[[ "match_call" ]] <- match.call()
    
    .muc_internals[[ "package" ]] <- utils::packageName()
    
    .muc_internals[[ "timeStart" ]] <- Sys.time() 
    
    UseMethod( generic = "macrounchainedFocusGW" )
}   



#'@rdname macrounchainedFocusGW-methods
#'
#'@method macrounchainedFocusGW data.frame
#'
#'@export 
#'
#'@importFrom macroutils2 macroutilsFocusGWConc 
macrounchainedFocusGW.data.frame <- function( 
    s, 
    parfile, 
    verbose = 1L, 
    indump = TRUE, 
    run = TRUE, 
    overwrite = FALSE, 
    # analyse = NULL, 
    analyse_args = list( "quiet" = TRUE ), 
    # analyse_summary = NULL, 
    dt50_depth_f = NULL, 
    # keep0conc = TRUE, 
    anonymise = TRUE, 
    archive = TRUE, 
    ... 
){  
    dotdotdot <- list( ... ) 
    
    if( length( list(...) ) > 0L ){
        warning( sprintf(  
            "Additional arguments passed via '...', while '...' currently not in use (%s)", 
            paste( names( dotdotdot ), collapse = ", " )
        ) ) 
    }   
    
    
    
    if( is.null( .muc_internals[[ "match_call" ]] ) ){
        .muc_internals[[ "match_call" ]] <- match.call()
    }   
    
    if( is.null( .muc_internals[[ "package" ]] ) ){
        .muc_internals[[ "package" ]] <- utils::packageName()
    }   
    
    if( is.null( .muc_internals[[ "timeStart" ]] ) ){
        .muc_internals[[ "timeStart" ]] <- Sys.time()
    }   
    
    
    
    #   Test if s is a data.frame
    if( !("data.frame" %in% class(s)) ){
        stop( sprintf( 
            "'s' must be a data.frame. Now class %s", 
            paste( class(s), collapse = ", " ) ) ) 
    }   
    
    #   Set the crop interception to 0 
    if( "f_int" %in% colnames( s ) ){
        stop( "'s' should not have a column named 'f_int'. Interception is set to 0 internally." )
    }else{
        s[, "f_int" ] <- 0 
    }   
    
    
    return( macrounchained( 
        s               = s, 
        parfile         = parfile, 
        verbose         = verbose, 
        indump          = indump, 
        run             = run, 
        overwrite       = overwrite, 
        analyse         = macroutilsFocusGWConc, 
        analyse_args    = analyse_args, 
        analyse_summary = macroutilsFocusGWConc_summary, 
        dt50_depth_f    = dt50_depth_f, 
        # keep0conc       = keep0conc, 
        focus_mode      = "gw", 
        anonymise       = anonymise, 
        archive         = TRUE, 
        ... 
    ) ) 
}   



# Utility functions for FOCUS scenario parametrisation
# ==========================================================

.muc_sanitize <- function( x, from = "", to = "ASCII//TRANSLIT" ){
    x <- tolower( x = x ) 
    
    return( iconv( 
        x    = x, 
        from = "", 
        to   = "ASCII//TRANSLIT" ) )
}   



.muc_sanitize_more <- function( x, from = "", to = "ASCII//TRANSLIT" ){
    x <- .muc_sanitize( x = x, from = from, to = to ) 
    
    #   Replace minus signs by spaces
    x <- gsub( pattern = "-", replacement = "", x = x, 
        fixed = TRUE ) 
    
    #   Replace minus signs by spaces
    x <- gsub( pattern = " ", replacement = "", x = x, 
        fixed = TRUE ) 
    
    #   Replace comma by nothing
    x <- gsub( pattern = ",", replacement = " ", x = x, 
        fixed = TRUE ) 
    
    return( x )
}   



.muc_grepl <- function( input, match_list ){
    output <- lapply(
        X   = input, 
        FUN = function(p){
            return( grepl( pattern = p, x = match_list, 
                fixed = TRUE ) )
        }   
    )   
    
    output <- do.call( what = "rbind", args = output )
    
    return( output )
}   

    # .muc_grepl( input = c( "chat", "onn" ),  match_list = c( "chateaudun", "onnestad", "D1" ) )



.muc_match_soil <- function( soil, soil_list, soil_list_enc = "UTF-8" ){
    # soil_sanitized <- enc2utf8( x = soil )
    soil_sanitized <- .muc_sanitize( x = soil )
    
    soil_list_sanitized <- .muc_sanitize( 
        x    = soil_list, 
        from = soil_list_enc, 
        to   = "ASCII//TRANSLIT" ) 
    
    grepl_res <- .muc_grepl( input = soil_sanitized, 
        match_list = soil_list_sanitized ) 
    
    rowsums_grepl_res <- rowSums( grepl_res ) 
    
    if( any( sel <- rowsums_grepl_res == 0L ) ){
        soil <- soil[ sel ] 
        soil <- paste0( '"', soil, '"' )
        soil <- paste( soil, collapse = ", " ) 
        
        soil_list <- paste0( '"', soil_list, '"' )
        soil_list <- paste( soil_list, collapse = ", " ) 
        
        stop( sprintf( 
            "The name(s) %s is/are not matched by any known scenario (%s).", 
            soil, soil_list ) )
    };  rm( sel )
    
    if( any( sel <- rowsums_grepl_res > 1L ) ){
        #   Report the first case matched by multiple scenario
        soil <- soil[ sel ] 
        soil <- paste0( '"', soil, '"' )
        soil <- paste( soil, collapse = ", " ) 
        
        if( sum( sel ) == 1L ){
            soil_list <- soil_list[ as.logical( grepl_res[ 
                which( sel )[ 1L ], ] ) ] 
            soil_list <- paste0( '"', soil_list, '"' )
            soil_list <- paste( soil_list, collapse = ", " ) 
            
            stop( sprintf( 
                "The name %s is (partially) matched by several scenario (%s).", 
                soil, soil_list ) )
        }else{
            rowsums_grepl_res <- rowsums_grepl_res[ sel ] 
            rowsums_grepl_res <- paste( rowsums_grepl_res, 
                collapse = ", " ) 
            
            stop( sprintf( 
                "The names %s are (partially) matched by several scenario (by %s scenario, respectively).", 
                soil, rowsums_grepl_res ) )
        }   
    };  rm( sel )
    
    rm( rowsums_grepl_res ) 
    
    focus_soil_index <- unlist( lapply(
        X   = 1:length( soil ), 
        FUN = function(i){
            return( which( grepl_res[ i, ] ) )
        }   
    ) ) 
    
    output <- list(
        "rows" = data.frame(
            "soil" = soil, 
            "soil_sanitized" = soil_sanitized, 
            "focus_soil" = soil_list[ focus_soil_index ], 
            "focus_soil_index" = focus_soil_index, 
            stringsAsFactors = FALSE ), 
        "columns"   = data.frame(
            "soil_list"           = soil_list, 
            "soil_list_sanitized" = soil_list_sanitized, 
            stringsAsFactors      = FALSE ), 
        "matches"   = grepl_res 
    )   
    
    return( output )
}   

    # unique_location <- unique( read.csv( 
        # file = sprintf( "%s/macrounchained/macrounchained/_package_preparation/focus_scenario/5.5.4/crops/crops_utf8.csv", Sys.getenv( "rPackagesDir" ) ), 
        # stringsAsFactors = FALSE, fileEncoding = "UTF-8" )[, "location" ] )
    
    # unique_location
    # # [1] "Chateaudun" "D1"         "D2"         "D3"         "D4"         "D5"         "D6"         "Karup"      "Krusenberg" "Langvad"    "Näsbygård"  "Önnestad"

    # .muc_match_soil( soil = c( "chat", "chât", "Chateaudun", "onn" ), soil_list = unique_location )

    # #   Error: Multiple matches (1)
    # .muc_match_soil( soil = "D", soil_list = unique_location )

    # #   Error: Multiple matches (2)
    # .muc_match_soil( soil = c( "D", "ar" ), soil_list = unique_location )

    # #   Error: No match
    # .muc_match_soil( soil = "nowhere", soil_list = unique_location )



.muc_match_soil_crop <- function( soil_crop, soil_crop_list, soil_crop_list_enc = "UTF-8" ){
    match_soil <- .muc_match_soil( 
        soil          = soil_crop[, "soil" ], 
        soil_list     = unique( soil_crop_list[, "focus_soil" ] ), 
        soil_list_enc = soil_crop_list_enc )
    
    soil_crop[, "focus_soil" ] <- 
        match_soil[[ "rows" ]][, "focus_soil" ]
    
    soil_sanitized <- match_soil[[ "rows" ]][, "soil_sanitized" ]
    
    soil_crop_list[, "focus_index" ] <- 1:nrow( soil_crop_list )
    
    crop_sanitized <- .muc_sanitize_more( 
        x = soil_crop[, "crop" ] )
    
    crop_sanitized2 <- strsplit( x = crop_sanitized, 
        split = " ", fixed = TRUE ) 
    
    soil_crop <- data.frame(
        soil_crop, 
        "crop_sanitized2" = I( crop_sanitized2 ), 
        stringsAsFactors = FALSE ) 
    
    crop_list_sanitized <- .muc_sanitize_more( 
        x    = soil_crop_list[, "focus_crop" ], 
        from = soil_crop_list_enc, 
        to   = "ASCII//TRANSLIT" ) 
    
    crop_list_sanitized2 <- strsplit( x = crop_list_sanitized, 
        split = " ", fixed = TRUE ) 
    
    soil_crop_list <- data.frame(
        soil_crop_list, 
        "crop_list_sanitized2" = I( crop_list_sanitized2 ), 
        stringsAsFactors = FALSE )
        
    soil_crop_list_split <- split( 
        x = soil_crop_list, 
        f = soil_crop_list[, "focus_soil" ] )
    
    output <- lapply(
        X   = 1:nrow( soil_crop ), 
        FUN = function(i){
            focus_soil_i <- match_soil[[ "rows" ]][ i, "focus_soil" ]
            
            # browser()
            
            crop_list_sanitized2b <- 
                soil_crop_list_split[[ focus_soil_i ]][, "crop_list_sanitized2" ]
            
            out_i <- unlist( lapply(
                X   = 1:length( crop_list_sanitized2b ), 
                FUN = function(j){
                    out_j <- lapply(
                        X   = 1:length( crop_sanitized2[[ i ]] ), 
                        FUN = function(k){
                            out_k <- grep( 
                                pattern = crop_sanitized2[[ i ]][ k ], 
                                x       = crop_list_sanitized2b[[ j ]], 
                                fixed   = TRUE, 
                                value   = FALSE ) 
                            
                            return( out_k )
                        }   
                    ) 
                    
                    # if( any(crop_sanitized2[[ i ]] == "sugarbeets") & (j == 11L) ){
                        # browser()
                    # }   
                    
                    #   Some element of crop_sanitized2[[ i ]] 
                    #   not matched by anything in 
                    #   crop_list_sanitized2b[[ j ]]?
                    out_j_length_0 <- unlist( lapply( 
                        X = out_j, 
                        FUN = function(x){length(x)==0L} ) )
                    
                    out_j <- unique( unlist( out_j ) ) 
                    
                    out_j <- 
                        all( (1:length(crop_list_sanitized2b[[ j ]])) %in% out_j ) & 
                        !any( out_j_length_0 ) 
                    
                    return( out_j )
                    #   TRUE indicates that crop_sanitized2[[ i ]] 
                    #   matches all elements of crop_list_sanitized2[[ j ]]
                    #   FALSE may indicates no matches or 
                    #   only some elements of crop_list_sanitized2[[ j ]]
                }   
            ) ) 
            
            if( sum( out_i ) == 0L ){
                crop <- soil_crop[ i, "crop" ]
                crop <- paste0( '"', crop, '"' )
                crop <- paste( crop, collapse = ", " ) 
                
                crop_list <- soil_crop_list_split[[ focus_soil_i ]][, "focus_crop" ]
                crop_list <- paste0( '"', crop_list, '"' )
                crop_list <- paste( crop_list, collapse = ", " ) 
                
                stop( sprintf( 
                    "The name(s) %s is/are not matched by any known FOCUS-crop for FOCUS-scenario \"%s\" (%s).", 
                    crop, focus_soil_i, crop_list ) )
            }   
            
            if( sum( out_i ) > 1L ){
                #   Report the first case matched by multiple crop
                crop <- soil_crop[ i, "crop" ] 
                crop <- paste0( '"', crop, '"' )
                crop <- paste( crop, collapse = ", " ) 
                
                crop_list <- soil_crop_list_split[[ focus_soil_i ]][ out_i, "focus_crop" ]
                crop_list <- paste0( '"', crop_list, '"' )
                crop_list <- paste( crop_list, collapse = ", " ) 
                
                stop( sprintf( 
                    "The name %s is (partially) matched by several FOCUS-crop for FOCUS-scenario \"%s\" (%s).", 
                    crop, focus_soil_i, crop_list ) )
            }   
            
            return( soil_crop_list_split[[ focus_soil_i ]][ out_i, c( "focus_soil", "focus_crop", "focus_index" ) ] )
        }   
    )   
    
    output <- do.call( what = "rbind", args = output ) 
    
    output <- data.frame(
        "crop" = soil_crop[, "crop" ], 
        "soil" = soil_crop[, "soil" ], 
        # "crop_sanitized" = crop_sanitized, 
        # "soil_sanitized" = soil_sanitized, 
        output, 
        stringsAsFactors = FALSE )
    
    rownames( output ) <- NULL 
    
    return( output )
}   

    # soil_crop_list0 <- unique( read.csv( 
        # file = sprintf( "%s/macrounchained/macrounchained/_package_preparation/focus_scenario/5.5.4/crops/crops_utf8.csv", Sys.getenv( "rPackagesDir" ) ), 
        # stringsAsFactors = FALSE, fileEncoding = "UTF-8" )[, c( "location", "name" ) ] )
    
    # colnames( soil_crop_list0 )[ colnames( soil_crop_list0 ) == "location" ] <- "focus_soil"
    # colnames( soil_crop_list0 )[ colnames( soil_crop_list0 ) == "name" ]     <- "focus_crop"
    
    # soil_crop0 <- data.frame(
        # "soil"  = c(     "chat",        "onn",   "nas" ), 
        # "crop"  = c( "cer, win", "sugarbeets", "grass" ), 
        # stringsAsFactors = FALSE 
    # )   
    
    # .muc_match_soil_crop( soil_crop = soil_crop0, soil_crop_list = soil_crop_list0 )
    
    # #   Error: No match (soils)
    # soil_crop0b <- data.frame(
        # "soil"  = c(  "nowhere",        "onn" ), 
        # "crop"  = c( "cer, win", "sugarbeets" ), 
        # stringsAsFactors = FALSE 
    # )   
    
    # .muc_match_soil_crop( soil_crop = soil_crop0b, soil_crop_list = soil_crop_list0 )

    # #   Error: No match (crop)
    # soil_crop0c <- data.frame(
        # "soil"  = c( "chat",          "onn" ), 
        # "crop"  = c( "banana", "sugarbeets" ), 
        # stringsAsFactors = FALSE 
    # )   
    
    # .muc_match_soil_crop( soil_crop = soil_crop0c, soil_crop_list = soil_crop_list0 )

    # #   Error: Multiple match (soils)
    # soil_crop0d <- data.frame(
        # "soil"  = c(        "D",        "onn" ), 
        # "crop"  = c( "cer, win", "sugarbeets" ), 
        # stringsAsFactors = FALSE 
    # )   
    
    # .muc_match_soil_crop( soil_crop = soil_crop0d, soil_crop_list = soil_crop_list0 )

    # #   Error: Multiple match (crop)
    # soil_crop0e <- data.frame(
        # "soil"  = c(    "chat",        "onn" ), 
        # "crop"  = c( "ea, in", "sugarbeets" ), 
        # stringsAsFactors = FALSE 
    # )   
    
    # .muc_match_soil_crop( soil_crop = soil_crop0e, soil_crop_list = soil_crop_list0 )
    

