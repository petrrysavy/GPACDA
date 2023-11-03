# downloads the differentially expressed circRNAs interactions
# from the circinteractome database by queriing it one per minute

options(max.print=100)
source('circinteractome.R')

# first open the file with ordered circRNA data
source('diseaseAnnotation.R')
loadDiseaseData()
source('buildGraph.R')
cdasor <- loadCDASOR()

circRNAs <- unique(cdasor$circRNA[! cdasor$circRNA %in% circ_mirna_map$circRNA])

loadMap <- function() {
    tryCatch({
        map <- read.csv('circrna-mirna-interactions.csv')
        subset(map, select = -c(X) )
    }, error = function(e) {
        data.frame(circRNA=character(0),miRNAs=character(0))
    })
}

for(circRNA in circRNAs) {
    map <- loadMap()
    if(circRNA %in% map$circRNA) { next }
    print(paste("querying", circRNA))
    tryCatch({
        miRNAs <- circInteractome(circRNA)
        if(length(miRNAs) == 0) {
            print("No miRNAs")
            next
        }
        newRows <- cbind(circRNA, miRNAs)
        print("New rows:")
        print(newRows)
        map <- rbind(map, newRows)
        write.csv(as.data.frame(map), file='circrna-mirna-interactions.csv')
    }, error=function(cond) {
        print("Error loading the database:")
        print(cond)
    })
    Sys.sleep(50)
}
