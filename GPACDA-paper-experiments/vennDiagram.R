library(VennDiagram)

library(tidyverse)
library(tm)
library(proustr)

library("readxl")


# load the GPACDA data
library(openxlsx)
# load ground truth
source('buildGraph.R')
circRNAs <- unique(circ_mirna_map$circRNA)

source('diseaseAnnotation.R')
loadDiseaseData()
circ2disease <<- simplifiedCdasor()
circ2disease <- circ2disease[circ2disease$circRNA %in% circRNAs,]

# the p-value threshold
allPredictions <- read.xlsx("diseases-small/allDiseases.xlsx")
allPredictions$pvalue <- as.numeric(allPredictions$pvalue)
allPredictions <- allPredictions[!is.na(allPredictions$pvalue) & (allPredictions$pvalue < 1.0),]
circ2disease <- circ2disease[do.call(paste0, circ2disease) %in% do.call(paste0, allPredictions[,c(1,2)]),]
allPredictions$fdr <- as.numeric(allPredictions$fdr)
allPredictions <- allPredictions[!is.na(allPredictions$fdr) & (allPredictions$fdr <= 0.05),]
#allPredictions <- allPredictions[do.call(paste0, allPredictions) %in% do.call(paste0, circ2disease),]
allPredictions <- allPredictions[,c(1,2)]
GPACDA <- do.call(paste0, allPredictions)

cleanCDARes <- function(results) {
    retval <- c()

    colnames(results) <- tolower(colnames(results))
    for(circRNA in circRNAs) {
        for(j in 1:ncol(results)) {
            results[grepl(circRNA, results[,j]),j] <- circRNA
        }
    }
    
    for(i in 1:ncol(results)) {
        disease <- colnames(results)[i]
        for(circRNA in results[,i]) {
            if(!is.na(circRNA) && circRNA != "") {
               retval <- c(retval, paste0(circRNA, disease))
            }
        }
    }
    
    return(retval)
}

NCPCDAO <- as.data.frame(read_excel("diseasedata/NCPDA.xls"))
NCPCDA <- cleanCDARes(NCPCDAO)

DWNCPCDAO <- as.data.frame(read_excel("diseasedata/DWNCPDA.xls"))
DWNCPCDA <- cleanCDARes(DWNCPCDAO)

venn.diagram(
  x = list(
    GPACDA , 
    NCPCDA , 
    DWNCPCDA
    ),
  category.names = c("GPACDA (pval<0.05)" , "NCPCDA" , "DWNCPCDA"),
  filename = 'venn.png',
  output = TRUE ,
          imagetype="png" ,
          height = 480 , 
          width = 480 , 
          resolution = 300,
          compression = "lzw",
          lwd = 1,
          col=c("#440154ff", '#21908dff', '#fd3e25ff'),
          fill = c(alpha("#440154ff",0.3), alpha('#21908dff',0.3), alpha('#fd3e25ff',0.3)),
          cex = 0.5,
          fontfamily = "sans",
          cat.cex = 0.3,
          cat.default.pos = "outer",
          cat.pos = c(-27, 27, 135),
          cat.dist = c(0.055, 0.055, 0.085),
          cat.fontfamily = "sans",
          cat.col = c("#440154ff", '#21908dff', '#fd3e25ff'),
          rotation = 1
        )

print(paste("GPACDA, NCPCDA disese list overlap:", sum(unique(allPredictions[,2]) %in% tolower(colnames(NCPCDAO)))))
print(paste("GPACDA, DWNCPCDA disese list overlap:", sum(unique(allPredictions[,2]) %in% tolower(colnames(DWNCPCDAO)))))
diseaseAllOverlap <- intersect(intersect(unique(allPredictions[,2]), tolower(colnames(NCPCDAO))), tolower(colnames(DWNCPCDAO)))

filterWithDiseases <- function(list, diseases) {
    index <- logical(length(list))
    for(disease in diseases) {
        index <- index | grepl(disease, list)
    }
    return(list[index])
}

GPACDAs <- filterWithDiseases(GPACDA, diseaseAllOverlap)
NCPCDAs <- filterWithDiseases(NCPCDA, diseaseAllOverlap)
DWNCPCDAs <- filterWithDiseases(DWNCPCDA, diseaseAllOverlap)

venn.diagram(
  x = list(
    GPACDAs , 
    NCPCDAs , 
    DWNCPCDAs
    ),
  category.names = c("GPACDA (pval<0.05)" , "NCPCDA" , "DWNCPCDA"),
  filename = 'venn-common.png',
  output = TRUE ,
          imagetype="png" ,
          height = 480 , 
          width = 480 , 
          resolution = 300,
          compression = "lzw",
          lwd = 1,
          col=c("#440154ff", '#21908dff', '#fd3e25ff'),
          fill = c(alpha("#440154ff",0.3), alpha('#21908dff',0.3), alpha('#fd3e25ff',0.3)),
          cex = 0.5,
          fontfamily = "sans",
          cat.cex = 0.3,
          cat.default.pos = "outer",
          cat.pos = c(-27, 27, 135),
          cat.dist = c(0.055, 0.055, 0.085),
          cat.fontfamily = "sans",
          cat.col = c("#440154ff", '#21908dff', '#fd3e25ff'),
          rotation = 1
        )
