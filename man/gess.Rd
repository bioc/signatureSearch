% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gess_cmap.R, R/gess_cor.R, R/gess_fisher.R,
%   R/gess_gcmap.R, R/gess_lincs.R
\name{gess_cmap}
\alias{gess_cmap}
\alias{gess_cor}
\alias{gess_fisher}
\alias{gess_gcmap}
\alias{gess_lincs}
\title{GESS Methods}
\usage{
gess_cmap(
  qSig,
  chunk_size = 5000,
  ref_trts = NULL,
  workers = 1,
  cmp_annot_tb = NULL,
  by = "pert",
  cmp_name_col = "pert",
  addAnnotations = TRUE
)

gess_cor(
  qSig,
  method = "spearman",
  chunk_size = 5000,
  ref_trts = NULL,
  workers = 1,
  cmp_annot_tb = NULL,
  by = "pert",
  cmp_name_col = "pert",
  addAnnotations = TRUE
)

gess_fisher(
  qSig,
  higher = NULL,
  lower = NULL,
  padj = NULL,
  chunk_size = 5000,
  ref_trts = NULL,
  workers = 1,
  cmp_annot_tb = NULL,
  by = "pert",
  cmp_name_col = "pert",
  addAnnotations = TRUE
)

gess_gcmap(
  qSig,
  higher = NULL,
  lower = NULL,
  padj = NULL,
  chunk_size = 5000,
  ref_trts = NULL,
  workers = 1,
  cmp_annot_tb = NULL,
  by = "pert",
  cmp_name_col = "pert",
  addAnnotations = TRUE
)

gess_lincs(
  qSig,
  tau = FALSE,
  sortby = "NCS",
  chunk_size = 5000,
  ref_trts = NULL,
  workers = 1,
  cmp_annot_tb = NULL,
  by = "pert",
  cmp_name_col = "pert",
  GeneType = "reference",
  addAnnotations = TRUE
)
}
\arguments{
\item{qSig}{\code{\link{qSig}} object defining the query signature including
the GESS method (should be 'LINCS') and the path to the reference database.
For details see help of \code{qSig} and \code{qSig-class}.}

\item{chunk_size}{number of database entries to process per iteration to
limit memory usage of search.}

\item{ref_trts}{character vector. If users want to search against a subset
of the reference database, they could set ref_trts as a character vector
representing column names (treatments) of the subsetted refdb.}

\item{workers}{integer(1) number of workers for searching the reference
database parallelly, default is 1.}

\item{cmp_annot_tb}{data.frame or tibble of compound annotation table. 
This table contains annotation information for compounds stored under
\code{pert} column of \code{gess_tb}. Set to \code{NULL} if not available.
This table should not contain columns with names of "t_gn_sym", "MOAss" or 
"PCIDss", these three columns will be added internally and thus conserved by 
the function. If they are contained in \code{cmp_annot_tb}, they will be
overwritten. If users want to maintain these three columns in the provided 
annotation table, give them different names.}

\item{by}{character(1), column name in \code{cmp_annot_tb} that can be merged
with \code{pert} column in \code{gess_tb}. If \code{refdb} is set 
as 'lincs2', it will be merged with \code{pert_id} column in the GESS result 
table. If \code{cmp_annot_tb} is NULL, \code{by} is ignored.}

\item{cmp_name_col}{character(1), column name in \code{gess_tb} or 
\code{cmp_annot_tb} that store compound names. If there is no compound name 
column, set to \code{NULL}. If \code{cmp_name_col} is available, 
three additional columns (t_gn_sym, MOAss, PCIDss) are automatically added 
by using \code{\link{get_targets}}, CLUE touchstone compound MOA annotation, 
and 2017 \code{lincs_pert_info} annotation table, respectively as 
annotation sources. t_gn_sym: target gene symbol, MOAss: MOA annotated from 
signatureSearch, PCIDss: PubChem CID annotated from signatureSearch.}

\item{addAnnotations}{Logical value.  If \code{TRUE} adds drug annotations to results.}

\item{method}{One of 'spearman' (default), 'kendall', or 'pearson',
indicating which correlation coefficient to use.}

\item{higher}{The 'upper' threshold. If not 'NULL', genes with a score
larger than or equal to 'higher' will be included in the gene set with
sign +1. At least one of 'lower' and 'higher' must be specified.

\code{higher} argument need to be set as \code{1} if the \code{refdb} in
\code{qSig} is path to the HDF5 file that were converted from the gmt file.}

\item{lower}{The lower threshold. If not 'NULL', genes with a score smaller
than or equal 'lower' will be included in the gene set with sign -1.
At least one of 'lower' and 'higher' must be specified.

\code{lower} argument need to be set as \code{NULL} if the \code{refdb} in
\code{qSig} is path to the HDF5 file that were converted from the gmt file.}

\item{padj}{numeric(1), cutoff of adjusted p-value or false discovery rate
(FDR) of defining DEGs that is less than or equal to 'padj'. The 'padj'
argument is valid only if the reference HDF5 file contains the p-value
matrix stored in the dataset named as 'padj'.}

\item{tau}{TRUE or FALSE, whether to compute the tau score. Note, TRUE is
only meaningful when the full LINCS database is searched, since accurate Tau
score calculation depends on the usage of the exact same database their
background values are based on.}

\item{sortby}{sort the GESS result table based on one of the following
statistics: `WTCS`, `NCS`, `Tau`, `NCSct` or `NA`}

\item{GeneType}{A character value of either "reference" or a combination of 
"best inferred", "landmark" or "inferred" indicating which reference gene set 
query genes should be filtered against. While "reference" filters query genes 
against the reference database, "best inferred", "landmark" or 
"inferred" filter genes against LINCS gene spaces.}
}
\value{
\code{\link{gessResult}} object, the result table contains the
search results for each perturbagen in the reference database ranked by
their signature similarity to the query.
}
\description{
The CMAP search method implements the original Gene Expression Signature 
Search (GESS) from Lamb et al (2006) known as Connectivity Map (CMap). 
The method uses as query the two label sets of the most up- and 
down-regulated genes from a genome-wide expression experiment, while the 
reference database is composed of rank transformed expression profiles 
(e.g. ranks of LFC or z-scores).

Correlation-based similarity metrics, such as Spearman or Pearson 
coefficients, can be used as Gene Expression Signature Search (GESS) methods.
As non-set-based methods, they require quantitative gene expression values 
for both the query and the database entries, such as normalized intensities 
or read counts from microarrays or RNA-Seq experiments, respectively.

In its iterative form, Fisher's exact test (Upton, 1992) can be used as Gene 
Expression Signature (GES) Search to scan GES databases for entries that 
are similar to a query GES.

The gCMAP search method adapts the Gene Expression Signature Search (GESS) 
method from the gCMAP package (Sandmann et al. 2014) to make it compatible 
with the database containers and methods defined by \code{signatureSearch}. 
The specific GESS method, called gCMAP, uses as query a rank transformed GES 
and the reference database is composed of the labels of up and down regulated 
DEG sets.

LINCS search method implements the Gene Expression Signature Search (GESS) from
Subramanian et al, 2017, here referred to as LINCS. The method uses as
query the two label sets of the most up- and down-regulated genes from a
genome-wide expression experiment, while the reference database is composed
of differential gene expression values (e.g. LFC or z-scores). Note, the
related CMAP method uses here ranks instead.
}
\details{
Lamb et al. (2006) introduced the gene expression-based search method known 
as Connectivity Map (CMap) where a GES database is searched with a query GES 
for similar entries. Specifically, this GESS method uses as query the two 
label sets of the most up- and down-regulated genes from a genome-wide 
expression experiment, while the reference database is composed of rank 
transformed expression profiles (e.g.ranks of LFC or z-scores). The actual 
GESS algorithm is based on a vectorized rank difference calculation. The 
resulting Connectivity Score expresses to what degree the query up/down gene 
sets are enriched on the top and bottom of the database entries, 
respectively. The search results are a list of perturbagens such as drugs 
that induce similar or opposing GESs as the query. Similar GESs suggest 
similar physiological effects of the corresponding perturbagens. 
Although several variants of the CMAP algorithm are available in other 
software packages including Bioconductor, the implementation provided by
\code{signatureSearch} follows the original description of the authors as 
closely as possible.

For correlation searches to work, it is important that both the query and
reference database contain the same type of gene identifiers. The expected 
data structure of the query is a matrix with a single numeric column and the 
gene labels (e.g. Entrez Gene IDs) in the row name slot. For convenience, the
correlation-based searches can either be performed with the full set of genes
represented in the database or a subset of them. The latter can be useful to
focus the computation for the correlation values on certain genes of interest
such as a DEG set or the genes in a pathway of interest. For comparing the
performance of different GESS methods, it can also be advantageous to subset
the genes used for a correlation-based search to same set used in a set-based
search, such as the up/down DEGs used in a LINCS GESS. This way the search
results of correlation- and set-based methods can be more comparable because
both are provided with equivalent information content.

When using the Fisher's exact test (Upton, 1992) as GES Search (GESS) method,
both the query and the database are composed of gene label sets, such as 
DEG sets.

The Bioconductor gCMAP (Sandmann et al. 2014) package provides access to a 
related but not identical implementation of the original CMAP algorithm 
proposed by Lamb et al. (2006). It uses as query a rank transformed GES and 
the reference database is composed of the labels of up and down regulated 
DEG sets. This is the opposite situation of the original CMAP method from 
Lamb et al (2006), where the query is composed of the labels of up and down 
regulated DEGs and the database contains rank transformed GESs.

Subramanian et al. (2017) introduced a more complex GESS algorithm,
here referred to as LINCS. While related to CMAP, there are several important
differences among the two approaches. First, LINCS weights the query genes
based on the corresponding differential expression scores of the GESs in the
reference database (e.g. LFC or z-scores). Thus, the reference database used
by LINCS needs to store the actual score values rather than their ranks.
Another relevant difference is that the LINCS algorithm uses a bi-directional
weighted Kolmogorov-Smirnov enrichment statistic (ES) as similarity metric.
}
\section{Column description}{

Descriptions of the columns in GESS result tables.
\itemize{
  \item pert: character, perturbagen (e.g. drugs) in the reference
  database. The treatment/column names of the reference database are
  organized as \code{pert__cell__trt_cp} format. The \code{pert} column in
  GESS result table contains what stored under the \code{pert} slot of the
  column names.
  \item cell: character, acronym of cell type
  \item type: character, perturbation type. In the CMAP/LINCS
  databases provided by \code{signatureSearchData}, the perturbation types
  are currently treatments with drug-like compounds (trt_cp). If required,
  users can build custom signature database with other types of
  perturbagens (e.g., gene knockdown or over-expression events) with the
  provided \code{\link{build_custom_db}} function.
  \item trend: character, up or down when the reference signature is
  positively or negatively connected with the query signature,
  respectively.
  \item N_upset: integer, number of genes in the query up set
  \item N_downset: integer, number of genes in the query down set
  \item WTCS: Weighted Connectivity Score, a bi-directional Enrichment
  Score for an up/down query set. If the ES values of an up set and a down
  set are of different signs, then WTCS is (ESup-ESdown)/2, otherwise,
  it is 0. WTCS values range from -1 to 1. They are positive or negative
  for signatures that are positively or inversely related, respectively,
  and close to zero for signatures that are unrelated.
  \item WTCS_Pval: Nominal p-value of WTCS computed by comparing WTCS
  against a null distribution of WTCS values obtained from a large number
  of random queries (e.g. 1000).
  \item WTCS_FDR: False discovery rate of WTCS_Pval.
  \item NCS: Normalized Connectivity Score. To make connectivity scores
  comparable across cell types and perturbation types,
  the scores are normalized. Given a vector of WTCS
  values w resulting from a query, the values are normalized within each
  cell line c and perturbagen type t to obtain NCS by dividing the WTCS
  value with the signed mean of the WTCS values within
  the subset of the signatures in the reference database corresponding to c
  and t.
  \item Tau: Enrichment score standardized for a given database.
  The Tau score compares an observed NCS to a large set of NCS values that
  have been pre-computed for a specific reference database. The query results
  are scored with Tau as a standardized measure ranging from 100 to -100.
  A Tau of 90 indicates that only 10% of reference perturbations exhibit
  stronger connectivity to the query. This way one can make more meaningful
  comparisons across query results.

  Note, there are NAs in the Tau score column, the reason is that the number
  of signatures in \emph{Qref} that match the cell line of signature \emph{r}
  (the \code{TauRefSize} column in the GESS result) is less than 500,
  Tau will be set as NA since it is redeemed as there are not large enough
  samples for computing meaningful Tau scores.

  \item TauRefSize: Size of reference perturbations for computing Tau.
  \item NCSct: NCS summarized across cell types. Given a vector of NCS values
  for perturbagen p, relative to query q, across all cell lines c in which p
  was profiled, a cell-summarized connectivity score is obtained using a
  maximum quantile statistic. It compares the 67 and 33 quantiles of
  NCSp,c and retains whichever is of higher absolute magnitude.
  \item cor_score: Correlation coefficient based on the method defined in
  the \code{gess_cor} function.
  \item raw_score: bi-directional enrichment score (Kolmogorov-Smirnov
  statistic) of up and down set in the query signature
  \item scaled_score: raw_score scaled to values from 1 to -1 by
  dividing the positive and negative scores with the maximum positive score
  and the absolute value of the minimum negative score, respectively.
  \item effect: Scaled bi-directional enrichment score corresponding to
  the scaled_score under the CMAP result.
  \item nSet: number of genes in the GES in the reference
  database (gene sets) after setting the higher and lower cutoff.
  \item nFound: number of genes in the GESs of the reference
  database (gene sets) that are also present in the query GES.
  \item signed: whether gene sets in the reference database have signs,
  representing up and down regulated genes when computing scores.
  \item pval: p-value of the Fisher's exact test.
  \item padj: p-value adjusted for multiple hypothesis testing using
  R's p.adjust function with the Benjamini & Hochberg (BH) method.
  \item effect: z-score based on the standard normal distribution.
  \item LOR: Log Odds Ratio.
  \item t_gn_sym: character, symbol of the gene encoding the
  corresponding drug target protein
  \item MOAss: character, compound MOA annotation from \code{signatureSearch}
  package
  \item PCIDss: character, compound PubChem CID annotation from
  \code{signatureSearch} package
}
}

