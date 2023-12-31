% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gseAnalyzer2.R
\name{gseKEGG2}
\alias{gseKEGG2}
\title{Modified GSEA with KEGG}
\usage{
gseKEGG2(
  geneList,
  organism = "hsa",
  keyType = "kegg",
  exponent = 1,
  nproc = 1,
  nPerm = 1000,
  minGSSize = 10,
  maxGSSize = 500,
  pvalueCutoff = 0.05,
  pAdjustMethod = "BH",
  verbose = TRUE,
  readable = FALSE
)
}
\arguments{
\item{geneList}{named numeric vector with gene ids in the name slot 
decreasingly ranked by scores in the data slot.}

\item{organism}{supported organism listed in
URL: http://www.genome.jp/kegg/catalog/org_list.html}

\item{keyType}{one of "kegg", 'ncbi-geneid', 'ncib-proteinid' and 'uniprot'}

\item{exponent}{weight of each step}

\item{nproc}{if not equal to zero, sets \code{BPPARAM} to use \code{nproc} 
workers (default = 1)}

\item{nPerm}{permutation numbers}

\item{minGSSize}{integer, minimum size of each gene set in annotation system}

\item{maxGSSize}{integer, maximum size of each gene set in annotation system}

\item{pvalueCutoff}{pvalue cutoff}

\item{pAdjustMethod}{pvalue adjustment method}

\item{verbose}{print message or not}

\item{readable}{TRUE or FALSE indicating whether to convert gene Entrez ids
to gene Symbols in the 'itemID' column in the FEA result table.}
}
\value{
feaResult object
}
\description{
This modified Gene Set Enrichment Analysis (GSEA) of KEGG pathways supports
gene test sets with large numbers of zeros.
}
\examples{
# Gene Entrez id should be used for KEGG enrichment
data(geneList, package="DOSE")
#geneList[100:length(geneList)]=0
#gsekk <- gseKEGG2(geneList=geneList, pvalueCutoff = 1)
#head(gsekk)
}
