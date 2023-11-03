library("readxl")
library(openxlsx)
library(ggplot2)

source('buildGraph.R')
circRNAs <- unique(circ_mirna_map$circRNA)

source('diseaseAnnotation.R')
loadDiseaseData()
circ2disease <<- simplifiedCdasor()
circ2disease <- circ2disease[circ2disease$circRNA %in% circRNAs,]

# filter those that are not connected to have the same 421 dataset
allPredictions <- read.xlsx("diseases-small/allDiseases.xlsx")
allPredictions$pvalue <- as.numeric(allPredictions$pvalue)
allPredictions <- allPredictions[!is.na(allPredictions$pvalue) & (allPredictions$pvalue < 1.0),]
circ2disease <- circ2disease[do.call(paste0, circ2disease) %in% do.call(paste0, allPredictions[,c(1,2)]),]
#circRNAs <- unique(circ2disease[,1]) # not this one ...
write.xlsx(circ2disease, "diseases-small/disease-test-dataset.xlsx")

circRNAnum <- length(circRNAs)
OUT_OF_THE_BOX_RANK <- circRNAnum

plotRank <- function(filename) {
    for(circRNA in circRNAs) {
        for(j in 1:ncol(results)) {
            results[grepl(circRNA, results[,j]),j] <- circRNA
        }
    }
    rank <- c()

    for(i in 1:nrow(circ2disease)) {
        circRNA <- circ2disease[i, "circRNA"]
        disease <- circ2disease[i, "disease"]
        
        if(disease %in% colnames(results)) {
            selected <- results[,disease]
            
            if(circRNA %in% selected) {
                selected <- selected[selected %in% circRNAs]
                irank <- which(selected == circRNA)[[1]]
            }
            else {
                irank <- OUT_OF_THE_BOX_RANK
            }
            print(irank)
            rank <- c(rank, irank)
        }
    }

    #meanrank <- mean(rank[rank != OUT_OF_THE_BOX_RANK])
    meanrank <- mean(rank)
    ggplot(data=data.frame(rank), aes(x=rank)) +
    geom_histogram(binwidth = 100)+
    geom_vline(xintercept = meanrank, color = "red", linewidth = 2)+
    xlab("rank")+
    ylab("circRNA count")
    ggsave(filename)
    
    return(rank)
}

countDiseases <- function(results) {
    n <- 0
    for(disease in unique(circ2disease$disease)) {
        if(disease %in% colnames(results)) {
            n <- n+1
        }
    }
    return(n)
}

results <- as.data.frame(read_excel("diseasedata/NCPDA.xls"))
colnames(results) <- tolower(colnames(results))
print(paste("NCPCDA diseases:", countDiseases(results)))
ncpcda <- plotRank("NCPDArank.pdf")

results <- as.data.frame(read_excel("diseasedata/DWNCPDA.xls"))
colnames(results) <- tolower(colnames(results))
print(paste("DWNCPCDA diseases:", countDiseases(results)))
dwncpcda <- plotRank("DWNCPDArank.pdf")
