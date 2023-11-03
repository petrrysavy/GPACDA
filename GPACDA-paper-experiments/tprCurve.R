# read the data
library(openxlsx)
allPredictions <- read.xlsx("diseases-small/allDiseases.xlsx")
allPredictions$fdr <- as.numeric(allPredictions$fdr)
allPredictions$pvalue <- as.numeric(allPredictions$pvalue)


# load ground truth
source('diseaseAnnotation.R')
loadDiseaseData()

# sample for each p-value threshold
confusion <- function(pvalueThreshold) {
    predictions <- allPredictions[!is.na(allPredictions$fdr) & (allPredictions$fdr <= pvalueThreshold),c(1, 2)]
    iv <- do.call(paste0, circ2disease) %in% do.call(paste0, predictions)
    tp <- sum(iv)
    fn <- sum(1-iv)
    return(list(tp = tp, fn = fn, tpr = tp/(tp+fn)))
}

# now calcualte the tp/fn rate plot
pvalues <- seq(from=0, to=1.0, by=0.0005)
tps <- sapply(pvalues, function(pval) { return(confusion(pval)$tp) })

library(ggplot2)
ggplot(data=data.frame(pvalues, tps), aes(x=pvalues, y=tps)) +
  geom_line()+
  geom_point()+
  xlab("pvalue")+
  ylab("truepositives")
ggsave("tpositives.pdf")

circ2disease <<- simplifiedCdasor()
tps <- sapply(pvalues, function(pval) { return(confusion(pval)$tp) })

ggplot(data=data.frame(pvalues, tps), aes(x=pvalues, y=tps)) +
  geom_line()+
  geom_point()+
  xlab("pvalue")+
  ylab("truepositives")
ggsave("tpositivesCDASOR.pdf")

# Use this code to select only values that are supported by the interaction graph
allPredictions <- allPredictions[!is.na(allPredictions$pvalue) & (allPredictions$pvalue < 1.0),]
circ2disease <- circ2disease[do.call(paste0, circ2disease) %in% do.call(paste0, allPredictions[,c(1,2)]),]

tps <- sapply(pvalues, function(pval) { return(confusion(pval)$tp) })

ggplot(data=data.frame(pvalues, tps), aes(x=pvalues, y=tps)) +
  geom_line()+
  geom_point()+
  xlab("pvalue - FDR")+
  ylab("truepositives")
ggsave("tpositivesCDASORclean.pdf")

print(paste("pvalue:", pvalues[101]))
print(paste("@0.05:", tps[101]))

print(paste("pvalue:", pvalues[201]))
print(paste("@0.1:", tps[201]))

print(paste("unsuccsessful:", tps[length(tps)] - tps[length(tps) - 1]))


