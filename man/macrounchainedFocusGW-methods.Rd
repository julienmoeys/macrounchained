% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/macrounchained.r
\docType{methods}
\name{macrounchainedFocusGW}
\alias{macrounchainedFocusGW}
\alias{macrounchainedFocusGW.data.frame}
\title{Batch run MACRO In FOCUS groundwater simulations with different substance properties and application patterns}
\usage{
macrounchainedFocusGW(s, ...)

\method{macrounchainedFocusGW}{data.frame}(s, parfile, verbose = 1L,
  indump = TRUE, run = TRUE, overwrite = FALSE,
  dt50_depth_f = NULL, anonymise = TRUE, archive = TRUE, ...)
}
\arguments{
\item{s}{See \code{\link[macrounchained]{macrounchained-methods}}, 
with the exception of the column \code{f_int}, that should 
not be provided here, as it is internally set to 0\%.
The results are analysed automatically with 
\code{\link[macroutils2:macroutilsFocusGWConc-methods]{macroutilsFocusGWConc}} and 
\code{\link[macrounchained:macroutilsFocusGWConc_summary-methods]{macroutilsFocusGWConc_summary}}.}

\item{\dots}{See \code{\link[macrounchained]{macrounchained-methods}}.}

\item{parfile}{See \code{\link[macrounchained]{macrounchained-methods}}.}

\item{verbose}{See \code{\link[macrounchained]{macrounchained-methods}}.}

\item{indump}{See \code{\link[macrounchained]{macrounchained-methods}}.}

\item{run}{See \code{\link[macrounchained]{macrounchained-methods}}.}

\item{overwrite}{See \code{\link[macrounchained]{macrounchained-methods}}.}

\item{dt50_depth_f}{See \code{\link[rmacrolite:rmacroliteDegradation-methods]{rmacroliteDegradation}}.}

\item{anonymise}{See \code{\link[macrounchained]{macrounchained-methods}}.}

\item{archive}{See \code{\link[macrounchained]{macrounchained-methods}}.}
}
\value{
TO BE WRITTEN.
}
\description{
Batch run MACRO In FOCUS groundwater simulations with 
 different substance properties and application patterns, 
 starting from a template imported MACRO par-file, 
 including metabolites. Wrapper for 
 \code{\link[macrounchained]{macrounchained-methods}}.
}
