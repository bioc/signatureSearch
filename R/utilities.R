sep_pcf <- function(res){
    new <- as.data.frame(t(vapply(seq_len(nrow(res)), function(i)
        unlist(strsplit(as.character(res$set[i]), "__")), 
        FUN.VALUE=character(3))), stringsAsFactors=FALSE)
    colnames(new) = c("pert", "cell", "type")
    res <- cbind(new, res[,-1])
    return(res)
}

readHDF5mat <- function(h5file, colindex=1:10) {
    m <- h5read(h5file, "assay", index=list(NULL, colindex))
    mycol <- h5read(h5file, "colnames", index=list(colindex, 1))
    myrow <- h5read(h5file, "rownames")
    rownames(m) <- as.character(myrow[,1])
    colnames(m) <- as.character(mycol[,1])
    return(m)
}

getH5dim <- function(h5file){
    mat_dim <- h5ls(h5file)$dim[1]
    mat_ncol <- as.numeric(gsub(".* x ","", mat_dim))
    mat_nrow <- as.numeric(gsub(" x .*","", mat_dim))
    return(c(mat_nrow, mat_ncol))
}

#' @importFrom AnnotationHub AnnotationHub
ah <- suppressMessages(AnnotationHub())