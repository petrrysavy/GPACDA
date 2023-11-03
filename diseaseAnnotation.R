# install disgenet:
# devtools::install_bitbucket("ibi_group/disgenet2r")
# HMDD3, mir2disease in downloaded tsvs

#source("loginDisGenet.R")
source("disease2geneCache.R")
#results <- disease2gene( disease = c("C0036341", "C0002395", "C0030567","C0005586"), database = "CURATED", verbose = TRUE , api_key=disgenetAuthKey)

loadCirc2disease <- function() {
    circ2disease <- read.delim("diseasedata/Circ2Disease_Association.tsv", sep="\t", header = FALSE)
    circ2disease <- circ2disease[,c(1,10)]
    colnames(circ2disease) <- c("circRNA", "disease")
    circ2disease <- subset(circ2disease, startsWith(circRNA, "hsa_circ_"))
    circ2disease$disease <- tolower(circ2disease$disease)
    return(circ2disease)
}

loadCDASOR <- function() {
    circ2disease <- read.delim("diseasedata/cdasor.tsv", sep="\t", header = FALSE)
    circ2disease <- circ2disease[,c(2,5)]
    colnames(circ2disease) <- c("circRNA", "disease")
    circ2disease <- subset(circ2disease, startsWith(circRNA, "hsa_circ_"))
    circ2disease$disease <- tolower(circ2disease$disease)
    return(circ2disease)
}

diseaseList <- function() {
    circ2disease <- read.delim("diseasedata/Circ2Disease_Association.tsv", sep="\t", header = FALSE)
    circ2disease <- circ2disease[,c(1,10)]
    colnames(circ2disease) <- c("circRNA", "disease")
    circ2disease$disease <- tolower(circ2disease$disease)
    return(unique(circ2disease$disease))
}

loadDiseaseData <- function(circRNASource="Circ2disease") {
    # circ - disease mapping
    if(circRNASource == "Circ2disease") {
        circ2disease <<- loadCirc2disease()
    } else if(circRNASource == "CDASOR") {
        circ2disease <<- loadCDASOR()
    }

    # mirna-disease mapping
    mir2disease <- read.delim("diseasedata/mir2disease.tsv", sep="\t", header=FALSE)
    mir2disease <- mir2disease[,c(1,2)]
    colnames(mir2disease) <- c("miRNA", "disease")

    hmdd3 <- read.delim("diseasedata/hmdd3.tsv", sep="\t", header=TRUE)
    hmdd3 <- hmdd3[,c("mir", "disease")]
    colnames(hmdd3) <- c("miRNA", "disease")

    mirna2disease <<- rbind(mir2disease, hmdd3)
    mirna2disease$disease <<- tolower(mirna2disease$disease)

    # disgenet2r
    disassdisgenet <<- read.delim("diseasedata/disease_associations.tsv", sep="\t", header=TRUE)
    disassdisgenet$diseaseName <<- tolower(disassdisgenet$diseaseName)

    # the names of available diseses
    goTermNames <<- diseaseList()
    goTerms <<- goTermNames
    
    readDisease2GeneCache()
}

simplifiedCdasor <- function(keepOnlyKnown = TRUE) {
    diseases <- diseaseList()   
    cdasor <- loadCDASOR()
    
    for(disease in diseases) {
        if(sum(grepl(disease, diseases)) == 1) {
            cdasor$disease[grepl(disease, cdasor$disease)] <- disease
        }
    }
    cdasor <- unique(cdasor)
    if(keepOnlyKnown) {
        cdasor <- cdasor[cdasor$disease %in% diseases,]
    }
    return(cdasor)
}

buildGOMu <- function(diseaseName) {
    mirnas <- mirna2disease$miRNA[grepl(diseaseName, mirna2disease$disease)]
    return(as.numeric(all_mirna_list %in% mirnas))
}

disease2genes <- function(diseaseName) {
    ids <- disassdisgenet$diseaseId[grepl(diseaseName, disassdisgenet$diseaseName)]
    results <- disease2gene( disease = ids, database = "CURATED", verbose = TRUE , api_key=disgenetAuthKey)
    if(is.null(results) || is.character(results) && results == "no results for the query") { return(c()) }
    genes <-  results@qresult$gene_symbol
    return(genes)
}

buildGOM <- function(diseaseName) {
    if(!is.null(disease2geneCache)) {
        genes <- disease2geneCache$gene[disease2geneCache$disease == diseaseName]
    } else {
        genes <- disease2genes(diseaseName)
    }
    return(as.numeric(all_gene_list %in% genes))
}

