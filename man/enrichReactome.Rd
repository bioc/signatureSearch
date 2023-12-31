% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/oraAnalyzer.R
\name{enrichReactome}
\alias{enrichReactome}
\title{Reactome Enrichment Analysis of a gene set.
Given a vector of genes, this function will return the enriched Reactome 
pathways with FDR control from hypergeometric test.}
\usage{
enrichReactome(
  gene,
  organism = "human",
  pvalueCutoff = 0.05,
  pAdjustMethod = "BH",
  qvalueCutoff = 0.2,
  universe,
  minGSSize = 5,
  maxGSSize = 500,
  readable = FALSE
)
}
\arguments{
\item{gene}{a vector of entrez gene id.}

\item{organism}{one of "human", "rat", "mouse", "celegans", "yeast", 
"zebrafish", "fly".}

\item{pvalueCutoff}{Cutoff value of pvalue.}

\item{pAdjustMethod}{one of "holm", "hochberg", "hommel", "bonferroni", 
"BH", "BY", "fdr", "none"}

\item{qvalueCutoff}{Cutoff value of qvalue}

\item{universe}{background genes}

\item{minGSSize}{minimal size of genes annotated by functional term for testing.}

\item{maxGSSize}{maximal size of each gene set for analyzing}

\item{readable}{TRUE or FALSE indicating whether to convert gene Entrez ids
to gene Symbols in the 'itemID' column in the FEA result table.}
}
\value{
A \code{feaResult} instance.
}
\description{
Reactome Enrichment Analysis of a gene set.
Given a vector of genes, this function will return the enriched Reactome 
pathways with FDR control from hypergeometric test.
}
\examples{
# This method supports duplicated elements in "gene"
gene <- c(rep("4312",4), rep("8318",2), "991", "10874")
#data(geneList, package="DOSE")
#rc <- enrichReactome(gene=gene, universe=names(geneList))
#result(rc)
}
\seealso{
\code{\link{feaResult-class}}
}
