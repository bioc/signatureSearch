% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AllClasses.R
\docType{class}
\name{gessResult-class}
\alias{gessResult-class}
\title{gessResult object}
\description{
The \code{gessResult} object organizes Gene Expression Signature Search 
(GESS) results. This includes the main tabular result of a GESS, its query 
signature, the name of the chosen GESS method and the path to the reference
database.
}
\section{Slots}{

\describe{
\item{\code{result}}{tibble object containing the search results for each
perturbagen (e.g. drugs) in the reference database ranked by their
signature similarity to the query. The result table can be extracted via
the \code{\link{result}} accessor function.}

\item{\code{query}}{query signature}

\item{\code{gess_method}}{name of the GESS method}

\item{\code{refdb}}{path to the reference database}
}}

\keyword{classes}