\examples{
db_path <- system.file("extdata", "sample_db.h5", 
                       package = "signatureSearch")
# library(SummarizedExperiment); library(HDF5Array)
# sample_db <- SummarizedExperiment(HDF5Array(db_path, name="assay"))
# rownames(sample_db) <- HDF5Array(db_path, name="rownames")
# colnames(sample_db) <- HDF5Array(db_path, name="colnames")
## get "vorinostat__SKB__trt_cp" signature drawn from sample database
# query_mat <- as.matrix(assay(sample_db[,"vorinostat__SKB__trt_cp"]))

############## CMAP method ##############
# qsig_cmap <- qSig(query=list(
#                     upset=c("230", "5357", "2015", "2542", "1759"),
#                     downset=c("22864", "9338", "54793", "10384", "27000")),
#                   gess_method="CMAP", refdb=db_path)
# cmap <- gess_cmap(qSig=qsig_cmap, chunk_size=5000)
# result(cmap)

######## Correlation-based GESS method #########
# qsig_sp <- qSig(query=query_mat, gess_method="Cor", refdb=db_path)
# sp <- gess_cor(qSig=qsig_sp, method="spearman")
# result(sp)

############## Fisher's Exact Test ##########
# qsig_fisher <- qSig(query=query_mat, gess_method="Fisher", refdb=db_path)
# fisher <- gess_fisher(qSig=qsig_fisher, higher=1, lower=-1)
# result(fisher)

############## gCMAP method ##############
# qsig_gcmap <- qSig(query=query_mat, gess_method="gCMAP", refdb=db_path)
# gcmap <- gess_gcmap(qsig_gcmap, higher=1, lower=-1)
# result(gcmap)

############### LINCS method #############
# qsig_lincs <- qSig(query=list(
#                      upset=c("230", "5357", "2015", "2542", "1759"),
#                      downset=c("22864", "9338", "54793", "10384", "27000")),
#                    gess_method="LINCS", refdb=db_path)
# lincs <- gess_lincs(qsig_lincs, sortby="NCS", tau=FALSE)
# result(lincs)
}
\references{
For detailed description of the LINCS method and scores,
please refer to: Subramanian, A., Narayan, R., Corsello, S. M., Peck, D. D.,
Natoli, T. E., Lu, X., Golub, T. R. (2017). A Next Generation
Connectivity Map: L1000 Platform and the First 1,000,000 Profiles. Cell,
171 (6), 1437-1452.e17. URL: https://doi.org/10.1016/j.cell.2017.10.049

For detailed description of the CMap method, please refer to:
Lamb, J., Crawford, E. D., Peck, D., Modell, J. W., Blat, I. C.,
Wrobel, M. J., Golub, T. R. (2006). The Connectivity Map:
using gene-expression signatures to connect small molecules, genes, and
disease. Science, 313 (5795), 1929-1935.
URL: https://doi.org/10.1126/science.1132939

Sandmann, T., Kummerfeld, S. K., Gentleman, R., & Bourgon, R.
(2014). gCMAP: user-friendly connectivity mapping with R. Bioinformatics ,
30 (1), 127-128. URL: https://doi.org/10.1093/bioinformatics/btt592

Graham J. G. Upton. 1992. Fisher's Exact Test. J. R. Stat. Soc. Ser. A
Stat. Soc. 155 (3). [Wiley, Royal Statistical Society]: 395-402.
URL: http://www.jstor.org/stable/2982890
}
\seealso{
\code{\link{qSig}}, \code{\link{gessResult}},
         \code{\link{addGESSannot}}
}
