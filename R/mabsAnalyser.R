##' MeanAbs enrichment analysis with GO terms.
##'
##' @title MeanAbs Enrichment Analysis for GO
##' @param geneList named numeric vector with gene SYMBOLs in the name slot 
##' decreasingly ranked by scores in the data slot.
##' @param ont one of "BP", "MF", "CC" or "ALL"
##' @param OrgDb OrgDb
##' @param keyType keytype of gene
##' @param nPerm permutation numbers
##' @param minGSSize integer, minimum size of each gene set in annotation system
##' @param maxGSSize integer, maximum size of each gene set in annotation system
##' @param pvalueCutoff pvalue cutoff
##' @param pAdjustMethod pvalue adjustment method
##' @return \code{\link{feaResult}} object
##' @author Yuzhu Duan
##' @examples 
##' data(targetList)
##' #mg <- mabsGO(geneList=targetList, ont="MF", OrgDb="org.Hs.eg.db",
##' #             pvalueCutoff=1)
##' #head(mg)
##' @export
mabsGO <- function(geneList,
                  ont           = "BP",
                  OrgDb,
                  keyType       = "SYMBOL",
                  nPerm         = 1000,
                  minGSSize     = 5,
                  maxGSSize     = 500,
                  pvalueCutoff  = 0.05,
                  pAdjustMethod = "BH") {

    ont %<>% toupper
    ont <- match.arg(ont, c("BP", "CC", "MF", "ALL"))
    
    res <-  mabs_internal(geneList = geneList,
                          nPerm = nPerm,
                          minGSSize = minGSSize,
                          maxGSSize = maxGSSize,
                          pvalueCutoff = pvalueCutoff,
                          pAdjustMethod = pAdjustMethod,
                          USER_DATA = GO_DATA)

    if (is.null(res))
        return(res)
    res <- select_ont(res, ont, GO_DATA)
    og(res) <- get_organism(OrgDb)
    ont(res) <- ont
    return(res)
}

##' MeanAbs enrichment analysis with KEGG pathways.
##'
##' @title MeanAbs Enrichment Analysis for KEGG
##' @param geneList named numeric vector with gene/target ids in the name slot 
##' decreasingly ranked by scores in the data slot.
##' @param organism supported organism listed in 
##' URL: http://www.genome.jp/kegg/catalog/org_list.html
##' @param keyType one of 'kegg', 'ncbi-geneid', 'ncib-proteinid' and 'uniprot'
##' @param nPerm permutation numbers
##' @param minGSSize integer, minimum size of each gene set in annotation system
##' @param maxGSSize integer, maximum size of each gene set in annotation system
##' @param pvalueCutoff pvalue cutoff
##' @param pAdjustMethod pvalue adjustment method
##' @param readable TRUE or FALSE indicating whether to convert gene Entrez ids
##' to gene Symbols in the 'itemID' column in the FEA result table.
##' @return \code{\link{feaResult}} object
##' @examples 
##' # Gene Entrez id should be used for KEGG enrichment
##' data(geneList, package="DOSE")
##' #geneList[100:length(geneList)]=0
##' #mk <- mabsKEGG(geneList=geneList, pvalueCutoff = 1)
##' #head(mk)
##' @export
mabsKEGG <- function(geneList,
                    organism          = 'hsa',
                    keyType           = 'kegg',
                    nPerm             = 1000,
                    minGSSize         = 5,
                    maxGSSize         = 500,
                    pvalueCutoff      = 0.05,
                    pAdjustMethod     = "BH", readable=FALSE) {

    species <- organismMapper(organism)
    KEGG_DATA <- prepare_KEGG(species, "KEGG", keyType)

    res <-  mabs_internal(geneList = geneList,
                          nPerm = nPerm,
                          minGSSize = minGSSize,
                          maxGSSize = maxGSSize,
                          pvalueCutoff = pvalueCutoff,
                          pAdjustMethod = pAdjustMethod,
                          USER_DATA = KEGG_DATA)

    if (is.null(res))
        return(res)
    if(readable) result(res) <- set_readable(result(res))
    og(res) <- species
    ont(res) <- "KEGG"
    return(res)
}

##' MeanAbs enrichment analysis with Reactome pathways.
##'
##' @title MeanAbs Enrichment Analysis for Reactome
##' @param geneList named numeric vector with gene/target ids in the name slot 
##' decreasingly ranked by scores in the data slot.
##' @param organism one of "human", "rat", "mouse", "celegans", "yeast", 
##' "zebrafish", "fly".
##' @param nPerm permutation numbers
##' @param minGSSize integer, minimum size of each gene set in annotation system
##' @param maxGSSize integer, maximum size of each gene set in annotation system
##' @param pvalueCutoff pvalue cutoff
##' @param pAdjustMethod pvalue adjustment method
##' @param readable TRUE or FALSE indicating whether to convert gene Entrez ids
##' to gene Symbols in the 'itemID' column in the FEA result table.
##' @return \code{\link{feaResult}} object
##' @examples 
##' # Gene Entrez id should be used for Reactome enrichment
##' data(geneList, package="DOSE")
##' #geneList[100:length(geneList)]=0
##' #rc <- mabsReactome(geneList=geneList, pvalueCutoff = 1)
##' @export
mabsReactome <- function(geneList, organism='human',
                         nPerm             = 1000,
                         minGSSize         = 5,
                         maxGSSize         = 500,
                         pvalueCutoff      = 0.05,
                         pAdjustMethod     = "BH", readable=FALSE) {
    Reactome_DATA <- get_Reactome_DATA(organism)
    
    res <-  mabs_internal(geneList = geneList,
                          nPerm = nPerm,
                          minGSSize = minGSSize,
                          maxGSSize = maxGSSize,
                          pvalueCutoff = pvalueCutoff,
                          pAdjustMethod = pAdjustMethod,
                          USER_DATA = Reactome_DATA)
    
    if (is.null(res))
        return(res)
    if(readable) result(res) <- set_readable(result(res))
    og(res) <- organism
    ont(res) <- "Reactome"
    return(res)
}

