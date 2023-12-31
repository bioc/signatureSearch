##' It builds a `qSig` object to store the query signature, reference database
##' and GESS method used for GESS methods.
##' @title Helper Function to Construct a \code{\link{qSig}} Object
##' @param query If 'gess_method' is 'CMAP' or 'LINCS', it should be a list with
##' two character vectors named \code{upset} and \code{downset} for up- and
##' down-regulated gene labels, respectively. The labels should be gene Entrez
##' IDs if the reference database is a pre-built CMAP or LINCS database. If a
##' custom database is used, the labels need to be of the same type as those in
##' the reference database.
##' 
##' If 'gess_method' is 'gCMAP', the query is a matrix with a single column
##' representing gene ranks from a biological state of interest. The 
##' corresponding gene labels are stored in the row name slot of the matrix. 
##' Instead of ranks one can provide scores (e.g. z-scores). In such a case, 
##' the scores will be internally transformed to ranks. 
##' 
##' If 'gess_method' is 'Fisher', the query is expected to be a list with two
##' character vectors named \code{upset} and \code{downset} for up- and
##' down-regulated gene labels, respectively (same as for 'CMAP' or 'LINCS' 
##' method). Internally, the up/down gene labels are combined into a single 
##' gene set when querying the reference database with the Fisher's exact test. 
##' This means the query is performed with an unsigned set. The query can also 
##' be a matrix with a single numeric column and the gene labels (e.g. Entrez 
##' gene IDs) in the row name slot. The values in this matrix can be z-scores 
##' or LFCs. In this case, the actual query gene set is obtained according to 
##' upper and lower cutoffs in the \code{gess_fisher} function set by the user.
##' 
##' If 'gess_method' is 'Cor', the query is a matrix with a single numeric 
##' column and the gene labels in the row name slot. The numeric column can 
##' contain z-scores, LFCs, (normalized) gene expression intensity values or 
##' read counts.
##' @param gess_method one of 'CMAP', 'LINCS', 'gCMAP', 'Fisher' or 'Cor'
##' @param refdb character(1), can be one of "cmap", "cmap_expr", "lincs", 
##' "lincs_expr", "lincs2" when using the CMAP/LINCS databases from the affiliated
##' \code{signatureSearchData} package. With 'cmap' the database contains
##' signatures of LFC scores obtained from DEG analysis routines; with
##' 'cmap_expr' normalized gene expression values; with 'lincs' or 'lincs2'
##' z-scores obtained from the DEG analysis methods of the LINCS project; and with
##' 'lincs_expr' normalized expression values.
##' 
##' To use a custom database, it should be the file path to the HDF5 
##' file generated with the \code{\link{build_custom_db}} function, the HDF5
##' file needs to have the \code{.h5} extension. 
##' 
##' When the \code{gess_method} is set as 'gCMAP' or 'Fisher', it could also be 
##' the file path to the HDF5 file converted from the gmt file containing 
##' gene sets by using \code{\link{gmt2h5}} function. For example, the gmt files 
##' could be from the MSigDB 
##' \url{https://www.gsea-msigdb.org/gsea/msigdb/index.jsp} 
##' or GSKB \url{http://ge-lab.org/#/data}.
##' 
##' @return \code{qSig} object
##' @seealso \code{\link{build_custom_db}}, 
##' \code{\link[signatureSearchData]{signatureSearchData}},
##' \code{\link{gmt2h5}}, \code{\link{qSig-class}}
##' @examples 
##' db_path <- system.file("extdata", "sample_db.h5", 
##'                        package = "signatureSearch")
##' qsig_lincs <- qSig(query=list(
##'                      upset=c("230", "5357", "2015", "2542", "1759"), 
##'                      downset=c("22864", "9338", "54793", "10384", "27000")), 
##'                    gess_method="LINCS", refdb=db_path)
##' qmat <- matrix(runif(5), nrow=5)
##' rownames(qmat) <- c("230", "5357", "2015", "2542", "1759")
##' colnames(qmat) <- "treatment"
##' qsig_gcmap <- qSig(query=qmat, gess_method="gCMAP", refdb=db_path)
##' @export
qSig <- function(query, gess_method, refdb){
    db_path <- determine_refdb(refdb)
    ## Validity check of refdb
    if(!any(refdb %in% c("cmap","cmap_expr","lincs","lincs_expr"))){
      if(grepl("\\.h5", refdb)){
        ref_val <- h5read(refdb, "assay", c(1,1))
        if(!is.numeric(ref_val)) 
          stop("The matrix value stored in refdb should be numeric!")
      }
    }
    if(is(query, "list")){
      if(any(gess_method %in% c("CMAP", "LINCS", "Fisher"))){
        upset <- query$upset
        downset <- query$downset
        gid_db <- h5read(db_path, "rownames", drop=TRUE)
        
        ## Validity checks of upset and downset
        if(all(c(!is.character(upset), !is.null(upset)))) 
          stop("upset of 'query' slot needs to be ID character vector or NULL")
        if(all(c(!is.character(downset), !is.null(downset)))) 
          stop("downset of 'query' slot needs to be ID character vector or NULL")
        if(is.null(upset) & is.null(downset)) 
          stop("both or one of the upset and downset in 'query' slot need to be 
             assigned query entrez IDs as character vector")
        ## Remove entries in up/down set not present in reference database
        if(!is.null(upset)){
          message(paste(sum(upset %in% gid_db), "/", length(upset), 
                  "genes in up set share identifiers with reference database"))
          upset <- upset[upset %in% gid_db]
          if(length(upset)==0){
              warning("upset shares zero idenifiers with reference database!")
              upset <- NULL
          }
        }
        if(!is.null(downset)){
          message(paste(sum(downset %in% gid_db),"/",length(downset), 
                "genes in down set share identifiers with reference database"))
          downset <- downset[downset %in% gid_db]
          if(length(downset)==0){
              warning("downset shares zero identifiers with reference database!")
              downset <- NULL
          }
        }
        if(is.null(upset) & is.null(downset)){
            stop("Both upset and downset share zero identifiers with reference database, 
          please make sure that at least one share identifiers!")
        }
        query$upset <- upset
        query$downset <- downset
      } else {
          stop("'gess_method' slot must be one of 'CMAP', 'LINCS', or 
      'Fisher' if 'qsig' is a list of up and down gene labels!")
      }
      new("qSig", query=query, gess_method=gess_method, refdb=refdb, db_path=db_path)
    } else if (is(query, "matrix")){
      if(any(gess_method %in% c("gCMAP", "Fisher", "Cor"))){
        gid_db <- h5read(db_path, "rownames", drop=TRUE)
        
        if(! is.numeric(query[1,1]) | ncol(query) != 1) 
          stop("The 'query' should be a numeric matrix with one column!")
        if(is.null(rownames(query))) 
          stop("The gene labels should be stored in the row name slot of the 
             matrix!")
        if(sum(rownames(query) %in% gid_db)==0) 
          stop("The gene labels in the query matrix share 0 identifiers with 
             reference database!")
        if(gess_method == "Cor"){
          query <- query[rownames(query) %in% gid_db, 1, drop=FALSE]
        }
      } else
        stop("'gess_method' slot must be one of 'gCMAP', 'Fisher' or 'Cor' 
  if 'qsig' is a numeric matrix with gene labels in the row name slot!")
      new("qSig", query=query, gess_method=gess_method, refdb=refdb, db_path=db_path)
    } else {
   stop("'query' needs to be either a list or a matrix with one column") 
    }
}

##' @name show
##' @docType methods
##' @rdname show-methods
##' @aliases show,qSig-method
##' @exportMethod show
setMethod("show", c(object="qSig"),
    function (object) {
        cat("#\n# qSig object used for GESS analysis \n#\n")
        q <- qr(object)
        if(is(q, "list")){
            if(length(q$upset)>10){
                cat("@query", "\t", "up gene set", 
                    paste0("(", length(q$upset), "):"), 
                    "\t", q$upset[seq_len(10)], "... \n")
            } else {
                cat("@query", "\t", "up gene set", 
                    paste0("(", length(q$upset), "):"), 
                    "\t", q$upset, "\n")
            }
            if(length(q$downset)>10){
                cat("     ", "\t", "down gene set", 
                    paste0("(", length(q$downset), "):"), 
                    "\t", q$downset[seq_len(10)], "... \n")
            } else {
                cat("     ", "\t", "down gene set", 
                    paste0("(", length(q$downset), "):"), 
                    "\t", q$downset, "\n")
            }
        }
        if(is(q, "matrix")){
            cat("@query\n")
            if(nrow(q)>10){
                print(head(q,10))
                cat("# ... with", nrow(q)-10, "more rows\n")
            } else {
                print(q)
            }
        }
        cat("\n@gess_method", "\t", gm(object), "\n")
        cat("\n@refdb", "\t", refdb(object), "\n")
        cat("\n@db_path", "\t", object@db_path, "\n")
    })

