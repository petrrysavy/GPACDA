disease <- "myelodysplastic syndrome"

source('annotate.R')
source('goterms.R')
source('diseaseAnnotation.R')
loadDiseaseData()
circRNAs <- unique(circ_mirna_map$circRNA)

library("openxlsx")

goTermNames <- c(disease)

results <- NULL
for(circRNA in circRNAs) {
    df <- annotateCirc(circRNA, c(disease))
    results <- rbind(results,
                     c(disease=disease,
                       circRNA=circRNA,
                       score=df$"myelodysplastic syndrome"@score,
                       pvalue=df$"myelodysplastic syndrome"@pvalue,
                       scorenorm=df$"myelodysplastic syndrome"@scorenorm,
                       expectedScore=df$"myelodysplastic syndrome"@expectedScore,
                       time=df$"myelodysplastic syndrome"@time,
                       pvalueTime=df$"myelodysplastic syndrome"@pvalueTime,
                       goSize=df$"myelodysplastic syndrome"@goSize))
}
results <- as.data.frame(results)
for(i in 3:9)
    results[,i] <- as.numeric(results[,i])
df <- results
df <- cbind(df, bonferroni=p.adjust(df[,"pvalue"], method="bonferroni"), fdr=p.adjust(df[,"pvalue"], method="fdr"))
df[is.na(df)]<-''
df <- df[order(unlist(df[,"pvalue"])),]
write.xlsx(df, paste("myelodysplastic-diseases.xlsx", sep=""), rowNames = TRUE)
