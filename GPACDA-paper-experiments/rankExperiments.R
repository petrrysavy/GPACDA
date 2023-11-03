# read the data
library(openxlsx)
library(ggplot2)
allPredictions <- read.xlsx("diseases-small/allDiseases.xlsx")
allPredictions$fdr <- as.numeric(allPredictions$fdr)
allPredictions$pvalue <- as.numeric(allPredictions$pvalue)
colnames(allPredictions)[2] <- "disease"

# load ground truth
source('diseaseAnnotation.R')
loadDiseaseData()

source('buildGraph.R')
circRNAs <- unique(circ_mirna_map$circRNA)

OUT_OF_THE_BOX_RANK <- max(table(allPredictions$circRNA)) + 1

circ2disease <<- simplifiedCdasor()
circ2disease <- circ2disease[circ2disease$circRNA %in% circRNAs,]

plotRank <- function(filename) {
    rank <- c()

    for(i in 1:nrow(circ2disease)) {
        circRNA <- circ2disease[i, "circRNA"]
        disease <- circ2disease[i, "disease"]
        selected <- allPredictions[allPredictions$circRNA == circRNA,]
        if(disease %in% selected$disease) {
            pvalue <- selected[selected$disease == disease,"pvalue"]
            if(is.na(pvalue) || pvalue == 1.0) {
                irank <- OUT_OF_THE_BOX_RANK
            } else {
                irank <- sum(selected$pvalue < pvalue, na.rm=TRUE)
        }}
        else {
            irank <- OUT_OF_THE_BOX_RANK
        }
        rank <- c(rank, irank)
    }

    meanrank <- mean(rank[rank != OUT_OF_THE_BOX_RANK])
    ggplot(data=data.frame(rank), aes(x=rank)) +
    geom_histogram(binwidth = 1)+
    geom_vline(xintercept = meanrank, color = "red", linewidth = 2)+
    xlab("rank")+
    ylab("disease count")
    ggsave(filename)
}

plotRank("rank.pdf")

allPredictions <- allPredictions[!is.na(allPredictions$pvalue) & (allPredictions$pvalue < 1.0),]
circ2disease <- circ2disease[do.call(paste0, circ2disease) %in% do.call(paste0, allPredictions[,c(1,2)]),]

plotRank("rank-clean.pdf")

plotRankInverse <- function(filename) {
    rank <- c()

    for(i in 1:nrow(circ2disease)) {
        circRNA <- circ2disease[i, "circRNA"]
        disease <- circ2disease[i, "disease"]
        selected <- allPredictions[allPredictions$disease == disease,]
        if(circRNA %in% selected$circRNA) {
            pvalue <- selected[selected$circRNA == circRNA,"fdr"]
            if(is.na(pvalue) || pvalue == 1.0) {
                irank <- OUT_OF_THE_BOX_RANK
            } else {
                irank <- sum(selected$fdr < pvalue, na.rm=TRUE)
        }}
        else {
            irank <- OUT_OF_THE_BOX_RANK
        }
        rank <- c(rank, irank)
    }

    meanrank <- mean(rank[rank != OUT_OF_THE_BOX_RANK])
    ggplot(data=data.frame(rank), aes(x=rank)) +
    geom_histogram(binwidth = 100)+
    geom_vline(xintercept = meanrank, color = "red", linewidth = 2)+
    xlab("rank")+
    ylab("circRNA count")
    ggsave(filename)
    
    return(rank)
}

rank <- plotRankInverse("rank-inverse-clean.pdf")
print(paste("Top 200:", sum(rank <= 200)))



