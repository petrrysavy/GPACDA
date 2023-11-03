#source("diseaseAnnotation.R")
# loadData()
# buildDisease2GeneCache()

disease2geneCache <- NULL

buildDisease2GeneCache <- function(diseaseList = unique(circ2disease$disease)) {
    df <- data.frame(matrix(ncol = 2, nrow = 0))
    for(diseaseName in diseaseList) {
        print(paste("Probing:",diseaseName))
        tryCatch({
            genes <- disease2genes(diseaseName)
            if(length(genes) > 0) {
                df <- rbind(df, cbind(genes, diseaseName))
            }
        })
    }
    colnames(df) <- c("gene", "disease")
    write.csv(df, "gene2disease.csv", row.names=FALSE, quote=FALSE) 
    return(df)
}

readDisease2GeneCache <- function() {
    result = tryCatch({
        disease2geneCache <<- read.csv("gene2disease.csv")
    }, error = function(e) {
        warning("WARN: disease 2 gene cache not loaded")
    })
}
