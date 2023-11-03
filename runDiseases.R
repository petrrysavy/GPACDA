args = commandArgs(trailingOnly=TRUE)
print(args)

source('annotate.R')
source('goterms.R')
source('diseaseAnnotation.R')
loadDiseaseData()

print(buildGOM)

library("openxlsx")

resultsToDataFrame <- function(results) {
    names <- slotNames('annotationResult')
    df <- sapply(names, function(name) lapply(results, function(r) { if(is.null(r)) NA else slot(r, name) }))
    df <- as.data.frame(df)
    # order the data frame
    df <- df[order(unlist(df[,"pvalue"])),]
    colnames(df)[which(names(df) == "goSize")] <- "diseaseAssociations"
    colnames(df)[which(names(df) == "goTerms")] <- "disease"
    return(df)
}

runOnCirc <- function(circRNA) {
    print(paste("CircRNA to annotate:", circname))
    results <- annotateCirc(circRNA, goTermNames)
    df <- resultsToDataFrame(results)
    df <- cbind(df, bonferroni=p.adjust(df[,"pvalue"], method="bonferroni"), fdr=p.adjust(df[,"pvalue"], method="fdr"))
    df[is.na(df)]<-''
    write.xlsx(df, paste(circRNA, "-diseases.xlsx", sep=""), row.names = TRUE)
}

#runOnCirc("hsa_circ_0007694")
#runOnCirc("hsa_circ_0000228")
#runOnCirc("hsa_circ_0003793")

for(circname in args) {
    runOnCirc(circname)
}
