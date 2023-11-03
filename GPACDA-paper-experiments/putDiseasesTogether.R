library(openxlsx)

source('buildGraph.R')
circRNAs <- unique(circ_mirna_map$circRNA)

allRecords <- c()
for(circRNA in circRNAs) {
    tryCatch({
        data <- read.xlsx(paste(circRNA, "-diseases.xlsx", sep=""), rowNames=FALSE)
        data <- cbind(circRNA, data)
        allRecords <- rbind(allRecords, data)
    }, error=function(cond) {
        print(paste("Cannot read file : ", circRNA, "-diseases.xlsx", sep=""))
    })
}

write.xlsx(allRecords, file="allDiseases.xlsx")
